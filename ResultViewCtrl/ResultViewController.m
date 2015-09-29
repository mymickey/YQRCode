//
//  ResultViewController.m
//  YQRCode
//
//  Created by mickey on 15/8/29.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ResultViewController.h"
#import "WebViewController.h"
@interface ResultViewController ()

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"toWebView"]) {
        NSDictionary *dict = sender;
        NSURL *url = [dict objectForKey:@"toWebView"];
        WebViewController *w = segue.destinationViewController;
        w.url = url;
    }
}



@end
