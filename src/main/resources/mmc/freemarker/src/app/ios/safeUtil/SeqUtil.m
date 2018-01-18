//
//  SeqUtil.m
//  tianchengtong
//
//  Created by zhoubin on 15/12/1.
//  Copyright © 2015年 zhoubin. All rights reserved.
//

#import "SeqUtil.h"

@implementation SeqUtil

+(NSString *)getNewSeq{

    //获得系统时间
    NSDate *sendDate = [NSDate date];
    NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString *sendDateStr = [dateFormatter stringFromDate:sendDate];
 
    
    //生成序列号
    int random = (arc4random() % 100000);//0到100000-1随机数
    NSString *randomStr = [NSString stringWithFormat:@"%06i", random];

    
    //最终seq
    NSString *seqstr = [NSString stringWithFormat:@"%@%@", sendDateStr, randomStr];
  
    return seqstr;
}
@end
