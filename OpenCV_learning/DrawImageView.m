//
//  DrawImageView.m
//  OpenCV_learning
//
//  Created by ispeak on 2017/6/5.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "DrawImageView.h"

typedef enum : NSUInteger {
    TouchEventBegan,
    TouchEventMoved,
    TouchEventCancel,
    TouchEventEnd,
}TouchEventStatus;

@implementation DrawImageView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    NSLog(@"开始触摸 event = %@, point x = %f, y = %f", event, point.x, point.y);
    [_delegate drawImageForPoint:point Event:TouchEventBegan];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    NSLog(@"结束触摸 event = %@, point x = %f, y = %f", event, point.x, point.y);
    [_delegate drawImageForPoint:point Event:TouchEventEnd];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    NSLog(@"移动触摸 event = %@, point x = %f, y = %f", event, point.x, point.y);
    [_delegate drawImageForPoint:point Event:TouchEventMoved];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    
    NSLog(@"取消触摸 event = %@, point x = %f, y = %f", event, point.x, point.y);
    [_delegate drawImageForPoint:point Event:TouchEventMoved];
}

@end
