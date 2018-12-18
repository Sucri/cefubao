//
//  ViewController.m
//  CeFuBaoDemo
//
//  Created by 关旭 on 2018/11/21.
//  Copyright © 2018年 guanxu. All rights reserved.
//

#import "ViewController.h"
#import "CameraViewController.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.navigationController.navigationBarHidden = YES;
    [self addButton];
    
}

- (void)addButton {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, 80, self.view.frame.size.width-40, 40)];
    button.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
    [button setTitle:@"打开摄像头" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)openCamera {
    CameraViewController *camera = [[CameraViewController alloc]init];
    [self.navigationController pushViewController:camera animated:YES];
}

@end
