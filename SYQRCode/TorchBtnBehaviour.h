//
//  TorchBtnBehaviour.h
//  YQRCode
//
//  Created by mickey on 15/10/1.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "KZBehaviour.h"
#import <AVFoundation/AVFoundation.h>
@interface TorchBtnBehaviour : KZBehaviour
{
    AVCaptureDevice *_device;
}
- (IBAction)onTorchBtnTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *torchBtn;
@property (assign,nonatomic,getter=isOpen)BOOL torchToggle;
@end
