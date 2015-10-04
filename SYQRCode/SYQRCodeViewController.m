//
//  SYQRCodeViewController.m
//  SYQRCodeDemo
//
//  Created by sunbb on 15-1-9.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "SYQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>


//设备宽/高/坐标
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height
#define KDeviceFrame [UIScreen mainScreen].bounds

//static const float kLineMinY = 185;
//static const float kLineMaxY = 385;
//static const float kReaderViewHeight = 200;

@interface SYQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate,AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *imagePickerBtn;
@property (weak, nonatomic) IBOutlet UIButton *torchBtn;
@property (weak, nonatomic) IBOutlet UIView *scanView;


@property (nonatomic, strong) AVCaptureSession *qrSession;//回话
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *qrVideoPreviewLayer;//读取
@property (nonatomic, strong) UIImageView *line;//交互线
@property (nonatomic, strong) NSTimer *lineTimer;//交互线控制
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation SYQRCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    [self initUI];
    [self.view bringSubviewToFront:_imagePickerBtn];
    [self.view bringSubviewToFront:_torchBtn];
    //[self loadBeepSound];
    //[self initTitleView];
    //[self createBackBtn];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self startSYQRCodeReading];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopSYQRCodeReading];
}
- (void)dealloc
{
    if (_qrSession) {
        [_qrSession stopRunning];
        _qrSession = nil;
    }
    
    if (_qrVideoPreviewLayer) {
        _qrVideoPreviewLayer = nil;
    }
    
    if (_line) {
        _line = nil;
    }
    
   
}



- (void)createBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, 28, 60, 24)];
    [btn setImage:[UIImage imageNamed:@"bar_back"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancleSYQRCodeReading) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)initUI
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //摄像头判断
    NSError *error = nil;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error)
    {
        //NSLog(@"没有摄像头-%@", error.localizedDescription);
        
        return;
    }
    
    //设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //设置输出的代理
    //使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    
    // 读取质量，质量越高，可读取小尺寸的二维码
    if ([session canSetSessionPreset:AVCaptureSessionPreset1920x1080])
    {
        [session setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    else if ([session canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        [session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    else
    {
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    }
    
    if ([session canAddInput:input])
    {
        [session addInput:input];
    }
    
    if ([session canAddOutput:output])
    {
        [session addOutput:output];
    }
    
    //设置输出的格式
    //一定要先设置会话的输出为output之后，再指定输出的元数据类型
    [output setMetadataObjectTypes:@[
                                     AVMetadataObjectTypeQRCode,         //二维码
                                     AVMetadataObjectTypeCode39Code,
                                     AVMetadataObjectTypeCode128Code,
                                     AVMetadataObjectTypeCode39Mod43Code,
                                     AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code,
                                     AVMetadataObjectTypeCode93Code,
                                     AVMetadataObjectTypeUPCECode,
                                     AVMetadataObjectTypeITF14Code
                                     ]];
    
    //设置预览图层
    AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:session];
    
    
    [preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //设置preview图层的大小
   // preview.frame = self.view.layer.bounds;


    //将图层添加到视图的图层
    [self.view.layer insertSublayer:preview atIndex:0];
    //[self.view.layer addSublayer:preview];
    self.qrVideoPreviewLayer = preview;
    self.qrSession = session;
}
//旋转屏幕后更新拍摄层视图
-(void)updatePreviewlayer
{
    self.qrVideoPreviewLayer.frame = self.view.layer.bounds;
    CGRect outputRect = [self getReaderViewRect];
    if ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.qrVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        outputRect = [self getReaderViewRect2];
    } else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        self.qrVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        outputRect = [self getReaderViewRect2];
    }else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) {
        self.qrVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    }else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.qrVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
    }
    AVCaptureMetadataOutput *output = [[self.qrSession outputs] lastObject];
    [output setRectOfInterest:outputRect];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self updatePreviewlayer];
}
//- (CGRect)getReaderViewBoundsWithSize:(CGSize)asize
//{
//    return CGRectMake(kLineMinY / KDeviceHeight, ((kDeviceWidth - asize.width) / 2.0) / kDeviceWidth, asize.height / KDeviceHeight, asize.width / kDeviceWidth);
//}
- (CGRect)getReaderViewRect
{
    CGRect rect = _scanView.frame;
    CGRect deviceRect = [UIScreen mainScreen].bounds;
    CGFloat deviceWidth = deviceRect.size.width;
    CGFloat deviceHeight = deviceRect.size.height;
    return CGRectMake(
                      rect.origin.y / deviceHeight,
                      rect.origin.x / deviceWidth,
                      rect.size.height / deviceHeight,
                      rect.size.width / deviceWidth
                      );
}
//横屏时所有角度互换
- (CGRect)getReaderViewRect2
{
    CGRect rect = _scanView.frame;
    CGRect deviceRect = [UIScreen mainScreen].bounds;
    CGFloat deviceWidth = deviceRect.size.width;
    CGFloat deviceHeight = deviceRect.size.height;
    return CGRectMake(
                      rect.origin.x / deviceWidth,
                      rect.origin.y / deviceHeight,
                      
                      rect.size.width / deviceWidth,
                      rect.size.height / deviceHeight
                      );
}

#pragma mark -
#pragma mark 输出代理方法

//此方法是在识别到QRCode，并且完成转换
//如果QRCode的内容越大，转换需要的时间就越长
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描结果
    if (metadataObjects.count > 0)
    {
        [self stopSYQRCodeReading];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        if (obj.stringValue && obj.stringValue.length > 0)
        {
            //NSLog(@"---------%@",obj.stringValue);

            //if (obj.stringValue.length)
            //{
                //if (self.SYQRCodeSuncessBlock) {
                    //self.SYQRCodeSuncessBlock(self,obj.stringValue);
                    [self play];
                    if ([self.delegate respondsToSelector:@selector(scanComplete:)]) {
                        [self.delegate scanComplete:obj];
                    }
                //}
            //}
            else
            {
                if (self.SYQRCodeFailBlock) {
                    self.SYQRCodeFailBlock(self);
                }
            }
        }
        else
        {
            if (self.SYQRCodeFailBlock) {
                self.SYQRCodeFailBlock(self);
            }
        }
    }
    else
    {
        if (self.SYQRCodeFailBlock) {
            self.SYQRCodeFailBlock(self);
        }
    }
}


#pragma mark -
#pragma mark 交互事件

- (void)startSYQRCodeReading
{
    
    
    [self.qrSession startRunning];
    
    //NSLog(@"start reading");
}

- (void)stopSYQRCodeReading
{
    
    
    [self.qrSession stopRunning];
    
    //NSLog(@"stop reading");
}

//取消扫描
- (void)cancleSYQRCodeReading
{
    [self stopSYQRCodeReading];
    
    if (self.SYQRCodeCancleBlock)
    {
        self.SYQRCodeCancleBlock(self);
    }
    //NSLog(@"cancle reading");
}

-(void)play
{
    if (_audioPlayer) {
        [_audioPlayer play];
        
    }
    else
    {
        [self loadBeepSound];
    }
}
-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    _audioPlayer.delegate = self;
    //滴一声后不会影响其他音乐的播放
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    if (error) {
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayer prepareToPlay];
        [self play];
    }
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _audioPlayer = nil;
}
@end
