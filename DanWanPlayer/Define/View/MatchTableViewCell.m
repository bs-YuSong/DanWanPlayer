//
//  MatchTableViewCell.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "MatchTableViewCell.h"

@implementation MatchTableViewCell
- (void)setWithDic:(NSDictionary *)dic{
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString *_Nonnull obj, BOOL * _Nonnull stop) {
        [self setValue:obj forKeyPath: key];
    }];
}
@end
