//
//  ResultViewController.h
//  YQRCode
//
//  Created by mickey on 15/8/29.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultViewDataSource.h"
@interface ResultViewController : UIViewController
@property (strong, nonatomic) IBOutlet ResultViewDataSource * dataSource;

@end
