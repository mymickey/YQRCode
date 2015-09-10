//
//  ScanResultDispatcher.h
//  YQRCode
//
//  Created by mickey on 15/8/29.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "KZBehaviour.h"
#import "MainTabBarViewController.h"
#import "SYQRCodeViewController.h"
#import "ResultViewController.h"

@interface ScanResultDispatcher : KZBehaviour<SYQRCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MainTabBarViewController *tabBarCtrl;
@property(strong,nonatomic) SYQRCodeViewController *scanViewCtrl;
@property(strong,nonatomic) ResultViewController *resultViewCtrl;
@end
