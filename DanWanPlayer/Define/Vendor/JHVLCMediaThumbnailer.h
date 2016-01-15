//
//  JHVLCMediaThumbnailer.h
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import <MobileVLCKit/MobileVLCKit.h>
typedef void(^returnThumb)(UIImage *aThumb);
@interface JHVLCMediaThumbnailer : VLCMediaThumbnailer
- (instancetype)initWithMedia:(VLCMedia *)media;
- (void)fetchThumbnailWithBlock:(returnThumb)block;
@end
