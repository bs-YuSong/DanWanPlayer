//
//  NSDictionary+Tools.h
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/2.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Tools)
/**
 *  从字典获取已经拼好的get请求的字符串
 *
 *  @param path 路径
 *
 *  @return 拼好的字符串
 */
- (NSString*)appendSortParameterWithBasePath:(NSString*)path;
/**
 *  从字典获取已经拼好的get请求的字符串加上sign
 *
 *  @param path 路径
 *
 *  @return 拼好的字符串
 */
- (NSString*)appendSortParameterWithSignWithBasePath:(NSString*)path;
@end
