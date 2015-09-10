//
//  ViewController.m
//  YQRCode
//
//  Created by mickey on 15/8/28.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ViewController.h"
#import "SYQRCodeViewController.h"
@interface ViewController ()
- (IBAction)startScan:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLComponents *components = [NSURLComponents componentsWithString:@"http://stackoverflow.com/user?sa=a&sdq=q1#has1h"];
    NSArray *arr = components.queryItems;
    NSURLQueryItem *queryItem = [arr objectAtIndex:0];
    NSLog(@"key:%@,value:%@",queryItem.name,queryItem.value);
    NSLog(@"path:%@,fragment:%@,query:%@",components.path,components.fragment,components.query);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startScan:(id)sender {
    //扫描二维码
    SYQRCodeViewController *qrcodevc = [[SYQRCodeViewController alloc] init];
    qrcodevc.SYQRCodeSuncessBlock = ^(SYQRCodeViewController *aqrvc,NSString *qrString){
        //self.saomiaoLabel.text = qrString;
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeFailBlock = ^(SYQRCodeViewController *aqrvc){
        //self.saomiaoLabel.text = @"fail~";
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
    };
    qrcodevc.SYQRCodeCancleBlock = ^(SYQRCodeViewController *aqrvc){
        [aqrvc dismissViewControllerAnimated:NO completion:nil];
        //self.saomiaoLabel.text = @"cancle~";
    };
    [self presentViewController:qrcodevc animated:YES completion:nil];
}
@end
