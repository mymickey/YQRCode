//
//  ResultViewSelectBehaviour.h
//  YQRCode
//
//  Created by mickey on 15/9/3.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "KZBehaviour.h"
#import "ResultViewController.h"

@interface ResultViewSelectBehaviour : KZBehaviour<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet ResultViewController *resultViewCtrl;
@end
