//
//  ScanResultDispatcher.m
//  YQRCode
//
//  Created by mickey on 15/8/29.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ScanResultDispatcher.h"
#import <AVFoundation/AVFoundation.h>
@implementation ScanResultDispatcher
-(void)setTabBarCtrl:(MainTabBarViewController *)tabBarCtrl
{
    _tabBarCtrl = tabBarCtrl;
    NSArray * viewCtrls = tabBarCtrl.viewControllers;
    _resultViewCtrl = viewCtrls[0];
    _scanViewCtrl = viewCtrls[1];
    _scanViewCtrl.delegate = self;
}
-(void)scanComplete:(AVMetadataMachineReadableCodeObject *)obj
{
    NSString *resultStr = obj.stringValue;
    _tabBarCtrl.selectedIndex = 0;
    [_resultViewCtrl.dataSource addScanResult:resultStr];
}

@end
