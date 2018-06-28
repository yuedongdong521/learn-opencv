//
//  OpenCVUitl.h
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/1.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OpenCVUitl : NSObject
- (UIImage *)scaleImage:(UIImage *)image;
/**
 *边缘检测
 */
- (UIImage *)edgeDetectionForImage:(UIImage *)image;
- (UIImage *)edgeDetectionSliderValue:(int)value;

/**
 *二值化
 */
- (UIImage *)binarizationFor:(UIImage *)image;
- (UIImage *)changeBinarizationValue:(int)value;

/**
 *轮廓检测
 */
- (UIImage *)drawingImage;
- (UIImage *)outlineImageForLevels:(int)levels;

- (UIImage *)outlineImageTowForImage:(UIImage *)image BackBinaryImage:(void(^)(UIImage *image))backBinaryImage;
- (UIImage *)changeLevels:(int)levels BlackBinaryImage:(void(^)(UIImage *image))blackBinaryImage;
/**
 *线段检测
 */
- (UIImage *)lineDetectionForImage:(UIImage *)image;
/**
 *圆检测
 */
- (UIImage *)roundDetectionForImage:(UIImage *)image;
/**
 * 灰度直方图
 */
- (UIImage *)createGrayImage:(UIImage *)image BackGrayImage:(void(^)(UIImage *grayImage))backGrayImage;

@end
