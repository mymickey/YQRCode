//
//  ResultViewSelectBehaviour.m
//  YQRCode
//
//  Created by mickey on 15/9/3.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ResultViewSelectBehaviour.h"
#import "UrlResultTableViewCell.h"
#import "ResultItemModel.h"

@implementation ResultViewSelectBehaviour
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UrlResultTableViewCell *cell = (UrlResultTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    ResultItemModel *model = cell.dataModel;
    [self didRowSelectWithModel:model index:indexPath];
}
-(void)didRowSelectWithModel:(ResultItemModel *)model index:(NSIndexPath *)indexPath
{
    if (model.dataType == ResultItemTypeUrl) {
        //NSLog(@"select url %@",model.url);
        NSDictionary *params = @{
                                 @"toWebView":model.url
                                 };
        [self.resultViewCtrl performSegueWithIdentifier:@"toWebView" sender:params];
    }
}

@end
