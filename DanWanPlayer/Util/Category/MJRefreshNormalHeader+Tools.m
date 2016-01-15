//
//  MJRefreshNormalHeader+Tools.m
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/14.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "MJRefreshNormalHeader+Tools.h"

@implementation MJRefreshNormalHeader (Tools)
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock{
    MJRefreshNormalHeader *head = [super headerWithRefreshingBlock:refreshingBlock];
    head.lastUpdatedTimeLabel.hidden = YES;
    [head setTitle:@"" forState: MJRefreshStateWillRefresh];
    [head setTitle:@"" forState: MJRefreshStatePulling];
    [head setTitle:@"" forState: MJRefreshStateIdle];
    return head;
}

- (void)beginRefreshing{
    NSArray *arr = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Message" ofType:@"plist"]][@"Load"];
    [self setTitle:[arr randomObject] forState: MJRefreshStateRefreshing];
    [super beginRefreshing];
}
@end
