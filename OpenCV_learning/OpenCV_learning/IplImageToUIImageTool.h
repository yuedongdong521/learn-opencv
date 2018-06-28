//
//  IplImageToUIImageTool.h
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/5.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/opencv.hpp>
#import <UIKit/UIKit.h>

@interface IplImageToUIImageTool : NSObject

// UIimage转IPlImage
+ (IplImage *)convertToIplImage:(UIImage *)image;

/***
 * IplImage类型转换为UIImage类型
 * 注：IplImage图像通道数必须为3或4
 */
+(UIImage*)convertToUIImage:(IplImage*)image;

/***
 *从iplimage创建一张UIImage
 *代码如下：
 * 注意你之前应该颜色模式转换为RGB传递给这个函数
 */
+ (UIImage *)UIImageFromIplImage:(IplImage *)image;

@end
