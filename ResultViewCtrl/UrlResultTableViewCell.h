//
//  ResultTableViewCell.h
//  YQRCode
//
//  Created by mickey on 15/8/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultItemModel.h"
@class UrlResultTableViewCell;

@protocol UrlResultTableViewCellDelegate <NSObject>
@required
-(void)onOpenBtnTap:(UIButton *)btn model:(ResultItemModel *)resultModel cell:(UrlResultTableViewCell *)viewCell;
-(void)onCopyBtnTap:(UIButton *)btn model:(ResultItemModel *)resultModel cell:(UrlResultTableViewCell *)viewCell;
-(void)onDelBtnTap:(UIButton *)btn model:(ResultItemModel *)resultModel cell:(UrlResultTableViewCell *)viewCell;
-(void)onTitleLabelTap:(UILabel *)label model:(ResultItemModel *)resultModel cell:(UrlResultTableViewCell *)viewCell;
@end

@interface UrlResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expandViewHeight;

@property (assign,nonatomic) BOOL isExpand;
@property (strong,nonatomic) ResultItemModel *dataModel;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;
@property (weak, nonatomic) IBOutlet UIView *expandView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak,nonatomic) IBOutlet id<UrlResultTableViewCellDelegate> delegate;
-(void)renderWithModel:(ResultItemModel *)model;
-(void)expandDataView;
-(void)compressedDataView;
-(CGFloat)calculateExpandHeight;
@end
