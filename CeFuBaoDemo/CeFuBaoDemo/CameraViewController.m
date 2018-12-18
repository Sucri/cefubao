//
//  CameraViewController.m
//  CeFuBaoDemo
//
//  Created by 关旭 on 2018/11/22.
//  Copyright © 2018年 guanxu. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageUtility.h"
#import "UIImage+OrientationUp.h"
#import "TestSkinView.h"

#import "PlaySound.h"

#define BottomHeight 140

@interface CameraViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate> {
    NSInteger count;
    NSInteger soundState;//音效播放状态，0 没有播放， 1 为正在播放， 2 为拍照完成，不再播放
    BOOL canTakePhoto;
}
@property (nonatomic,strong)UILabel *hudLabel;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer* preLayer;
@property (nonatomic,strong)AVCaptureSession *session;
@property (nonatomic,strong)AVCaptureStillImageOutput *imageOutput;
@property (nonatomic,strong)AVCaptureDevice *device;
@property (nonatomic,strong)AVCaptureVideoDataOutput *output;
@property (nonatomic,strong)UIImage *cameraImage;

@property (nonatomic,strong)TestSkinView *testSkinView;
@property (nonatomic)CIImage *faceImage;


@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCaptureSession];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序，（把程序放在后台执行其他操作）
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self startIdentifyFace];
//    });
    [self playSoungWithName:@"aim_uncapture" type:@"mp3"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self close];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)dealloc {
    [_output setSampleBufferDelegate:nil queue:nil];
}

- (void)playSoungWithName:(NSString *)name type:(NSString *)type {
    if (name.length == 0) {
        return;
    }
    if (soundState == 0 && canTakePhoto == NO) {
        soundState = 1;
        [[PlaySound sharedInstance]playCustomSoundWithResource:name type:type block:^(BOOL isPlaying) {
            NSLog(@"isPlaying:%d",isPlaying);
            self->soundState = isPlaying;
        }];
        [PlaySound sharedInstance].playfinishBlock = ^(BOOL isPlaying) {
            self->soundState = isPlaying;
        };
    }
}


-(CIImage *)faceImage {
    if (!_faceImage) {
        _faceImage = [[CIImage alloc]init];
    }
    return _faceImage;
}
- (UIImage *)cameraImage {
    if (!_cameraImage) {
        _cameraImage = [[UIImage alloc]init];
    }
    return _cameraImage;
}
- (TestSkinView *)testSkinView {
    if (!_testSkinView) {
        _testSkinView = [[TestSkinView alloc]init];
    }
    return _testSkinView;
}
- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self closeView];
    
}

- (void)addSetting {
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 44)];
//    backButton.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.6];
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigation_back"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, self.view.frame.size.width-100, 35)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    [self.view addSubview:label];
    _hudLabel = label;
    [backButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIButton *takePhoto = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-120, self.view.frame.size.width-40, 40)];
//    takePhoto.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.6];
//    [takePhoto setTitle:@"手动拍照按钮" forState:UIControlStateNormal];
//    [self.view addSubview:takePhoto];
//    [takePhoto addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-BottomHeight, kScreenW, BottomHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    NSArray *stepArr = @[@"ic_skin_analysis_step1.png",@"ic_skin_analysis_step2.png",@"ic_skin_analysis_step3.png"];
    for (int i=0; i<stepArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/3*i, 0, kScreenW/3, BottomHeight)];
        imageView.image = [UIImage imageNamed:stepArr[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [bottomView addSubview:imageView];
    }
}
#pragma mark ---------------开始拍照-------
- (void)takePhoto {
//    设置闪光灯开启
    AVCaptureDevice *captureDevide = _device;
    NSError *error;
    BOOL lockAcquired = [captureDevide lockForConfiguration:&error];
    if(!lockAcquired){
        NSLog(@"锁定设备错误信息：%@",error.localizedDescription);
    }else{
        [_session beginConfiguration];
        // 创建image output 代码
        AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
        imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
        if ([_session canAddOutput:imageOutput]) {
            [_session addOutput:imageOutput];
            _imageOutput = imageOutput;
        }
        captureDevide.flashMode = AVCaptureFlashModeOn;
        [captureDevide unlockForConfiguration];
        [_session commitConfiguration];
    }
    
    // 输出图片
    AVCaptureConnection *connection = [_imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.isVideoOrientationSupported) {
//        connection.videoOrientation = [self currentVideoOrientation];
    }
    id takePictureSuccess = ^(CMSampleBufferRef sampleBuffer,NSError *error){
        if (sampleBuffer == NULL) {
            
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        NSLog(@"%@",image);
        self.testSkinView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        self.testSkinView.photoImage.image = image;
        [self close];
        [self.view addSubview:self.testSkinView];
        [self.testSkinView.backBtn addTarget:self action:@selector(closeTestView) forControlEvents:UIControlEventTouchUpInside];
        [self.testSkinView initTimer];
        
    };
    [_imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:takePictureSuccess];
    
}
#pragma mark -----------------关闭页面
- (void)close {
    if (_session) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self->_session stopRunning];
            self->_session = nil;
        });
    }
    if (_preLayer) {
        [_preLayer removeFromSuperlayer];
        _preLayer = nil;
    }
    [[PlaySound sharedInstance]stopPlayCustomSound];
}
- (void)closeView {
    [self close];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)closeTestView {
    [self close];
    [_testSkinView stopScaner];
    [_testSkinView removeFromSuperview];
    _testSkinView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -----------创建并配置一个摄像会话，并启动。
- (void)setupCaptureSession
{
    //捕获视频流的方法写在这里
    NSError *error = nil;
    
    // Create the session创建session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];//负责输入和输出设置之间的数据传递
    // Configure the session to produce lower resolution video frames, if your
    // processing algorithm can cope. We'll specify medium quality for the
    // chosen device.可以配置session以产生解析度较低的视频帧，如果你的处理算法能够应付（这种低解析度）
    //我们将选择的设备指定为高质量
    session.sessionPreset = AVCaptureSessionPresetPhoto;//设置分辨率
    
    // Find a suitable AVCaptureDevice找到一个合适的AVCaptureDevice
    AVCaptureDevice *device = [AVCaptureDevice
                               defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认是使用后置摄像头，你可以改成前置摄像头
    // Create a device input with the device and add it to the session.
    //找到一个合适的AVCaptureDevice
    device.activeVideoMinFrameDuration = CMTimeMake(1, 30);
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                        error:&error];
    if (!input) {
        // Handling the error appropriately.处理相应的错误
    }
    [session addInput:input];
    
    // Create a VideoDataOutput and add it to the session创建一个VideoDataOutput对象，将其添加到session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];//创建一个视频数据输出流
    [session addOutput:output];
    
//    // 创建image output 代码
//    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
//    imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
//    if ([session canAddOutput:imageOutput]) {
//        [session addOutput:imageOutput];
//        _imageOutput = imageOutput;
//    }
    
    
    // Configure your output.配置output对象
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    // Specify the pixel format指定像素格式
    output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,
//                                                        [NSNumber numberWithInt: 1920], (id)kCVPixelBufferWidthKey,
//                                                        [NSNumber numberWithInt: 1080], (id)kCVPixelBufferHeightKey,
                            nil];
    
//    捕捉预览
    AVCaptureVideoPreviewLayer* preLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];//相机拍摄预览图层
    //preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    preLayer.frame = self.view.frame;// CGRectMake(0, 0, 1920, 1080);
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:preLayer];
    
    // Start the session running to start the flow of data启动session以启动数据流
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->_session startRunning];
    });
    
    // Assign session to an ivar.将session赋给实例变量
    _preLayer = preLayer;
    _session = session;
    _device = device;
    _output = output;
    [self addSetting];
    
}
#pragma mark --------------抽取采样数据，合成UIImage对象
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//当采样数据被写入缓冲区时调用
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    //抽取采样数据，合成UIImage对象
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    if (image.size.width>image.size.height) {
        return;
    }
    count++;
    if (count%10 == 0) {
        [self faceDetectWithImage:image];
    }
    
    
}




#pragma mark -------------- 识别图片信息
- (void)faceDetectWithImage:(UIImage *)image {

    // 图像识别能力：可以在CIDetectorAccuracyHigh(较强的处理能力)与CIDetectorAccuracyLow(较弱的处理能力)中选择，因为想让准确度高一些在这里选择CIDetectorAccuracyHigh
    NSDictionary *opts = [NSDictionary dictionaryWithObjectsAndKeys:CIDetectorAccuracyHigh,CIDetectorAccuracy,
                          nil];
    // 将图像转换为CIImage
//    NSLog(@"%f",image.size.width);
    if (image.size.width == 0) {
        return;
    }
    self.faceImage = [CIImage imageWithCGImage:image.CGImage];
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        self.faceImage = [CIImage imageWithCGImage:self.cameraImage.CGImage];
//    });
    
    CIDetector *faceDetector=[CIDetector detectorOfType:CIDetectorTypeFace context:nil options:opts];
    // 识别出人脸数组
    NSArray *features = [faceDetector featuresInImage:self.faceImage];
    // 得到图片的尺寸
    CGSize inputImageSize = [self.faceImage extent].size;
    //将image沿y轴对称
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, -1);
    //将图片上移
    transform = CGAffineTransformTranslate(transform, 0, -inputImageSize.height);
    if (features.count>0) {
//        NSLog(@"存在人脸");
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_hudLabel.text = @"存在人脸";
        });
        // 取出所有人脸
        for (CIFaceFeature *faceFeature in features){
            //获取人脸的frame
            CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
            CGSize viewSize = inputImageSize;// CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);// self.view.bounds.size;
            CGFloat scale = MIN(viewSize.width / inputImageSize.width,
                                viewSize.height / inputImageSize.height);
            CGFloat offsetX = (viewSize.width - inputImageSize.width * scale) / 2;
            CGFloat offsetY = (viewSize.height - inputImageSize.height * scale) / 2;
            // 缩放
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
            // 修正
            faceViewBounds = CGRectApplyAffineTransform(faceViewBounds,scaleTransform);
            faceViewBounds.origin.x += offsetX;
            faceViewBounds.origin.y += offsetY;
            
            //描绘人脸区域
            //        UIView* faceView = [[UIView alloc] initWithFrame:faceViewBounds];
            //        faceView.layer.borderWidth = 2;
            //        faceView.layer.borderColor = [[UIColor redColor] CGColor];
            //        [self.view addSubview:faceView];
            //        facePoint = CGPointMake(faceViewBounds.center.x, faceViewBounds.center.y);
            NSLog(@"%f-------%f",faceViewBounds.size.width,faceViewBounds.size.height);
            NSString *string;
            NSString *videoName;
            if (faceViewBounds.size.width<350 ) {
                string = @"请拉近镜头";
                videoName = @"more_near";
            }else if(faceViewBounds.size.width>700){
                string = @"请拉远镜头";
                videoName = @"more_far";
            }else{
                string = @"距离合适，可以拍照";
                videoName = @"nicety";
                if (soundState == 0 && canTakePhoto == NO) {
                    soundState = 1;
                    [[PlaySound sharedInstance]playCustomSoundWithResource:@"nicety" type:@"mp3" block:^(BOOL isPlaying) {
                        NSLog(@"isPlaying:%d",isPlaying);
                        self->soundState = isPlaying;
                    }];
                    [PlaySound sharedInstance].playfinishBlock = ^(BOOL isPlaying) {
                        self->soundState = isPlaying;
                        self->canTakePhoto = YES;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self takePhoto];
                        });
                    };
                }
            }
            NSLog(@"%@",string);
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_hudLabel.text = string;
                [self playSoungWithName:videoName type:@"mp3"];
            });
            
            // 判断是否有左眼位置
            if(faceFeature.hasLeftEyePosition){}
            // 判断是否有右眼位置
            if(faceFeature.hasRightEyePosition){}
            // 判断是否有嘴位置
            if(faceFeature.hasMouthPosition){}
            
            if (faceFeature.leftEyeClosed) {
                NSLog(@"人像闭眼了---哈哈哈哈哈哈");
            }
        }
    }else{
        NSLog(@"不存在人脸");
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_hudLabel.text = @"不存在人脸";
            [self playSoungWithName:@"aim" type:@"mp3"];
        });
    }
    
//    self.label.text = [NSString stringWithFormat:@"识别出了%ld张脸", features.count];
}

#pragma mark ----------------合成UIImage对象
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //锁定像素缓冲区的起始地址
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    //获取每行像素的字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    //获取像素缓冲区的宽度和高度
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    //创建基于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (!colorSpace)
    {
        NSLog(@"CGColorSpaceCreateDeviceRGB failure");
        return nil;
    }
    
    //获取像素缓冲区的起始地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    //获取像素缓冲区的数据大小
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    //使用提供的数据创建CGDataProviderRef
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, baseAddress, bufferSize,NULL);
    //通过CGDataProviderRef，创建CGImageRef
    CGImageRef cgImage =
    CGImageCreate(width,
                  height,
                  8,
                  32,
                  bytesPerRow,
                  colorSpace,
                  kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  provider,
                  NULL,
                  true,
                  kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    //创建UIImage
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    //解锁像素缓冲区起始地址
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return [image fixOrientation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// 能否自动旋转

-(BOOL)shouldAutorotate{
    return NO;
}

// 支持的屏幕方向

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
// 默认的屏幕方向

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
    
}

@end
