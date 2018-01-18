package ${javaPackage}.${project};

import java.sql.Timestamp;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.TypeReference;
import com.google.common.collect.Lists;

import ${javaPackage}.common.Response;
import ${javaPackage}.common.RetCode;
import ${javaPackage}.${project}.gen.entity.*;
import ${javaPackage}.${project}.mmc.MobileMessage;
import ${javaPackage}.gateway.util.JwtTokenUtil;
import ${javaPackage}.gateway.util.UserSession;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.alibaba.fastjson.JSONObject;





/**
 *  单元测试
 * 
 * @author 代码生成器v1.0
 * 
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class AppTest {
  
	private static final Logger LOG = LoggerFactory.getLogger(AppTest.class);

	@Autowired
	private JwtTokenUtil jwtTokenUtil;

	private MockMvc mockMvc;

	private String sessionId;

	@Autowired
	protected WebApplicationContext wac;

	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
	}	
<#list messages as message>
	
	@Test
	public void ${message.id}() throws Exception {


		${message.name}Request request = new ${message.name}Request();
	<#list message.requestFields as field>
	    request.set${field.id?cap_first}("${field.valueExample?j_string}");
	</#list>
	<#list message.requestGroups as group>
		request.set${group.id?cap_first}(null);
	</#list>
		request.setChannelId("");
		request.setDeviceId("aa-bb-cc");
		request.setPlatformType("5");
		request.setVersionCode("101");
		request.setMsgtimestamp(new Timestamp(System.currentTimeMillis()).toString());
		request.setSessionId("");

		LOG.info("[${message.id}] ${message.description}接口请求数据:{}", request);
		String content = JSONObject.toJSONString(request);

		Response<MobileMessage> response = post(MobileMessage.class, content, "/app/${message.id}");

		LOG.info("[${message.id}] ${message.description}接口响应数据:{}:", response);

		if (response.getHeader().getCode().equals(RetCode.SUCCESS.getCode())){
			if ("test".equals(response.getBody().getMode())) {
				LOG.error("[appVersionUpdate] 检查版本更新接口未实现", "检查版本更新");
				return;
			}
		} else {
			Assert.fail();
		}
	}

</#list>

	@Test
	public void generateJwt(){

		// 返回jwt token
		UserSession session = new UserSession();
		session.setId(1L);
		session.setRoleNames(Lists.newArrayList("ADMIN"));
		session.setMobile("130151781002");
		session.setLoginName("admin");
		session.setDisabled(false);

		sessionId = jwtTokenUtil.generate(session);
		LOG.info(sessionId);
	}


	private <T extends MobileMessage> Response<T> post(Class<T> responseType, String content, String urlTemplate) throws Exception {

		MvcResult result = mockMvc.perform(MockMvcRequestBuilders.post(urlTemplate).content(content).contentType(MediaType.APPLICATION_JSON)).andReturn();

		Response<T>  response = JSONObject.parseObject(result.getResponse().getContentAsString(), new TypeReference<Response<T>>(){});

		return response;
	}



}