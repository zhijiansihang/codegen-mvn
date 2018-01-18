package com.zhijiansihang.finger.mmc.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;


@JsonIgnoreProperties(ignoreUnknown = true)
public class MobileMessage {

    private String statusCode;

    private String statusMessage;

    private String sessionId;
    //平台类型  1:android端;2ios端;
    private String platformType;
    //设备唯一编号
    private String deviceId;
    //app版本号
    private String versionCode;
    //渠道号
    private String channelId;
    //时间戳
    private String msgtimestamp;
    //签名随机数
    private String msgnonce;
    //加密后的pkey和mkey
    private String msgkey;
    //解密后的pkey
    private String pkey;
    //解密后的mkey
    private String mkey;
    //签名
    private String msgsign;
    //加密参数名拼接字符串，加密后随报文发送
    private String msgeps;
    //挡板服务赋值test，实现的服务不要赋值
    private String mode;

    //美美理财版本（1），种子计划版本（2），美美金融版本（3）
    private String operationChannel;
    /**
     *  app包名称
     *  主包： 空  或者  美美理财：100  种子计划：200  美美金融：300
     * 	副包：  美美理财：101~199  种子计划：201~299  美美金融：301~399
     */
    private String packageName;

    public String getMsgeps() {
        return msgeps;
    }

    public void setMsgeps(String msgeps) {
        this.msgeps = msgeps;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getMsgtimestamp() {
        return msgtimestamp;
    }

    public void setMsgtimestamp(String msgtimestamp) {
        this.msgtimestamp = msgtimestamp;
    }

    public String getMsgnonce() {
        return msgnonce;
    }

    public void setMsgnonce(String msgnonce) {
        this.msgnonce = msgnonce;
    }

    public String getMsgkey() {
        return msgkey;
    }

    public void setMsgkey(String msgkey) {
        this.msgkey = msgkey;
    }

    public String getMsgsign() {
        return msgsign;
    }

    public void setMsgsign(String msgsign) {
        this.msgsign = msgsign;
    }

    public String getPkey() {
        return pkey;
    }

    public void setPkey(String pkey) {
        this.pkey = pkey;
    }

    public String getMkey() {
        return mkey;
    }

    public void setMkey(String mkey) {
        this.mkey = mkey;
    }

    public MobileMessage() {
    }

    public String getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(String statusCode) {
        this.statusCode = statusCode;
    }

    public String getStatusMessage() {
        return statusMessage;
    }

    public void setStatusMessage(String statusMessage) {
        this.statusMessage = statusMessage;
    }

    public String getSessionId() {
        return sessionId;
    }

    public void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }

    public String getPlatformType() {
        return platformType;
    }

    public void setPlatformType(String platformType) {
        this.platformType = platformType;
    }

    public String getVersionCode() {
        return versionCode;
    }

    public void setVersionCode(String versionCode) {
        this.versionCode = versionCode;
    }

    public String getChannelId() {
        return channelId;
    }

    public void setChannelId(String channelId) {
        this.channelId = channelId;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getOperationChannel() {
        return operationChannel;
    }

    public void setOperationChannel(String operationChannel) {
        this.operationChannel = operationChannel;
    }

    @Override
    public String toString() {
        String str = ToStringBuilder.reflectionToString(this, ToStringStyle.JSON_STYLE);
        return str;
    }

    private Object getter (Object obj, String paramName){
        Object result = null;
        try {
            String methodName = "get" + paramName.substring(0, 1).toUpperCase() + paramName.substring(1);
            Method method = obj.getClass().getDeclaredMethod(methodName);
            result = method.invoke(obj);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }

        return result;
    }

    private void setter (Object obj, String paramName, String value){
        try {
            String methodName = "set" + paramName.substring(0, 1).toUpperCase() + paramName.substring(1);
            Method method = obj.getClass().getDeclaredMethod(methodName, String.class);
            method.invoke(obj, value);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    protected boolean isNotEmpty(String str){
        return !((str == null) || (str.length() == 0));
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }




}