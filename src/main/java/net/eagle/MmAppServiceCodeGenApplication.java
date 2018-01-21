package net.eagle;

import net.eagle.utils.ApiDataUtil;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

@SpringBootApplication
public class MmAppServiceCodeGenApplication {
	public static void main(String[] args) {
		ConfigurableApplicationContext applicationContext = SpringApplication.run(MmAppServiceCodeGenApplication.class, args);
		applicationContext.getBean(ApiDataUtil.class);
	}
}
