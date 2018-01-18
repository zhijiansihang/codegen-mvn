//
//  RequestResult.h
//  tianchengtong
//
//  Created by zhoubin on 15/12/1.
//  Copyright © 2015年 zhoubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestResult : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, assign) BOOL sign;
@property (nonatomic, strong) NSDictionary *resultDict;
@end
