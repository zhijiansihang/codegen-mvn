#import <Foundation/Foundation.h>

#import "Message.h"
#import "MessageRequest.h"
#import "MessageResponse.h"

<#list messages as message>
#import "${iosPrefix}${message.name}Request.h"
#import "${iosPrefix}${message.name}Response.h"

</#list>