//
//  UrlResultTableViewCellDelegate.h
//  YQRCode
//
//  Created by mickey on 15/9/11.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "KZBehaviour.h"
#import "UrlResultTableViewCell.h"
#import "ResultViewController.h"
@interface UrlResultTableViewCellDelegate : KZBehaviour<UrlResultTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet ResultViewController *resultViewCtrl;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet ResultViewDataSource *resultViewDataSource;

@end
