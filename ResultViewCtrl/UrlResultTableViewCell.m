//
//  ResultTableViewCell.m
//  YQRCode
//
//  Created by mickey on 15/8/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "UrlResultTableViewCell.h"
#import "ExpandViewItem.h"
#import "UIButton+Rotation.h"
#import "SampleTable/SampleTableContainer.h"
static const CGFloat expandViewBottomPadding = 15;
@interface UrlResultTableViewCell()
{
    NSString *expandTableTitle;
}
@end
@implementation UrlResultTableViewCell


-(void)awakeFromNib
{
    [self layoutContentView];
}
-(void)layoutContentView
{
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[view]|"
                          options:0
                          metrics:nil
                          views:@{@"view":self.contentView}
                          ]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[view]|"
                          options:0
                          metrics:nil
                          views:@{@"view":self.contentView}
                          ]];
}
-(void)renderWithModel:(ResultItemModel *)model
{
    
    _dataModel = model;
    _titleLabel.text = model.title;
}

-(void)expandDataView
{
    [self removeExtendViewSubViews];
    NSDictionary *mdict = [self getDataDict];
    CGRect frame = _expandView.frame;
    SampleTableContainer * ct = [[SampleTableContainer alloc] initWithData:mdict];
    [_expandView addSubview:ct];
    ct.tableTitle.text = expandTableTitle;
    [self layoutExpandViewTable:ct];
    CGFloat tableHeight = ct.frame.size.height;
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,tableHeight + expandViewBottomPadding );
    _expandView.frame = rect;
    _isExpand = YES;
    [_expandBtn toggleState];
}
-(void)layoutExpandViewTable:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *arr = [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|[view]|"
                    options:0
                    metrics:nil
                    views:@{@"view":view}
                    ];
    NSArray *arr2 = [NSLayoutConstraint
                     constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[view]-%f-|",expandViewBottomPadding]
                     options:0
                     metrics:nil
                     views:@{@"view":view}
                     ];
    [_expandView addConstraints:arr];
    [_expandView addConstraints:arr2];
}
-(NSDictionary *)getDataDict
{
    NSURLComponents *urlcoms = [[NSURLComponents alloc] initWithString:_dataModel.data];
    NSArray *queryItem = urlcoms.queryItems;
    NSInteger count = [queryItem count];
    NSMutableDictionary *mdict = [NSMutableDictionary new];
    for (NSInteger i = 0; count > i ; i++) {
        NSURLQueryItem *dict = [queryItem objectAtIndex:i];
        [mdict setValue:dict.value forKey:dict.name];
    }
    
    expandTableTitle = [NSString stringWithFormat:@"%@://%@%@",urlcoms.scheme,urlcoms.host,urlcoms.path];
    if (urlcoms.port.intValue) {
        expandTableTitle = [NSString stringWithFormat:@"%@%i",expandTableTitle,urlcoms.port.intValue];
    }
    return mdict;
}
-(void)compressedDataView
{
    [self removeExtendViewSubViews];
    CGRect frame = _expandView.frame;
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
    _expandView.frame = rect;
    _isExpand = NO;
}
-(void)removeExtendViewSubViews
{
    NSArray *arr = _expandView.subviews;
    for (NSInteger i = 0; [arr count] > i; i++) {
        UIView *v = [arr objectAtIndex:i];
        [v removeFromSuperview];
    }
}
-(CGFloat)getViewHeight
{
    CGFloat height = self.frame.size.height;
    if (_isExpand) {
        CGFloat expandViewHeight = _expandView.frame.size.height;
        height += (1 + expandViewHeight);
    }
    return height;
}
//如果是点击的是expandView区域则返回nil
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *v = [super hitTest:point withEvent:event];
    CGPoint p = [v convertPoint:point toView:_expandView];
    //NSLog(@"point :%@ ,",NSStringFromCGPoint(p));
    if ((p.x < 0 || p.y < 0 )) {
        return v;
    }
    return nil;
}
@end
