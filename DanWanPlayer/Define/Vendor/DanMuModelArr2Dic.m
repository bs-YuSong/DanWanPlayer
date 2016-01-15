//
//  XML2Dic.m
//  Day09_1_XmlParse
//
//  Created by apple-jd44 on 15/11/12.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "DanMuModelArr2Dic.h"
#import "DanMuModel.h"

@interface DanMuModelArr2Dic ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber*,NSMutableArray<DanMuDataModel*>*>* dic;
@end

@implementation DanMuModelArr2Dic
+ (NSDictionary *)dicWithObj:(id)obj style:(danMuStyle)style{
    if (style == official) {
        return [self danMuDicWithArr: obj];
    }else if (style == bilibili){
        return [self dicWithData: obj];
    }else if (style == acfun){
        return [self danMuDicWithAcfunArr: obj];
    }
    return nil;
}

#pragma mark - 私有方法
//acfun解析方式
+ (NSDictionary *)danMuDicWithAcfunArr:(NSArray *)arr{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    for (NSArray *arr2 in arr) {
        for (NSDictionary *dic in arr2) {
            NSString *str = dic[@"c"];
            NSArray *tempArr = [str componentsSeparatedByString:@","];
            if (tempArr.count == 0) continue;
            
            DanMuDataModel *model = [DanMuDataModel new];
            model.time = [tempArr[0] intValue];
            model.color = [tempArr[1] intValue];
            model.mode = [tempArr[2] intValue];
            model.fontSize = [tempArr[3] intValue] / 1.5;
            model.message = dic[@"m"];
            
            if (!mDic[@(model.time)]) mDic[@(model.time)] = [NSMutableArray array];
            [mDic[@(model.time)] addObject:model];
        }
    }
    return mDic;
}

//官方解析方式
+ (NSDictionary *)danMuDicWithArr:(NSArray<DanMuDataModel *> *)arr{
    NSMutableDictionary <NSNumber *,NSMutableArray <DanMuDataModel *> *> *dic = [NSMutableDictionary dictionary];
    [arr enumerateObjectsUsingBlock:^(DanMuDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //第一次创建
        if (!dic[@(obj.time)]) dic[@(obj.time)] = [NSMutableArray array];
        obj.fontSize = 16;
        [dic[@(obj.time)] addObject: obj];
    }];
    return dic;
}

//b站解析方式
+ (NSDictionary*)dicWithData:(NSData*)data{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@"<d.*>" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    //所有弹幕标签
    for (NSTextCheckingResult* re in resultArr) {
        NSString* subStr = [str substringWithRange:re.range];
        
        NSArray* strArr = [[self getParameterWithString:subStr] componentsSeparatedByString:@","];
        DanMuDataModel* model = [[DanMuDataModel alloc] init];
        model.time = [strArr[0] intValue];
        model.mode = [strArr[1] intValue];
        model.fontSize = [strArr[2] intValue] / 1.5;
        model.color = [strArr[3] intValue];
        model.message = [self getTextWithString:subStr];
        
        if (dic[@(model.time)] == nil) dic[@(model.time)] = [NSMutableArray array];
        [dic[@(model.time)] addObject: model];
    }
    return dic;
}

//获取参数
+ (NSString*)getParameterWithString:(NSString*)str{
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@"\".*\"" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    if (resultArr.count > 0) {
        return [str substringWithRange:NSMakeRange(resultArr.firstObject.range.location + 1, resultArr.firstObject.range.length - 2)];
    }
    return nil;
}

// 获取内容
+ (NSString*)getTextWithString:(NSString*)str{
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:@">.*<" options:NSRegularExpressionCaseInsensitive error:nil];
    //正则表达式匹配的范围
    NSArray<NSTextCheckingResult*>* resultArr = [regu matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    if (resultArr.count > 0) {
        return [str substringWithRange:NSMakeRange(resultArr.firstObject.range.location + 1, resultArr.firstObject.range.length - 2)];
    }
    return nil;
}

#pragma mark - 懒加载
- (NSMutableDictionary<NSNumber *,NSMutableArray<DanMuDataModel*> *> *)dic{
    if (_dic == nil) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

@end
