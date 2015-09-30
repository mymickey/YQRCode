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
    NSTimer *touchExpandTimer;
}
@end
@implementation ResultViewDataSource
-(void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _rowDatas = [NSMutableArray new];
    [self addScanResult:@"http://open.alink.aliyun.com/alinkpackage/test.php"];
    [self addScanResult:@"http://baidu.com/?q=1"];
    [self addScanResult:@"https://s.taobao.com/search?initiative_id=tbindexz_20150903&spm=a21bo.7724922.8452-taobao-item.2&sourceId=tb.index&search_type=item&ssid=s5-e&commend=all&imgfile=&q=iphone6%E6%89%8B%E6%9C%BA%E5%A3%B3&suggest=0_1&_input_charset=utf-8&wq=iphone&suggest_query=iphone&source=suggest"];
    [self addScanResult:@"123242342342341231242599995612324234234234123124259999561232423423423412312425999956123242342342341231242599995612324234234234123124259999561232423423423412312425999956"];
    _urlPrototypeCell = [_tableView dequeueReusableCellWithIdentifier:cellId];
}
-(void)addModel:(ResultItemModel *)model
{
    [_rowDatas addObject:model];
    [_tableView reloadData];
}
-(void)removeModel:(ResultItemModel * )model cellIndexPath:(NSIndexPath *)indexPath
{
    [_rowDatas removeObject:model];
    if ([indexPath compare:_expandIndexPath] == NSOrderedSame) {
        _expandIndexPath = nil;
    }
}
-(void)addScanResult:(NSString *)str
{
    NSError *err;
    ResultItemModel *m = [MTLJSONAdapter modelOfClass:[ResultItemModel class] fromJSONDictionary:@{@"data":str} error:&err];
    if (!err) {
        [self addModel:m];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UrlResultTableViewCell *cell = (UrlResultTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    ResultItemModel *model = cell.dataModel;
    [self removeModel:model cellIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UrlResultTableViewCell *cell = _urlPrototypeCell;
    ResultItemModel * m = [_rowDatas objectAtIndex:indexPath.row];
    CGFloat lineHeight = [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    [cell renderWithModel:m];
    CGFloat height ;
    if (_expandIndexPath && ([_expandIndexPath compare:indexPath] == NSOrderedSame)) {
        height = [cell calculateExpandHeight]  ;
    }
    else{
        height = lineHeight;
    }
    return height+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UrlResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    ResultItemModel *model = [_rowDatas objectAtIndex:indexPath.row];
    [cell renderWithModel:model];
    if (_expandIndexPath && [indexPath compare:_expandIndexPath] == NSOrderedSame) {
        [cell expandDataView];
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
    if (touchExpandTimer) {
        [touchExpandTimer invalidate];
    }
    __weak typeof(self) weakSelf = self;
    touchExpandTimer = [NSTimer timerWithTimeInterval:.2f target:weakSelf selector:@selector(didExpand:) userInfo:cell repeats:NO];
    [[NSRunLoop  currentRunLoop] addTimer:touchExpandTimer forMode:NSDefaultRunLoopMode];
}
-(void)didExpand:(NSTimer *)timer
{
    UrlResultTableViewCell *cell = timer.userInfo;
    [timer invalidate];
    touchExpandTimer = nil;
    NSIndexPath *currentClickIndexPath = [_tableView indexPathForCell:cell];
    NSIndexPath *oldPath = _expandIndexPath;
    NSMutableArray *paths = [NSMutableArray new];
    if (oldPath && [oldPath compare:currentClickIndexPath] == NSOrderedSame) {
        _expandIndexPath = nil;
    }
    else{
        _expandIndexPath = currentClickIndexPath;
    }
    if (oldPath) {
        [paths addObject:oldPath];
    }
    if (currentClickIndexPath) {
        [paths addObject:currentClickIndexPath];
    }
    if ([paths count] == 2 && [paths[0] compare:paths[1]] == NSOrderedSame) {
        [paths removeObjectAtIndex:0];
    }
    [_tableView beginUpdates];
    [_tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
}
@end
