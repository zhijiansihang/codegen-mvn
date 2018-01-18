package ${javaPackage}.${project}.gen.controller;

import com.zhijiansihang.common.*;
import ${javaPackage}.${project}.gen.entity.*;

import com.zhijiansihang.finger.mmc.MessageService;
import com.zhijiansihang.finger.mmc.MobileMessage;
import com.zhijiansihang.finger.mmc.MobileService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.concurrent.TimeUnit;

import com.fasterxml.jackson.databind.ObjectMapper;

@RequestMapping("/app")
@Controller("MobileController")
public class MobileController {

	private static final Logger LOG = LoggerFactory.getLogger(MobileController.class);

	@Value("${r'${redis.expire.timestamp.nonce:3}'}")
	public String redisExpireTimestampNonce;

	@Autowired
	private MobileService mobileService;

	@Autowired
	private RedisTemplate redisTemplate;

	private ObjectMapper objectMapper = new ObjectMapper();

	
<#list messages as message>
	@Qualifier("${message.id}Service")
	@Autowired(required = false)
	MessageService<${message.name}Request, Response<${message.name}Response>> ${message.id}Service;
	@Qualifier("gen${message.id}Service")
	@Autowired(required = false)
	MessageService<${message.name}Request, Response<${message.name}Response>> gen${message.name}Service;

</#list>


<#list messages as message>

	@RequestMapping(value = "/${message.id}", method = RequestMethod.POST)
	@ResponseBody
	public Response<${message.name}Response> ${message.id}(@RequestBody ${message.name}Request request) {

		logRequest("${message.id}", request);

  		Response<${message.name}Response> response = new Response<>();

		request = (${message.name}Request) this.validate(request, response);
		if(null == request){
			return response;
		}

		response = get${message.name}Response(request);
		
		logResponse("${message.id}", response);

		return response;
	}
</#list>

<#list messages as message>

	private Response<${message.name}Response> get${message.name}Response(${message.name}Request request) {

		MessageService<${message.name}Request, Response<${message.name}Response>> service = ${message.id}Service;
		if (service == null) {
			service = gen${message.name}Service;
		}

		return mobileService.service(request, service, ${message.name}Request.class, ${message.name}Response.class);
	}
</#list>

	/**
	* 请求数据校验
	*
	* @param request
	* @param response
	* @return
	*/
	private MobileMessage validate(MobileMessage request, Response response) {

		//版本校验
		if(StringUtils.isEmpty(request.getVersionCode())
		|| StringUtils.isEmpty(request.getMsgtimestamp())
		|| StringUtils.isEmpty(request.getPlatformType())
		|| StringUtils.isEmpty(request.getDeviceId())){
			response.getHeader().setCode(RetCode.VALIDATEERROR.getCode());
			response.getHeader().setMessage("参数错误，请更新客户端！");
			return null;
		}

		try {
			Integer.parseInt(request.getVersionCode()); // 版本号格式异常
		} catch (Exception e){
			response.getHeader().setCode(RetCode.VALIDATEERROR.getMessage());
			response.getHeader().setMessage("参数错误，请更新客户端！");
			return null;
		}

		//验重
		String rediskey = request.getDeviceId() + request.getMsgtimestamp() + request.getMsgnonce();

		if(redisTemplate.opsForValue().increment(rediskey, 1) > 1){
			response.getHeader().setCode(RetCode.VALIDATEERROR.getCode());
			response.getHeader().setCode("无效请求");
			return null;
		}
		redisTemplate.expire(rediskey,Long.parseLong(redisExpireTimestampNonce),TimeUnit.MINUTES);
		return request;
	}

	/**
	* 请求日志
	*
	* @param service
	* @param request
	*/
	private void logRequest(String service, MobileMessage request) {
		try {
			StringBuffer sb = new StringBuffer();
			sb.append(System.lineSeparator());
			sb.append("Request[").append(service).append("] begin").append(System.lineSeparator());
			sb.append(objectMapper.writeValueAsString(request)).append(System.lineSeparator());
			sb.append("Request[").append(service).append("] end");
			LOG.info(sb.toString());
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
		}
	}

	/**
	* 响应日志
	*
	* @param service
	* @param response
	*/
	private void logResponse(String service, Response response) {
		try {

			String responseJson = objectMapper.writeValueAsString(response);
			if(responseJson.length() > 1000){
				responseJson = responseJson.substring(0, 1000);
				responseJson += "......";
			}

			StringBuffer sb = new StringBuffer();
			sb.append(System.lineSeparator());
			sb.append("Response[").append(service).append("] begin").append(System.lineSeparator());
			sb.append(responseJson).append(System.lineSeparator());
			sb.append("Response[").append(service).append("] end");

			LOG.info(sb.toString());
		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
		}
	}

}
