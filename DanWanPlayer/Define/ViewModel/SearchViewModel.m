//
//  SearchViewModel.m
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "SearchViewModel.h"
#import "SearchNetManager.h"
#import "SearchModel.h"
@interface SearchViewModel()
@property (nonatomic, strong) NSArray<NSArray<SearchDataModel*> *> *models;
/**
 *  类型对照字典
 */
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSString *>*mapDic;
@end

@implementation SearchViewModel
#pragma mark - 番剧
- (NSString *)modelTitleWithIndex: (NSIndexPath *)index{
    return [self modelWithModelArray: [self modelArrayWithSection: index.section] Index: index.row].title;
}
- (NSString *)modelTypeWithSection:(NSInteger)section{
    return self.mapDic[@(section)];
}

- (NSArray *)modelEpisodesWithIndex: (NSIndexPath *)index{
    return [self modelWithModelArray: [self modelArrayWithSection: index.section] Index: index.row].episodes;
}

- (NSInteger)modelCount{
    return self.models.count;
}
- (NSInteger)modelZoneCountWithSection:(NSInteger)section{
    return [self modelArrayWithSection: section].count;
}

- (instancetype)initWithModel:(VideoModel *)videoModel{
    if (self = [super init]) {
        self.videoModel = videoModel;
    }
    return self;
}

- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(NSError *error))complete{
    
    [SearchNetManager getWithParameters:@{@"anime": keyWord} completionHandler:^(SearchModel *responseObj, NSError *error) {
        self.models = [self classifyModel: responseObj.animes];
        complete(error);
    }];
}

#pragma mark - 私有方法
- (NSArray<SearchDataModel*> *)modelArrayWithSection: (NSInteger)section{
    return section >= [self modelCount] ? nil : self.models[section];
}

- (SearchDataModel *)modelWithModelArray:(NSArray<SearchDataModel*> *)arr Index: (NSInteger)index{
    return index >= arr.count ? nil : arr[index];
}

/**
 *  模型分类
 *
 *  @return 分类好的模型
 */
- (NSArray *)classifyModel :(NSArray<SearchDataModel*> *)arr{
    //分类
    NSMutableDictionary <NSString *,NSMutableArray *> *tempDic = [NSMutableDictionary dictionary];
    [arr enumerateObjectsUsingBlock:^(SearchDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //对应类型第一次创建
        if (!tempDic[obj.type]) tempDic[obj.type] = [NSMutableArray array];
        [tempDic[obj.type] addObject: obj];
    }];
    //键值排序
    NSArray *allKeys = tempDic.allKeys;
    allKeys = [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare: obj2 options: NSNumericSearch];
    }];
    //排序后赋值
    NSMutableArray *tempArr = [NSMutableArray array];
    NSDictionary *tempMap = @{@"1":@"TV动画", @"2":@"TV动画特别放送", @"3":@"OVA", @"4":@"剧场版", @"5":@"音乐视频", @"6":@"网络放送", @"7":@"其他", @"10":@"三次元电影", @"20":@"三次元电视剧或国产动画", @"99":@"未知"};
    //清除原来的记录
    self.mapDic = [NSMutableDictionary dictionary];
    [allKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArr addObject: tempDic[obj]];
        self.mapDic[@(idx)] = tempMap[obj];
    }];
    return tempArr;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)mapDic {
	if(_mapDic == nil) {
        _mapDic = [NSMutableDictionary dictionary];
	}
	return _mapDic;
}

@end
