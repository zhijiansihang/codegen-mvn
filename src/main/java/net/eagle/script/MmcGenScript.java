package net.eagle.script;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Component;
import org.springframework.util.FileCopyUtils;
import org.springframework.util.FileSystemUtils;

import freemarker.template.Configuration;
import freemarker.template.Template;
import net.eagle.model.MMParam;
import net.eagle.model.MMService;
import net.eagle.utils.ApiDataUtil;
import net.zkbc.mmc.script.context.MmcField;
import net.zkbc.mmc.script.context.MmcFieldGroup;
import net.zkbc.mmc.script.context.MmcMessage;
import net.zkbc.mmc.script.context.MmcRoot;
import net.zkbc.mmc.util.FreemarkerUtils;

@Component
public class MmcGenScript {
	private static final String ENCODING = "UTF-8";

	@Value("${mmc.javaPackage}")
	private String javaPackage;

	private String serviceProject;

	public boolean executeGen(String project, String[] serviceNameArr, String outputDir) {
		this.serviceProject = project;
		String templatesLocation = "classpath:/mmc/freemarker";
		String templatesSrc = "src";

		File targetRoot = new File(outputDir+"/"+project);
		//先删除旧文件
		FileSystemUtils.deleteRecursively(targetRoot);
		String templatesPattern = templatesLocation + "/" + templatesSrc + "/**/*";
		int pathStart = templatesSrc.length() + 1;

		PathMatchingResourcePatternResolver resolver = new PathMatchingResourcePatternResolver();
		Resource templates = resolver.getResource(templatesLocation);

		try {
			Configuration configuration = new Configuration(Configuration.DEFAULT_INCOMPATIBLE_IMPROVEMENTS);
			configuration.setDirectoryForTemplateLoading(templates.getFile());

			String templatesURI = templates.getURI().getPath();
			
			//用于生成单独文件
			MmcRoot root = getRoot(getServiceNameList(serviceNameArr));
			//用于生成MobileController
			MmcRoot rootWithAllService = getRoot(getServiceNameList(null));
//			MmcRoot rootWithAllService = root;
			String lib = buildInlineLib();

			for (Resource resource : resolver.getResources(templatesPattern)) {
				File srcFile = resource.getFile();

				if (srcFile.isDirectory()) {
					continue;
				}

				String relativeURI = resource.getURI().getPath().substring(templatesURI.length());

				if (isTemplate(relativeURI)) {
					Template template = configuration.getTemplate(relativeURI, ENCODING);
					if (isRootTemplate(relativeURI)) {
						//生成MobileController和单元测试类
						String path = FreemarkerUtils.renderString(relativeURI, rootWithAllService);
						File out = new File(targetRoot, path.substring(pathStart, path.length() - 9));
						String text = FreemarkerUtils.renderTemplate(template, rootWithAllService);

						out.getParentFile().mkdirs();
						FileCopyUtils.copy(text.getBytes(ENCODING), out);
					} else {
						for (MmcMessage message : root.getMessages()) {
							String path = FreemarkerUtils.renderString(lib + relativeURI, message);
							File out = new File(targetRoot, path.substring(pathStart, path.length() - 4));
							String text = FreemarkerUtils.renderTemplate(template, message);

							out.getParentFile().mkdirs();
							FileCopyUtils.copy(text.getBytes(ENCODING), out);
						}
					}
				} else {
					File out = new File(targetRoot,
							FreemarkerUtils.renderString(relativeURI.substring(pathStart), root));
					out.getParentFile().mkdirs();

					if (out.isHidden()) {
						out.createNewFile();
					}

					FileCopyUtils.copy(srcFile, out);
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		return true;
	}

	private String buildInlineLib() {
		StringBuffer buf = new StringBuffer();
		buf.append("<#function upper_case str><#return str?upper_case></#function>");
		buf.append("<#function lower_case str><#return str?lower_case></#function>");
		buf.append("<#function cap_first str><#return str?cap_first></#function>");
		return buf.toString();
	}

	private boolean isTemplate(String relativeURI) {
		return relativeURI.endsWith(".ftl");
	}

	private boolean isRootTemplate(String relativeURI) {
		return relativeURI.endsWith(".root.ftl");
	}
	
	private List<String> getServiceNameList(String[] serviceNameArr) {
		List<String> serviceNameList = new ArrayList<>();
		if(null != serviceNameArr){
			for(String serviceName : serviceNameArr){
				serviceNameList.add(serviceName);
			}
		}else{
			for (MMService service : ApiDataUtil.getInstance().getServiceList(this.serviceProject)) {
				serviceNameList.add(service.getServiceName());
			}
		}
		return serviceNameList;
	}

	private MmcRoot getRoot(List<String> serviceNameList) {
		MmcRoot root = new MmcRoot();
//		if ("zplan".equals(this.serviceProject)){
			root.setJavaPackage(javaPackage);
			root.setProject(this.serviceProject);
			root.setAndroidJavaPackage(javaPackage);
			root.setAndroidProject(this.serviceProject);
			root.setIosPrefix(this.serviceProject);
//		}else {
//			root.setJavaPackage(javaPackage);
//			root.setProject(mmlcProject);
//			root.setIosPrefix(mmlcProject);
//		}

		List<MmcMessage> messages = new ArrayList<MmcMessage>();
		root.setMessages(messages);

		for (String serviceName : serviceNameList) {
			MMService service = ApiDataUtil.getInstance().getServiceMap(this.serviceProject).get(serviceName);
			
			MmcMessage message = new MmcMessage();
			messages.add(message);

			message.setRoot(root);
			message.setId(service.getServiceName());
			message.setEncrypt(false);
			message.setSign(false);
			message.setAnon("N".equalsIgnoreCase(service.getNeedLogin()));
			message.setAuthcform("Y".equalsIgnoreCase(service.getIsLogin()));
			message.setDescription(service.getServiceTitle());
			message.setRequestFields(new ArrayList<MmcField>());
			message.setRequestGroups(new ArrayList<MmcFieldGroup>());
			message.setResponseFields(new ArrayList<MmcField>());
			message.setResponseGroups(new ArrayList<MmcFieldGroup>());

			buildFieldsAndGroups(service.getRequestParams(), message.getRequestFields(),
					message.getRequestGroups());
			buildFieldsAndGroups(service.getResponseParams(), message.getResponseFields(),
					message.getResponseGroups());
		}

		return root;
	}

	private void buildFieldsAndGroups(List<MMParam> elems, List<MmcField> fields, List<MmcFieldGroup> groups) {
		Map<String, MmcFieldGroup> groupMap = new LinkedHashMap<String, MmcFieldGroup>();
		for (MMParam elem : elems) {
			String groupId = elem.getParamGroupName();
			if (groupId == null || "".equals(groupId)) {
				appendToFields(elem, fields);
			} else {
				MmcFieldGroup group = groupMap.get(groupId);
				if (group == null) {
					group = new MmcFieldGroup();
					groupMap.put(groupId, group);

					group.setId(groupId);
					group.setDescription(elem.getParamGroupDesc());
					group.setFields(new ArrayList<MmcField>());
				}
				appendToFields(elem, group.getFields());
			}
		}
		groups.addAll(groupMap.values());
	}

	private void appendToFields(MMParam elem, List<MmcField> fields) {
		MmcField field = new MmcField();
		fields.add(field);

		field.setId(elem.getParamName());
		field.setDescription(elem.getParamDesc());
		field.setValueConst("");
		field.setValueExample(elem.getExampleValue());
		field.setDbType("varchar");
		field.setJavaType("String");
		field.setObjcType("NSString*");
		field.setValueLength(512);
		field.setValueScale(0);
		field.setEnc("Y".equalsIgnoreCase(elem.getIsEnc()));
	}

}
