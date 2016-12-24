//
//  UIView+animation.h
//  BoomAnimation
//
//  Created by 阿凡树 on 2016/12/23.
//  Copyright © 2016年 阿凡树. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (animation)<CAAnimationDelegate>

- (void)boomWithTileSize:(CGSize)size inDiameter:(CGFloat)diameter;

@end
