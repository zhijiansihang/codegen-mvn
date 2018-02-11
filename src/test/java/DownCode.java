import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import net.eagle.model.MMService;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * @author paul
 * @description
 * @date 2018/2/11
 */
public class DownCode {
    public static final CloseableHttpClient httpclient = HttpClients.createDefault();
    public static final String services_link = "http://47.94.241.207:7035/apis";

    public static final String services_desc  = "http://47.94.241.207:7035/serviceDetail";

    public static List<MMService> getServices() throws Exception {
        HttpPost httpPost = new HttpPost(services_link);
        List<NameValuePair> nvps = new ArrayList<NameValuePair>();
        nvps.add(new BasicNameValuePair("project", "finger"));
        httpPost.setEntity(new UrlEncodedFormEntity(nvps));

        CloseableHttpResponse response2 = httpclient.execute(httpPost);
        try {
            String jsonString = IOUtils.toString(response2.getEntity().getContent(), "UTF-8");
            ObjectMapper mapper = new ObjectMapper();

            JavaType javaType = mapper.getTypeFactory().constructParametricType(List.class, MMService.class);
            return  mapper.readValue(jsonString, javaType);

        } finally {
            response2.close();
        }

    }

    public static String getServicesDesc(String servicesName) throws Exception {
        HttpPost httpPost = new HttpPost(services_desc);
        List<NameValuePair> nvps = new ArrayList<NameValuePair>();
        nvps.add(new BasicNameValuePair("project", "finger"));
        nvps.add(new BasicNameValuePair("serviceName", servicesName));
        httpPost.setEntity(new UrlEncodedFormEntity(nvps));

        CloseableHttpResponse response2 = httpclient.execute(httpPost);
        try {
            return IOUtils.toString(response2.getEntity().getContent(), "UTF-8");
        } finally {
            response2.close();
        }

    }

    public static void main(String[] args) throws Exception{
        List<MMService> services = getServices();
        for (MMService mmService:services){
            String serviceName = mmService.getServiceName();
            String servicesDesc = getServicesDesc(serviceName);
            File file = new File("/fingercode/" + serviceName + ".json");
            //FileUtils.forceMkdir(file);
            FileUtils.writeByteArrayToFile(file,servicesDesc.getBytes("UTF-8"));
        }
    }
}
