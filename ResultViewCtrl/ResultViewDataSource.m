//
//  ResultViewDataSource.m
//  YQRCode
//
//  Created by mickey on 15/8/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ResultViewDataSource.h"
#import "UrlResultTableViewCell.h"
#import "UIButton+Rotation.h"
static NSString *const cellId = @"UrlResultCell";
@interface ResultViewDataSource()
{
    NSIndexPath *_expandIndexPath;
    UrlResultTableViewCell *_urlPrototypeCell;
}
@end
@implementation ResultViewDataSource
-(void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _rowDatas = [NSMutableArray new];
    [self addScanResult:@"http://baidu.com/?q=1"];
    [self addScanResult:@"https://s.taobao.com/search?initiative_id=tbindexz_20150903&spm=a21bo.7724922.8452-taobao-item.2&sourceId=tb.index&search_type=item&ssid=s5-e&commend=all&imgfile=&q=iphone6%E6%89%8B%E6%9C%BA%E5%A3%B3&suggest=0_1&_input_charset=utf-8&wq=iphone&suggest_query=iphone&source=suggest"];
    
    _urlPrototypeCell = [_tableView dequeueReusableCellWithIdentifier:cellId];
}
-(void)addModel:(ResultItemModel *)model
{
    [_rowDatas addObject:model];
    [_tableView reloadData];
}
-(void)addScanResult:(NSString *)str
{
    NSError *err;
    ResultItemModel *m = [MTLJSONAdapter modelOfClass:[ResultItemModel class] fromJSONDictionary:@{@"data":str} error:&err];
    if (!err) {
        [self addModel:m];
    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UrlResultTableViewCell *cell = _urlPrototypeCell;
    ResultItemModel * m = [_rowDatas objectAtIndex:indexPath.row];
    [cell renderWithModel:m];
    if (_expandIndexPath && ([_expandIndexPath compare:indexPath] == NSOrderedSame)) {
        [cell expandDataView];
    }
    else{
        [cell compressedDataView];
    }
    return [cell getViewHeight];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UrlResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    ResultItemModel *model = [_rowDatas objectAtIndex:indexPath.row];
    [cell renderWithModel:model];
    cell.indexPath = indexPath;
    if (_expandIndexPath && [indexPath compare:_expandIndexPath] == NSOrderedSame) {
        [cell expandDataView];
        //[cell layoutIfNeeded];
    }
    else{
        [cell compressedDataView];
    }
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_rowDatas count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (IBAction)onOpenBtnClick:(UIButton *)sender {
    UrlResultTableViewCell *cell = (UrlResultTableViewCell *)sender.superview.superview;
    NSIndexPath *oldPath = _expandIndexPath;
    NSMutableArray *paths = [NSMutableArray new];
    if (oldPath && [oldPath compare:cell.indexPath] == NSOrderedSame) {
        cell.indexPath = nil;
        _expandIndexPath = nil;
    }
    _expandIndexPath = cell.indexPath;
    if (oldPath) {
        [paths addObject:oldPath];
    }
    if (cell.indexPath) {
        [paths addObject:cell.indexPath];
    }
    [_tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
}
@end
