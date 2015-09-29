//
//  ResultViewDataSource.h
//  YQRCode
//
//  Created by mickey on 15/8/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "KZBehaviour.h"
#import "ResultItemModel.h"


@interface ResultViewDataSource : KZBehaviour<UITableViewDataSource,UITableViewDelegate>
- (IBAction)onOpenBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic,readonly) NSMutableArray *rowDatas;
-(void)addModel:(ResultItemModel *)model;
-(void)removeModel:(ResultItemModel *)model cellIndexPath:(NSIndexPath *)indexPath;
-(void)addScanResult:(NSString *)str;
@end
