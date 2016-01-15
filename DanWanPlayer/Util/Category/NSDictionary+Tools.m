//
//  NSDictionary+Tools.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/7.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "NSDictionary+Tools.h"
//#import "NSString+Tools.h"

@implementation NSDictionary (Tools)

- (NSString*)appendSortParameterWithBasePath:(NSString*)path{
    NSMutableString* basePath = [[NSMutableString alloc] initWithString:path];
    //排序后的keys
    NSArray* keysArr = [self allKeysSorted];
    
    [keysArr enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx) [basePath appendFormat:@"%@=%@&",obj,self[obj]];
        else [basePath appendString: @"?"];
    }];
    //去掉最后一个多余的&
    return [[basePath substringWithRange: NSMakeRange(0, basePath.length - 1)] copy];
}

- (NSString*)appendSortParameterWithSignWithBasePath:(NSString*)path{
    NSMutableDictionary *dicWithAppKey = [NSMutableDictionary dictionaryWithDictionary: self];
    dicWithAppKey[@"appkey"] = APPKEY;
    
    NSString* sortParamer = [[dicWithAppKey appendSortParameterWithBasePath: @""] stringByAppendingString: APPSEC];
    //拼上sign
    sortParamer = [NSString stringWithFormat:@"%@%@&sign=%@",path,sortParamer,[sortParamer md5String]];
    return sortParamer;
}
@end
