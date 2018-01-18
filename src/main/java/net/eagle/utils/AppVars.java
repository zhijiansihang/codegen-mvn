package net.eagle.utils;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component(AppVars.INSTNAME)
public class AppVars {

	public static final String INSTNAME = "appAppVars";

	@Value("${db.service.dirpath:/Users/shawn/Documents/code/finger/src/codegen/services/}")
	public String dbServiceDirPath;
	
	@Value("${jenkins.url:http://jenkins-ci:8080/view/MMC/job/mmt-ums/buildWithParameters?token=remoteBuild_mmt-ums&project=}")
	public String jenkinsUrl;
	
	@Value("${mmc.output.dir:/Users/shawn/Documents/code/finger/src/codegen/code}")
	public String outputDir;
	
}
