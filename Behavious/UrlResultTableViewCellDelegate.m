//
//  UrlResultTableViewCellDelegate.m
//  YQRCode
//
//  Created by mickey on 15/9/11.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "UrlResultTableViewCellDelegate.h"
#import "MBProgressHUD.h"

@implementation UrlResultTableViewCellDelegate

-(void)onCopyBtnTap:(UIButton *)btn model:(ResultItemModel *)resultModel cell:(UrlResultTableViewCell *)viewCell
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:resultModel.data];

    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:self.resultViewCtrl.navigationController.view];
    [self.resultViewCtrl.navigationController.view addSubview:HUD];
   
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    //HUD.delegate = self;
    HUD.labelText = @"Copied";
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.25];
}
-(void)onDelBtnTap:(UIButton *)btn model:(ResultItemModel *)resultModel cell:(UrlResultTableViewCell *)viewCell
{
    NSIndexPath *path = [_resultTableView indexPathForCell:viewCell];
    [_resultViewDataSource removeModel:resultModel cellIndexPath:path];
    [_resultTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)onOpenBtnTap:(UIButton *)btn model:(ResultItemModel *)resultModel cell:(UrlResultTableViewCell *)viewCell
{
    if (resultModel.dataType == ResultItemTypeUrl) {
        NSDictionary *params = @{
                                 @"toWebView":resultModel.url
                                 };
        [self.resultViewCtrl performSegueWithIdentifier:@"toWebView" sender:params];
    }
}
-(void)onTitleLabelTap:(id )label model:(ResultItemModel *)resultModel cell:(UrlResultTableViewCell *)viewCell
{
    [self onOpenBtnTap:label model:resultModel cell:viewCell];
}
@end
