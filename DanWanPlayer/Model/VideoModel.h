//
//  VideoModel.h
//  DanWanPlayer
//
//  Created by JimHuang on 15/12/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "BaseModel.h"
/**
 *  视频模型
 */
@interface VideoModel : BaseModel
/**
 *  文件名
 */
@property (nonatomic, strong) NSString* fileName;
/**
 *  文件路径：文件名加后缀名
 */
@property (nonatomic, strong) NSString* filePath;
/**
 *  文件哈希值
 */
@property (nonatomic, strong) NSString* md5;
/**
 *  文件长
 */
@property (nonatomic, strong) NSString* length;
/**
 *  缩略图
 */
@property (nonatomic, strong) UIImage *thumb;
/**
 *  视频时长
 */
@property (nonatomic, strong) NSString *duration;
@end
