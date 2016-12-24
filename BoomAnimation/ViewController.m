//
//  ViewController.m
//  BoomAnimation
//
//  Created by 阿凡树 on 2016/12/23.
//  Copyright © 2016年 阿凡树. All rights reserved.
//

#import "ViewController.h"
#import "UIView+animation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)boomAction:(UIButton *)sender {
    [sender boomWithTileSize:CGSizeMake(2, 2) inDiameter:300];
    sender.hidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.hidden = NO;
    });
}

@end
