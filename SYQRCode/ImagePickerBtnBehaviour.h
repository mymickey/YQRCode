//
//  ImagePickerBtnBehaviour.h
//  YQRCode
//
//  Created by mickey on 15/9/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "KZBehaviour.h"
#import "SYQRCodeViewController.h"

@protocol ImagePickerFinishDetectPhotoDelegate <NSObject>

-(void)imagePickerFinishDetectPhoto:(NSString *)photoStr;

@end

@interface ImagePickerBtnBehaviour : KZBehaviour<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *imgPickerBtn;
@property (weak, nonatomic) IBOutlet SYQRCodeViewController *scanCtrl;
- (IBAction)onImagePickerBtnTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *imagePickerBtn;
@property (assign,nonatomic)id <ImagePickerFinishDetectPhotoDelegate>delegate;
@end
