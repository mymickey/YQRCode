//
//  ResultTableViewCell.h
//  YQRCode
//
//  Created by mickey on 15/8/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultItemModel.h"
@interface UrlResultTableViewCell : UITableViewCell

@property (assign,nonatomic) BOOL isExpand;
@property (strong,nonatomic) ResultItemModel *dataModel;
@property (copy,nonatomic)NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UIView *expandView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void)renderWithModel:(ResultItemModel *)model;
-(void)expandDataView;
-(void)compressedDataView;
-(CGFloat)getViewHeight;
@end
