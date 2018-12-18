//
//  TestSkinView.m
//  CeFuBaoDemo
//
//  Created by 关旭 on 2018/11/26.
//  Copyright © 2018年 guanxu. All rights reserved.
//

#import "TestSkinView.h"

#define ImageWidth self.frame.size.width*2/5+20
#define ImageHeight self.frame.size.height*2/5-10

#define fontSize  17
#define viewHeight  25
#define interval  1
@interface TestSkinView () {
    UIView *_navView;
    NSInteger distance;
}
@end
@implementation TestSkinView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
        
    }
    return self;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ImageWidth, 2)];
//        _lineView.backgroundColor = [UIColor greenColor];
        [self drawLineForImageView:_lineView];
        [self.photoImage addSubview:_lineView];
    }
    return _lineView;
}
- (void)initTimer {
    distance = 0;
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0 ));
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 0.01*NSEC_PER_SEC, 0.0*NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->distance < ImageHeight) {
                self->distance++;
                self.lineView.frame = CGRectMake(0, self->distance, ImageWidth, 2);
            }else{
                self->distance = 0;
            }
        });
    });
    dispatch_resume(self.timer);
    
    [self analysisSkin];
}

- (void)stopScaner {
    if (_timer) {
        dispatch_cancel(self.timer);
        [self.lineView removeFromSuperview];
    }
}

- (void)analysisSkin {
    
    
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = RGB_VALUE(0x1F98F6);
    self.titleLabel.textAlignment = 1;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.text = @"正在肤质分析中...";
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(kScreenW);
        make.height.mas_offset(viewHeight);
        make.top.mas_equalTo(self.photoImage.mas_bottom).offset(10);
    }];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"初步分析完毕");
        BOOL faceImage = [self faceWithImage:self.photoImage.image];
        if (faceImage) {
            NSLog(@"存在一个人脸");
            [self fuzhi];
        }else{
            NSLog(@"不存在人脸，或者存在多个");
            self.titleLabel.text = @"照片分析失败，请重新拍摄";
        }
    });
    
}
- (void)fuzhi {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fuzhiLabel = [[UILabel alloc]init];
        self.fuzhiLabel.backgroundColor = [UIColor whiteColor];
        self.fuzhiLabel.textColor = [UIColor grayColor];
        self.fuzhiLabel.textAlignment = 1;
        self.fuzhiLabel.font = [UIFont systemFontOfSize:fontSize];
        self.fuzhiLabel.text = @"肤质分析完成";
        [self addSubview:self.fuzhiLabel];
        [self.fuzhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(kScreenW);
            make.height.mas_offset(viewHeight);
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
        }];
        self.titleLabel.text = @"正在肤色分析中...";
        [self fuse];
    });
}
- (void)fuse {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fuseLabel = [[UILabel alloc]init];
        self.fuseLabel.backgroundColor = [UIColor whiteColor];
        self.fuseLabel.textColor = [UIColor grayColor];
        self.fuseLabel.textAlignment = 1;
        self.fuseLabel.font = [UIFont systemFontOfSize:fontSize];
        self.fuseLabel.text = @"肤色分析完成";
        [self addSubview:self.fuseLabel];
        [self.fuseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(kScreenW);
            make.height.mas_offset(viewHeight);
            make.top.mas_equalTo(self.fuzhiLabel.mas_bottom);
        }];
        self.titleLabel.text = @"正在肤龄分析中...";
        [self fuling];
    });
}
- (void)fuling {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fulingLabel = [[UILabel alloc]init];
        self.fulingLabel.backgroundColor = [UIColor whiteColor];
        self.fulingLabel.textColor = [UIColor grayColor];
        self.fulingLabel.textAlignment = 1;
        self.fulingLabel.font = [UIFont systemFontOfSize:fontSize];
        self.fulingLabel.text = @"肤龄分析完成";
        [self addSubview:self.fulingLabel];
        [self.fulingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(kScreenW);
            make.height.mas_offset(viewHeight);
            make.top.mas_equalTo(self.fuseLabel.mas_bottom);
        }];
        self.titleLabel.text = @"正在黑头分析中...";
        [self heitou];
    });
}
- (void)heitou {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.heitouLabel = [[UILabel alloc]init];
        self.fulingLabel.backgroundColor = [UIColor whiteColor];
        self.heitouLabel.textColor = [UIColor grayColor];
        self.heitouLabel.textAlignment = 1;
        self.heitouLabel.font = [UIFont systemFontOfSize:fontSize];
        self.heitouLabel.text = @"黑头分析完成";
        [self addSubview:self.heitouLabel];
        [self.heitouLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(kScreenW);
            make.height.mas_offset(viewHeight);
            make.top.mas_equalTo(self.fulingLabel.mas_bottom);
        }];
        self.titleLabel.text = @"正在黑眼圈分析中...";
        [self heiyanquan];
    });
}
- (void)heiyanquan {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.heiyanquanLabel = [[UILabel alloc]init];
        self.heiyanquanLabel.backgroundColor = [UIColor whiteColor];
        self.heiyanquanLabel.textColor = [UIColor grayColor];
        self.heiyanquanLabel.textAlignment = 1;
        self.heiyanquanLabel.font = [UIFont systemFontOfSize:fontSize];
        self.heiyanquanLabel.text = @"黑眼圈分析完成";
        [self addSubview:self.heiyanquanLabel];
        [self.heiyanquanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(kScreenW);
            make.height.mas_offset(viewHeight);
            make.top.mas_equalTo(self.heitouLabel.mas_bottom);
        }];
        self.titleLabel.text = @"正在痣分析中...";
        [self zhi];
    });
}
- (void)zhi {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.zhiLabel = [[UILabel alloc]init];
        self.zhiLabel.backgroundColor = [UIColor whiteColor];
        self.zhiLabel.textColor = [UIColor grayColor];
        self.zhiLabel.textAlignment = 1;
        self.zhiLabel.font = [UIFont systemFontOfSize:fontSize];
        self.zhiLabel.text = @"痣分析完成";
        [self addSubview:self.zhiLabel];
        [self.zhiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(kScreenW);
            make.height.mas_offset(viewHeight);
            make.top.mas_equalTo(self.heiyanquanLabel.mas_bottom);
        }];
        self.titleLabel.text = @"正在生成皮肤报告...";
//        [self stopScaner];
    });
}



- (BOOL )faceWithImage:(UIImage *)image {

    NSDictionary *opts = [NSDictionary dictionaryWithObjectsAndKeys:CIDetectorAccuracyHigh,CIDetectorAccuracy,
                          nil];
    if (image.size.width == 0) {
        return NO;
    }
    CIImage *faceImage = [CIImage imageWithCGImage:image.CGImage];
    CIDetector *faceDetector=[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    // 识别出人脸数组
    NSArray *features = [faceDetector featuresInImage:faceImage];
    // 得到图片的尺寸
    if (features.count == 1) {
        return YES;
    }else{
        return NO;
    }
}


- (void)initView {
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, ZCStatus_H+ZCNavigationItem_H)];
    navView.backgroundColor = RGB_VALUE(0xc62d32);
    [self addSubview:navView];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 44)];
    [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [self addSubview:backButton];
    
    
    self.photoImage = [[UIImageView alloc]init];
    self.photoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.photoImage.clipsToBounds = YES;
    [self addSubview:self.photoImage];
    
    
    
    self.backBtn = backButton;
    _navView = navView;
//    [self setViewFrame];
}
- (void)setViewFrame {
    NSLog(@"width:%f---------height:%f",self.frame.size.width,self.frame.size.height);
    [self.photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ImageWidth);
        make.height.mas_equalTo(ImageHeight);
        make.top.equalTo(self->_navView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];

}
- (void)layoutSubviews {
    NSLog(@"counttttt");
    [self setViewFrame];
    
}

//绘制线图片
- (void)drawLineForImageView:(UIImageView *)imageView
{
    CGSize size = imageView.bounds.size;
    UIGraphicsBeginImageContext(size);
    
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //设置开始颜色
    const CGFloat *startColorComponents = CGColorGetComponents([[UIColor greenColor] CGColor]);
    //设置结束颜色
    const CGFloat *endColorComponents = CGColorGetComponents([[UIColor whiteColor] CGColor]);
    //颜色分量的强度值数组
    CGFloat components[8] = {startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]
    };
    //渐变系数数组
    CGFloat locations[] = {0.0, 1.0};
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //绘制渐变
    CGContextDrawRadialGradient(context, gradient, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.25, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.5, kCGGradientDrawsBeforeStartLocation);
    //释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


@end
