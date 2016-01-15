//
//  XML2Dic.h
//  Day09_1_XmlParse
//
//  Created by apple-jd44 on 15/11/12.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, danMuStyle){
    official,
    bilibili,
    acfun
};

@interface DanMuModelArr2Dic : NSObject
+ (NSDictionary *)dicWithObj:(id)obj style:(danMuStyle)style;
@end
