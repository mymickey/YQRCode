//
//  ImagePickerBtnBehaviour.m
//  YQRCode
//
//  Created by mickey on 15/9/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ImagePickerBtnBehaviour.h"
#import "MBProgressHUD.h"
#import <FontAwesomeKit/FontAwesomeKit.h>

@implementation ImagePickerBtnBehaviour

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setImagePickerBtn:(UIButton *)imagePickerBtn
{
    _imagePickerBtn = imagePickerBtn;
    FAKFontAwesome *imageIcon = [FAKFontAwesome imageIconWithSize:20];
    [imageIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *leftImage = [imageIcon imageWithSize:CGSizeMake(23, 20)];
    imageIcon.iconFontSize = 15;
    [_imagePickerBtn setImage:leftImage forState:UIControlStateNormal];
    [_imagePickerBtn setTitle:@"" forState:UIControlStateNormal];
    [_imagePickerBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _imagePickerBtn.tintColor = [UIColor whiteColor] ;
}
- (IBAction)onImagePickerBtnTap:(id)sender
{
    [self openImagePicker];
}


-(void)openImagePicker
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self.scanCtrl presentViewController:picker animated:YES completion:nil];
}
#pragma mark - imagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    [self.scanCtrl dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    CIImage *ic = [CIImage imageWithCGImage:image.CGImage];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSMutableString *str = [NSMutableString new];
    NSArray *features = [detector featuresInImage:ic];
    for (CIQRCodeFeature *f in features) {
        [str appendString:f.messageString];
    }
    if ( [features count] && str.length) {
        if ( [self.delegate respondsToSelector:@selector(imagePickerFinishDetectPhoto:)]) {
            [self.delegate imagePickerFinishDetectPhoto:str];
        }else if([self.scanCtrl.delegate respondsToSelector:@selector(scanComplete:)]){
            [self.scanCtrl.delegate scanComplete:str];
        }
    }else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.scanCtrl.navigationController.view animated:YES];
        
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"not identify qrcode";
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES afterDelay:2];
    }
}

@end
