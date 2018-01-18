//
//  FuncodeUtil.h
//  tianchengtong
//
//  Created by zhoubin on 15/12/2.
//  Copyright © 2015年 zhoubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FuncodeUtil : NSObject

+(instancetype)shared;

-(NSArray*)getRequestSignParamKeysByFuncode:(NSString*)funcode;

-(NSArray*)getRequestEncParamKeysByFuncode:(NSString*)funcode;

-(NSArray*)getResponseSignParamKeysByFuncode:(NSString*)funcode;

-(NSArray*)getResponseDecParamKeysByFuncode:(NSString*)funcode;

@end
