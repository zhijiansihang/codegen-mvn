package net.eagle.utils;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.FileSystemUtils;
import org.springframework.util.StringUtils;

import com.fasterxml.jackson.databind.ObjectMapper;

import freemarker.template.Configuration;
import freemarker.template.Template;
import net.eagle.model.MMParam;
import net.eagle.model.MMService;
import net.zkbc.mmc.util.FreemarkerUtils;

/**
 * 
 */
@Component
public class ApiDataUtil implements InitializingBean{

	private static Log log = LogFactory.getLog(ApiDataUtil.class);
	
	private static final String ENCODING = "UTF-8";
	@Autowired
	AppVars appVars;
	
	private boolean inited = false;
	private String templateDirPath = "classpath:/serviceTemplate";
	private String serviceDirPath;

	//没有请求和响应参数的服务列表，按serviceName字母升序排列
	private Map<String, List<MMService>> serviceList;
	//serviceName做key的map，包含请求和响应参数
	private Map<String, Map<String, MMService>> serviceMap;
	
	public ApiDataUtil(){
	}
    public static ApiDataUtil  apiDataUtil = null ;
    public static ApiDataUtil getInstance()  
    {
        return apiDataUtil;
    }

	@Override
	public void afterPropertiesSet() throws Exception {
		initWithAppVars();
		apiDataUtil=this;
	}

    public void initWithAppVars() {
		if(!this.inited){
			this.appVars = appVars;
			this.serviceDirPath = this.appVars.dbServiceDirPath;
			this.serviceList = new HashMap<>();
			this.serviceMap = new HashMap<>();
		}
		
		this.inited = true;
	}
    
    public void loadProject(String project){
    	
    	this.serviceList.put(project, new ArrayList<MMService>());
		this.serviceMap.put(project, new HashMap<String, MMService>());
    	
    	this.loadFromJsonFile(project);
		this.sortServiceList(project);
    }
	
	private void loadFromJsonFile(String project){
		
		File targetRoot = new File(this.serviceDirPath +"/"+ project);
		log.info("[initFromJsonFile][读取文件内容][filePath:"+targetRoot.getAbsolutePath()+"]");
		File[] files = targetRoot.listFiles();
		for (File file : files) {
			String filePath = file.getPath();

			if (isJson(filePath)) {
				
				String jsonStr = null;
				try {
					jsonStr = FileCopyUtils.copyToString(new FileReader(filePath));
				} catch (IOException e) {
					e.printStackTrace();
				}

				if(null == jsonStr){
					log.info("[initFromJsonFile][读取文件内容为空][filePath:"+filePath+"]");
					continue;
				}
//				log.info(jsonStr);
				MMService service = this.parseServiceFromJson(jsonStr);
//				if(service.getServiceTitle() == null){ service.setServiceTitle(service.getServiceDesc());}
				
				MMService simpleService = new MMService();
				simpleService.setIsLogin(service.getIsLogin());
				simpleService.setNeedLogin(service.getNeedLogin());
				simpleService.setServiceDesc(service.getServiceDesc());
				simpleService.setServiceTitle(service.getServiceTitle());
				simpleService.setServiceName(service.getServiceName());
				
				this.serviceList.get(project).add(simpleService);
				this.serviceMap.get(project).put(service.getServiceName(), service);
			}
		}
	}
	
	private MMService parseServiceFromJson(String jsonStr){
		ObjectMapper mapper = new ObjectMapper();
		MMService service = null;
		try {
			service = mapper.readValue(jsonStr, MMService.class);
		} catch (IOException e) {
			e.printStackTrace();
		}
		if(null == service){
			log.error("[parseServiceFromJson][解析后service为空]");
			return null;
		}
		this.sortParamList(service.getRequestParams());
		this.sortParamList(service.getResponseParams());
		return service;
	}
	
	/**
	 * paramList按groupName, paramName字母升序排列
	 * */
	private void sortParamList(List<MMParam> paramList) {
		Collections.sort(paramList, new Comparator<MMParam>() {

			@Override
			public int compare(MMParam o1, MMParam o2) {
				if(StringUtils.isEmpty(o1.getParamGroupName()) && StringUtils.isEmpty(o2.getParamGroupName())){
					return o1.getParamName().compareTo(o2.getParamName());
				}else if(!StringUtils.isEmpty(o1.getParamGroupName()) && !StringUtils.isEmpty(o2.getParamGroupName())){
					if(o1.getParamGroupName().compareTo(o2.getParamGroupName()) == 0){
						return o1.getParamName().compareTo(o2.getParamName());
					}else{
						return o1.getParamGroupName().compareTo(o2.getParamGroupName());
					}
				}else if(StringUtils.isEmpty(o1.getParamGroupName())){
					return -1;
				}else{
					return 1;
				}
			}
		});
	}

	/**
	 * serviceList和serviceMap中删除数据，删除json数据文件
	 * @throws Exception 
	 * */
	public void delService(String project, String serviceName) throws Exception {
		
		if(!this.inited){
			throw new Exception("没有初始化");
		}
		this.serviceMap.get(project).remove(serviceName);
		MMService service = this.findServiceInList(project, serviceName);
		this.serviceList.get(project).remove(service);
		
		this.deleteJsonFile(project, serviceName);
	}

	/**
	 * 按serviceName在serviceList中找出service
	 * */
	private MMService findServiceInList(String project, String serviceName) {
		for(MMService service : this.serviceList.get(project)){
			if(service.getServiceName().equals(serviceName)){
				return service;
			}
		}
		return null;
	}

	/**
	 * serviceList和serviceMap中更新或添加数据，json数据存入文件
	 * @throws Exception 
	 * */
	public boolean saveService(String project, String oldServiceName, MMService service) throws Exception {
		if(!this.inited){
			throw new Exception("没有初始化");
		}
		if(StringUtils.isEmpty(oldServiceName)){
			return this.addService(project, service);
		}else{
			return this.updateService(project, oldServiceName, service);
		}
	}
	
	/**
	 * 更新service
	 * */
	private boolean updateService(String project, String oldServiceName, MMService service) {
		boolean saved = this.saveJsonFile(project, oldServiceName, service);
		if(saved){
			MMService oldService = this.findServiceInList(project, oldServiceName);
			this.serviceList.get(project).remove(oldService);
			this.serviceList.get(project).add(service);
			this.sortServiceList(project);
			
			this.sortParamList(service.getRequestParams());
			this.sortParamList(service.getResponseParams());
			this.serviceMap.get(project).remove(oldServiceName);
			this.serviceMap.get(project).put(service.getServiceName(), service);
		}
		
		return saved;
	}

	/**
	 * 新增service
	 * */
	private boolean addService(String project, MMService service) {
		boolean saved = this.saveJsonFile(project, null, service);
		if(saved){
			this.serviceList.get(project).add(service);
			this.sortServiceList(project);
			
			this.sortParamList(service.getRequestParams());
			this.sortParamList(service.getResponseParams());
			this.serviceMap.get(project).put(service.getServiceName(), service);
		}
		return saved;
	}

	/**
	 * serviceList按serviceName字母升序排列
	 * */
	private void sortServiceList(String project) {
		Collections.sort(this.serviceList.get(project), new Comparator<MMService>() {

			@Override
			public int compare(MMService o1, MMService o2) {
				return o1.getServiceName().compareTo(o2.getServiceName());
			}
		});
	}
	
	/**
	 * 将服务对应的json文件删除
	 * */
	private void deleteJsonFile(String project, String serviceName) {
		File targetRoot = new File(this.serviceDirPath +"/" + project);
		File out = new File(targetRoot, serviceName + ".json");
		FileSystemUtils.deleteRecursively(out);
	}

	/**
	 * 将json数据写入文件，每个服务一个文件。
	 * 写文件之前会先解析一下按模板生成的json字符串，如果解析失败返回false，不保存文件。
	 * 如果是更新服务，oldServiceName不为空，会在保存文件之前删除旧文件。
	 * */
	private boolean saveJsonFile(String project, String oldServiceName, MMService service){
		
		boolean result = false;
		String templatesPattern = this.templateDirPath + "/**/*";
		File targetRoot = new File(this.serviceDirPath +"/"+ project);

		PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();

		try {
			Resource templatesDir = resolver.getResource(this.templateDirPath);
			
			Configuration configuration = new Configuration(Configuration.DEFAULT_INCOMPATIBLE_IMPROVEMENTS);
			configuration.setDirectoryForTemplateLoading(templatesDir.getFile());

			for (Resource resource : resolver.getResources(templatesPattern)) {
				File srcFile = resource.getFile();

				if (srcFile.isDirectory()) {
					continue;
				}

				String resourcePath = resource.getURI().getPath();
				int index = resourcePath.lastIndexOf("/");
				String relativeURI = resourcePath.substring(index + 1);

				if (isTemplate(relativeURI)) {
					Template template = configuration.getTemplate(relativeURI, ENCODING);
					
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("service", service);
					
					String text = FreemarkerUtils.renderTemplate(template, map);
//					log.info(text);
					//先解析一下text，如果解析出错，就不写入文件了
					if(null != this.parseServiceFromJson(text)){
						if(null != oldServiceName){
							this.deleteJsonFile(project, oldServiceName);
						}
						
						String path = FreemarkerUtils.renderString(relativeURI, map);
						File out = new File(targetRoot, path.substring(0, path.length() - 4));
						out.getParentFile().mkdirs();
						FileCopyUtils.copy(text.getBytes(ENCODING), out);
						result = true;
					}else{
						result = false;
					}
					
					break;
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	private boolean isTemplate(String relativeURI) {
		return relativeURI.endsWith(".ftl");
	}
	
	private boolean isJson(String relativeURI) {
		return relativeURI.endsWith(".json");
	}

	public List<MMService> getServiceList(String project) {
		return serviceList.get(project);
	}

	public Map<String, MMService> getServiceMap(String project) {
		return serviceMap.get(project);
	}

	public void saveAllService(String project) throws Exception {
		if(!this.inited){
			throw new Exception("没有初始化");
		}
		Collection<MMService> services = this.serviceMap.get(project).values();
		for (MMService mmService : services) {
			this.saveJsonFile(project, mmService.getServiceName(), mmService);
		}
	}

	

}