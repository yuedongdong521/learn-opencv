//
//  DrawImageView.h
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/5.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol DrawImageViewDelegate <NSObject>

- (void)drawImageForPoint:(CGPoint)point Event:(NSInteger)event;

@end

@interface DrawImageView : UIImageView
@property (nonatomic, weak) id<DrawImageViewDelegate>delegate;
@end
