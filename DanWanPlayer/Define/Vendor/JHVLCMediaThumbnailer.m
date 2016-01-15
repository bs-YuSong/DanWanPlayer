//
//  JHVLCMediaThumbnailer.m
//  DanWanPlayer
//
//  Created by JimHuang on 16/1/13.
//  Copyright © 2016年 JimHuang. All rights reserved.
//

#import "JHVLCMediaThumbnailer.h"
@interface JHVLCMediaThumbnailer()<VLCMediaThumbnailerDelegate>
@property (nonatomic, strong) returnThumb block;
@end

@implementation JHVLCMediaThumbnailer
- (instancetype)initWithMedia:(VLCMedia *)media{
    JHVLCMediaThumbnailer *th = (JHVLCMediaThumbnailer *)[JHVLCMediaThumbnailer thumbnailerWithMedia:media andDelegate: nil];
    th.snapshotPosition = 0.5;
    return th;
}

- (void)fetchThumbnailWithBlock:(returnThumb)block{
    self.delegate = self;
    [self fetchThumbnail];
    self.block = block;
}

- (void)mediaThumbnailerDidTimeOut:(VLCMediaThumbnailer *)mediaThumbnailer{
    self.block(nil);
}
- (void)mediaThumbnailer:(VLCMediaThumbnailer *)mediaThumbnailer didFinishThumbnail:(CGImageRef)thumbnail{
    self.block([UIImage imageWithCGImage: thumbnail]);
}
@end
