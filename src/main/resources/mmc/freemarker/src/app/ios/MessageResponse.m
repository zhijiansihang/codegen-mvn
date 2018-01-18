//
//  MessageResponse.m
//
//  Created by 代码生成器1.0
//

#import <objc/runtime.h>
#import "MessageResponse.h"
#import "DES3Util.h"
#import "RSA.h"
#import "MD5andBASE64.h"

@interface MessageResponse ()

@property (nonatomic, copy, readwrite) NSString *responseString;

@end

@implementation MessageResponse

+ (id)responseWithReponseData:(NSData*)responseData {
    MessageResponse *response = [[self class]alloc];
    response = [response initWithReponseData:responseData];
    return response;
}

- (id)initWithReponseData:(NSData*)responseData {
    if ((self = [super init])) {
        self.responseString = [[NSString alloc]initWithData:responseData
                                                   encoding:NSUTF8StringEncoding];
        NSLog(@"响应报文:\n%@", self.responseString);
        [self fromString: self.responseString];
    }
    return self;
}

-(id)validateSignAndDecWithPkey:(NSString *)pkey mkey:(NSString *)mkey{
    
    if([self msgeps]){
    	[self setMsgeps:[DES3Util decrypt:[self msgeps] DESRandom:pkey]];
    	NSArray *encParamList = [[self msgeps] componentsSeparatedByString:@","];
    	for (NSString *paramKey in encParamList) {
	        NSRange range = [paramKey rangeOfString:@">"];
	        if (range.location > 0 && range.location < paramKey.length) {
	            NSString *groupName = [paramKey substringToIndex:range.location];
	            NSString *paramName = [paramKey substringFromIndex:range.location + 1];
	            NSArray *group = [self.context objectForKey:groupName];
	            for (NSMutableDictionary *item in group) {
	            	if([item objectForKey:paramName]){
	            		NSString *deced = [DES3Util decrypt:[item objectForKey:paramName] DESRandom:pkey];
	            		if(deced){
	            			[item setObject:deced forKey:paramName];
	            		}
	            	}
	            }
	        }else{
	        	if([self.context objectForKey:paramKey]){
	        		NSString *deced = [DES3Util decrypt:[self.context objectForKey:paramKey] DESRandom:pkey];
	        		if(deced){
	            		[self.context setObject:deced forKey:paramKey];
	            	}
	        	}
	        }
	    }
    }
    
    return self;
}

@end
