//
//  TorchBtnBehaviour.m
//  YQRCode
//
//  Created by mickey on 15/10/1.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "TorchBtnBehaviour.h"
#import <FontAwesomeKit/FontAwesomeKit.h>

@implementation TorchBtnBehaviour

-(void)setTorchBtn:(UIButton *)torchBtn
{
    _torchBtn = torchBtn;
    FAKFontAwesome *imageIcon = [FAKFontAwesome flashIconWithSize:20];
    [imageIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *leftImage = [imageIcon imageWithSize:CGSizeMake(23, 20)];
    imageIcon.iconFontSize = 15;
    [_torchBtn setImage:leftImage forState:UIControlStateNormal];
    [_torchBtn setTitle:@"" forState:UIControlStateNormal];
    [_torchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _torchBtn.tintColor = [UIColor whiteColor] ;
}
-(void)setTorchToggle:(BOOL)torchToggle
{
    _torchToggle = torchToggle;
    [self toggle];
    
}
- (IBAction)onTorchBtnTap:(id)sender {
    self.torchToggle = !_torchToggle;
}
-(void)toggle
{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [_device lockForConfiguration:nil];
    if (!_device.torchActive) {
        [_device setTorchMode:AVCaptureTorchModeOn];
        [_device setFlashMode:AVCaptureFlashModeOn];
    }
    else{
        [_device setTorchMode:AVCaptureTorchModeOff];
        [_device setFlashMode:AVCaptureFlashModeOff];
    }
    [_device unlockForConfiguration];
}

@end
