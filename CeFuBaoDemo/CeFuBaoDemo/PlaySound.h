//
//  PlaySound.h
//  CeFuBaoDemo
//
//  Created by 关旭 on 2018/11/27.
//  Copyright © 2018年 guanxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PlayFinishBlock)(BOOL isPlaying);//0为播放结束，1为正在播放

@interface PlaySound : NSObject
@property (nonatomic,copy)PlayFinishBlock playfinishBlock;

@property (nonatomic,strong)AVAudioPlayer *audioPlayer;

+(PlaySound *)sharedInstance;
- (void)playSystemSoundWithResource:(NSString *)resource type:(NSString *)type block:(PlayFinishBlock )block;
- (void)playCustomSoundWithResource:(NSString *)resource type:(NSString *)type block:(PlayFinishBlock )block;
- (void)stopPlayCustomSound;

@end

NS_ASSUME_NONNULL_END
