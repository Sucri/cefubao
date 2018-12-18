//
//  UIImage+OrientationUp.h
//  CeFuBaoDemo
//
//  Created by 关旭 on 2018/11/22.
//  Copyright © 2018年 guanxu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (OrientationUp)
- (UIImage *)normalizedImage;
- (UIImage *)fixOrientation;
- (UIImage *)rotatImageWithRadius:(NSInteger)radius;
@end

NS_ASSUME_NONNULL_END
