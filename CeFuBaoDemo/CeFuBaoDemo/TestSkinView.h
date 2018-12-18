//
//  TestSkinView.h
//  CeFuBaoDemo
//
//  Created by 关旭 on 2018/11/26.
//  Copyright © 2018年 guanxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestSkinView : UIView
@property (nonatomic,strong)UIImageView *photoImage;
@property (nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong)UIImageView *lineView;
@property (nonatomic,strong)dispatch_source_t timer;

@property (nonatomic,strong)UILabel *titleLabel;//标题
@property (nonatomic,strong)UILabel *fuzhiLabel;//肤质
@property (nonatomic,strong)UILabel *fuseLabel;//肤色
@property (nonatomic,strong)UILabel *fulingLabel;//肤龄
@property (nonatomic,strong)UILabel *heitouLabel;//黑头
@property (nonatomic,strong)UILabel *heiyanquanLabel;//黑眼圈
@property (nonatomic,strong)UILabel *zhiLabel;//痣

- (void)initTimer;
- (void)stopScaner;
@end



NS_ASSUME_NONNULL_END
