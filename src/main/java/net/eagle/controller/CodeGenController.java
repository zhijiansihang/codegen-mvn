package net.eagle.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClients;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.util.FileSystemUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;

import net.eagle.model.MMService;
import net.eagle.script.MmcGenScript;
import net.eagle.utils.ApiDataUtil;
import net.eagle.utils.AppVars;
import net.eagle.utils.ZipUtil;

@RestController
public class CodeGenController {

	@Autowired
	AppVars appVars;
	@Autowired
	private MmcGenScript genCode;

	
	@RequestMapping(value = "/apis", method = { RequestMethod.GET, RequestMethod.POST })
	public List<MMService> apis(String project) {

		ApiDataUtil util = ApiDataUtil.getInstance();
		util.initWithAppVars(appVars);
		util.loadProject(project);
		
		return ApiDataUtil.getInstance().getServiceList(project);
	}

	@RequestMapping(value = "/serviceDetail", method = { RequestMethod.GET, RequestMethod.POST })
	public MMService serviceDetail(String project, String serviceName) {

		return ApiDataUtil.getInstance().getServiceMap(project).get(serviceName);
	}

	@RequestMapping(value = "/delService", method = { RequestMethod.GET, RequestMethod.POST })
	public List<MMService> delService(String project, String serviceName) {

		try {
			ApiDataUtil.getInstance().delService(project, serviceName);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return ApiDataUtil.getInstance().getServiceList(project);
	}

	@RequestMapping(value = "/saveService", method = { RequestMethod.GET, RequestMethod.POST })
	public List<MMService> saveService(String project, String oldServiceName, String service) {

		ObjectMapper mapper = new ObjectMapper();
		MMService serviceObj = null;
		try {
			serviceObj = mapper.readValue(service, MMService.class);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return new ArrayList<>();
		}

		if (null != serviceObj) {
			try {
				boolean result = ApiDataUtil.getInstance().saveService(project, oldServiceName, serviceObj);
				if(!result){
					return new ArrayList<>();
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				new ArrayList<>();
			}
		}

		return ApiDataUtil.getInstance().getServiceList(project);
	}
	
	/**
	 * 保存所有报文到json文件，一般是统一改了报文后使用。需要手动调用，页面没有入口。
	 * */
	@RequestMapping(value = "/saveAllService", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveAllService(String project) {

		try {
			ApiDataUtil.getInstance().saveAllService(project);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/genCode", method = { RequestMethod.GET, RequestMethod.POST })
	public String genCode(String project, String serviceNames, HttpServletRequest request) {
		String[] arr = serviceNames.split(",");
		
		boolean res = genCode.executeGen(project, arr,appVars.outputDir);
		if (res) {
			return "1";
		} else {
			return "0";
		}
	}

	@RequestMapping(value = "/downloadCode", method = { RequestMethod.GET, RequestMethod.POST })
	public void downloadCode(String project,HttpServletRequest request, HttpServletResponse response) {
		
//		String outputDir = "/"+project +"/";
//		String zipDest = "/"+project +"-zip/";
		
		// 把生成的代码压缩成zip包，提供下载
		String srcDir = appVars.outputDir+"/"+project +"/";
		String zipDestPath =appVars.outputDir+"/"+project +"-zip/";
		
//		String srcDir = request.getServletContext().getRealPath("/"+project +"/");
//		String zipDestPath = request.getServletContext().getRealPath("/"+project +"-zip/");
		//先删除旧压缩包
		File zipDir = new File(zipDestPath);
		File[] zipFiles = zipDir.listFiles(new FilenameFilter() {
			
			@Override
			public boolean accept(File dir, String name) {
				if(name.endsWith(".zip")){
					return true;
				}
				return false;
			}
		});
		if(null != zipFiles && zipFiles.length > 0){
			for (File file : zipFiles) {
				FileSystemUtils.deleteRecursively(file);
			}
		}
		
		//压缩后下载
		if(!zipDestPath.endsWith(File.separator)){
			zipDestPath += File.separator;
		}
		System.out.println("srcDir=" + srcDir);
		System.out.println("zipDestPath=" + zipDestPath);
		String zipFilePath = ZipUtil.zip(srcDir, zipDestPath, null);
		if (null != zipFilePath) {

			String filename = zipFilePath.substring(zipFilePath.lastIndexOf(File.separator) + 1);

			InputStream in = null;
			OutputStream out = null;
			try {
				response.setHeader("content-disposition",
						"attachment;filename=" + URLEncoder.encode(filename, "UTF-8"));
				in = new FileInputStream(zipFilePath);
				int len = 0;
				byte buf[] = new byte[1024];
				out = response.getOutputStream();
				while ((len = in.read(buf)) > 0) {
					out.write(buf, 0, len);
				}
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				if (in != null) {
					try {
						in.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}

				if (out != null) {
					try {
						out.close();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		}
	}
	
	@RequestMapping(value = "/testCode", method = { RequestMethod.GET, RequestMethod.POST })
	public String testCode(String project, HttpServletRequest request) {
		//1.生成所有代码
		//2.触发远程构建（复制生成的代码、构建，需要jenkins安全配置Allow anonymous read access）
//		String srcDir = request.getServletContext().getRealPath("/"+project +"/");
		boolean res = genCode.executeGen(project,null, appVars.outputDir);
		if (res) {
			HttpClient client = HttpClients.createDefault();
			HttpGet get = new HttpGet(this.appVars.jenkinsUrl+project);
			try {
				HttpResponse hp = client.execute(get);
				int statusCode = hp.getStatusLine().getStatusCode();
				System.out.println(get.getURI().getPath());
				System.out.println(statusCode);
				if(statusCode >= 200 && statusCode < 300){
					return "1";
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
			return "0";
		} else {
			return "0";
		}
	}
}
