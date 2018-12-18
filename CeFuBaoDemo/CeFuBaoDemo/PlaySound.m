//
//  PlaySound.m
//  CeFuBaoDemo
//
//  Created by 关旭 on 2018/11/27.
//  Copyright © 2018年 guanxu. All rights reserved.
//

#import "PlaySound.h"

static SystemSoundID soundID;
static PlaySound *_sharedInstance;
@interface PlaySound()<AVAudioPlayerDelegate>{
    
}

@end

@implementation PlaySound
+(PlaySound *)sharedInstance {
    if (!_sharedInstance) {
        _sharedInstance = [[self alloc]init];
    }
    return _sharedInstance;
}

- (void)playSystemSoundWithResource:(NSString *)resource type:(NSString *)type block:(PlayFinishBlock )block {
    //    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    self.playfinishBlock = block;
    NSString *path = [[NSBundle mainBundle]pathForResource:resource ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
    if (error != kAudioServicesNoError) {
//        NSLog(@"播放出现错误");
    }else{
        self.playfinishBlock(1);
    }
    //    带振动
        AudioServicesPlayAlertSoundWithCompletion(soundID, ^{
//            NSLog(@"播放完成");
            self.playfinishBlock(0);
        });
    
    //    不带振动
//    AudioServicesPlaySystemSoundWithCompletion(soundID, ^{
//        NSLog(@"播放完成");
//        self.playfinishBlock(0);
//    });
}


- (void)playCustomSoundWithResource:(NSString *)resource type:(NSString *)type block:(PlayFinishBlock )block {
    self.playfinishBlock =  block;
    NSString *path = [[NSBundle mainBundle]pathForResource:resource ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
//    self.audioPlayer.volume = 0.5;
    self.audioPlayer.delegate = self;
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    self.playfinishBlock(1);
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.playfinishBlock(0);
    });
}
- (void)stopPlayCustomSound {
    if (_audioPlayer) {
        [self.audioPlayer stop];
    }
}

@end
