//
//  SearchViewModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseViewModel.h"
@class SearchDataModel, VideoModel;

@interface SearchViewModel : BaseViewModel
@property (nonatomic, strong) VideoModel* videoModel;
/**
 *  搜索结果点击跳转时用
 */
@property (nonatomic, strong) SearchDataModel *detailModel;
/**
 *  搜索标题
 *
 *  @param index 下标
 *
 *  @return 搜索标题
 */
- (NSString *)modelTitleWithIndex: (NSIndexPath *)index;
/**
 *  搜索类型
 *
 *  @param section 分区
 *
 *  @return 搜索类型
 */
- (NSString *)modelTypeWithSection:(NSInteger)section;
/**
 *  获取模型对应所有分集
 *
 *  @param index 下标
 *
 *  @return 分集数组
 */
- (NSArray *)modelEpisodesWithIndex: (NSIndexPath *)index;

/**
 *  总分区数
 *
 *  @return 总分区数
 */
- (NSInteger )modelCount;
/**
 *  分区对应模型数
 *
 *  @param section 分区
 *
 *  @return 模型数
 */
- (NSInteger)modelZoneCountWithSection:(NSInteger)section;
/**
 *   根据视频模型初始化
 *
 *  @param videoModel 视频模型
 *
 *  @return self
 */
- (instancetype)initWithModel:(VideoModel *)videoModel;
/**
 *  根据关键词刷新
 *
 *  @param keyWord  关键词
 *  @param complete 回调
 */
- (void)refreshWithKeyWord:(NSString*)keyWord completionHandler:(void(^)(NSError *error))complete;
@end
