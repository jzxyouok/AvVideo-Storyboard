//
//  VideoProcess.h
//  AVVideo
//
//  Created by user on 14-10-20.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface VideoProcess : NSObject

///单例
+(VideoProcess *)Instance;

/**
 *音频视频混音
 *@pargm soundPath 要混合的音频文件路径
 *@pargm videoPath 要混合的视频文件路径
 *@pargm finishBlock 混音完成后调用的block
 */
-(void)mixSound:(NSString *)soundPath
      videoPath:(NSString *)videoPath
    finishBlock:(void(^)(void))finishBlock;

/**
 *抽取视频帧渲染后输出
 *@pargm sourceVideo 视频源文件路径
 *@pargm filterName 滤镜名称
 *@pargm finishFilterCallBack 滤镜完成调用块
 */
-(void)extractImageFromVideo:(NSString *)sourceVideo
                  filterName:(NSString *)filterName
        finishFilterCallBack:(void(^)(void))block;

/**
 *给视频添加水印
 *@pargm sourceVideo 视频源文件路径
 *@pargm printImg 水印图片
 *@pargm pringRect 水印位置
 *@pargm finishFilterCallBack 水印添加完成调用块
 */
-(void)addWaterPrintToVideo:(NSString *)sourceVideo
                   printImg:(UIImage *)printImg
                  printRect:(CGRect)printRect
  finishWataerPrintCallBack:(void(^)(NSString *))block;

@end
