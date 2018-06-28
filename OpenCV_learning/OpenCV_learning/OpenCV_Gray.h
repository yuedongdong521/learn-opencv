//
//  OpenCV_Gray.h
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/5.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TouchEventBegan,
    TouchEventMoved,
    TouchEventCancel,
    TouchEventEnd,
} TouchEventStatus;

@interface OpenCV_Gray : NSObject
- (void)equalIzeGrayImage:(UIImage *)image BackEQGrayImage:(void(^)(UIImage *grayImage, UIImage *grayHImage, UIImage *grayEImage, UIImage *grayEHImage))backEQGImage;


- (UIImage *)converEqualizeHistImage:(UIImage *)image;

- (UIImage *)createDrawViewForWidth:(int)width ForHeight:(int)height;
- (UIImage *)drawForX:(int)x Y:(int)y TouchEvent:(NSInteger)event;
- (UIImage *)rewardAction;
@end
