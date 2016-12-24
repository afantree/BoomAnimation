//
//  UIView+animation.m
//  BoomAnimation
//
//  Created by 阿凡树 on 2016/12/23.
//  Copyright © 2016年 阿凡树. All rights reserved.
//

#import "UIView+animation.h"
#import <objc/runtime.h>

@implementation UIView (animation)

- (void)boomWithTileSize:(CGSize)size inDiameter:(CGFloat)diameter {
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [[UIColor clearColor] setFill];
    [[UIBezierPath bezierPathWithRect:self.bounds] fill];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView* animationView = [[UIView alloc] initWithFrame:self.frame];
    [self.superview addSubview:animationView];
    objc_setAssociatedObject(self, @"boomAnimationView", animationView, OBJC_ASSOCIATION_RETAIN);
    
    NSInteger maxX = floor(screenshotImage.size.width / size.width);
    NSInteger maxY = floor(screenshotImage.size.height / size.height);
    for (int i=0; i<maxX; i++) {
        for (int j = 0; j<maxY; j++) {
            CALayer* layer = [[CALayer alloc] init];
            layer.frame = CGRectMake(i*size.width, (maxY-j-1)*size.height, size.width, size.height);
            CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                                  size.width,
                                                                  size.height,
                                                                  8,
                                                                  0,
                                                                  CGImageGetColorSpace(screenshotImage.CGImage),
                                                                  kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
            CGContextTranslateCTM(offscreenContext, -i*size.width, -j*size.height);
            CGContextDrawImage(offscreenContext, CGRectMake(0, 0, screenshotImage.size.width, screenshotImage.size.height), screenshotImage.CGImage);
            CGImageRef imageRef = CGBitmapContextCreateImage(offscreenContext);
            layer.contents = CFBridgingRelease(imageRef);
            CGContextRelease(offscreenContext);
            [animationView.layer addSublayer:layer];
        }
    }
    
    for (CALayer *shape in animationView.layer.sublayers) {
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.path = [self makeRandomPath:shape inDiameter:diameter].CGPath;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut];
        
        CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @(1);
        opacityAnimation.toValue = @(0);
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[positionAnimation, opacityAnimation];
        animationGroup.duration = 0.5;
        animationGroup.removedOnCompletion = YES;
        animationGroup.delegate = self;
        [shape addAnimation:animationGroup forKey:@"handAnimation"];
    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    UIView* animationView = (UIView*)objc_getAssociatedObject(self, @"boomAnimationView");
    if (animationView == nil) {
        return;
    }
    objc_removeAssociatedObjects(animationView);
    [animationView removeFromSuperview];
}
- (UIBezierPath *)makeRandomPath:(CALayer *)alayer inDiameter:(CGFloat)diameter {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: alayer.position];
    CGPoint p = [self pointIncycleWithDiameter:diameter];
    CGPoint p1 = CGPointMake(self.bounds.size.width/2.0f+p.x, self.bounds.size.height/2.0f+p.y);
    [path addLineToPoint:p1];
    return path;
}
- (CGPoint)pointIncycleWithDiameter:(uint32_t)diameter{
    CGFloat x = [self getRandomInRange:diameter];
    CGFloat y = 0;
    do {
        y = [self getRandomInRange:diameter];
    } while (x*x+y*y>(diameter/2.0f)*(diameter/2.0f));
    return CGPointMake(x, y);
}
- (CGFloat)getRandomInRange:(uint32_t)ran {
    return (CGFloat)(arc4random()%ran)-ran/2.0f;
}

@end
