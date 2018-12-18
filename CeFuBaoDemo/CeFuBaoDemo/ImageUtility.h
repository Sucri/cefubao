//
//  ImageUtility.h
//  CeFuBaoDemo
//
//  Created by 关旭 on 2018/11/22.
//  Copyright © 2018年 guanxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface ImageUtility : NSObject
/**
 *  return 旋转后的图片
 *  @param image              原始图片    （必传，不可空）
 *  @param orientation        旋转方向    （必传，不可空）
 */
+ (UIImage *)image:(UIImage *)image
          rotation:(UIImageOrientation)orientation ;
@end

NS_ASSUME_NONNULL_END
