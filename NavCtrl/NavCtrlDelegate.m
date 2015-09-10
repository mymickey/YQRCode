//
//  NavCtrlDelegate.m
//  YQRCode
//
//  Created by mickey on 15/9/3.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "NavCtrlDelegate.h"
#import "WebViewController.h"
@implementation NavCtrlDelegate

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[WebViewController class]]) {
        navigationController.navigationBarHidden = NO;
    }
    else{
        navigationController.navigationBarHidden = YES;
    }
}

@end
