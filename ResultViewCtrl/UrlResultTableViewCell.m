//
//  ResultTableViewCell.m
//  YQRCode
//
//  Created by mickey on 15/8/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "UrlResultTableViewCell.h"
#import "SampleTableContainer.h"
#import "UILabel+Copyable.h"
#import "EDColor.h"
static const CGFloat expandViewBottomPadding = 15;
static const CGFloat expandViewBtnCtHeight = 40;
static const CGFloat expandViewBtnHeight = 22;
static const CGFloat expandViewBtnWidth = 50;
#define CELLHEIGHT  44
@interface UrlResultTableViewCell()
{
    NSString *expandTableTitle;
    UIView *buttonCt;
}
@end
@implementation UrlResultTableViewCell


-(void)awakeFromNib
{
    [self layoutContentView];
}
-(void)setTitleLabel:(UILabel *)titleLabel
{
    _titleLabel = titleLabel;
    _titleLabel.copyingEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTitleTap:)];
    [_titleLabel addGestureRecognizer:tap];
}
-(void)onTitleTap:sender
{
    if (self.delegate) {
        [self.delegate onTitleLabelTap:sender model:self.dataModel cell:self];
     }
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
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,tableHeight + expandViewBottomPadding + expandViewBtnCtHeight );
    //_expandView.frame = rect;
    _expandViewHeight.constant = rect.size.height;
    [self createExpandBtnsCt];
    _isExpand = YES;
    [_expandBtn setImage:[UIImage imageNamed:@"unfold-2"] forState:UIControlStateNormal];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor colorWithRed:24.0f/255.0f green:133.0f/255.0f blue:255.0f/255.0f alpha:1];
}
//将展开 table 与expandView进行约束
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
                     constraintsWithVisualFormat:
                        [NSString stringWithFormat:@"V:|-%f-[view]-%f-|",expandViewBtnCtHeight,expandViewBottomPadding]
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
    _titleLabel.numberOfLines = 1;
    [self.expandBtn setImage:[UIImage imageNamed:@"unfold"] forState:UIControlStateNormal];
    _titleLabel.textColor = [UIColor blackColor];
}
-(void)removeExtendViewSubViews
{
    NSArray *arr = _expandView.subviews;
    for (NSInteger i = 0; [arr count] > i; i++) {
        UIView *v = [arr objectAtIndex:i];
        [v removeFromSuperview];
    }
}

//创建 按钮 copy delete open
-(void) createExpandBtnsCt
{
    //上边框
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(20, 0, CGRectGetWidth(self.frame) * 3, .5f);
    border.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1].CGColor;
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _expandView.frame.size.width, expandViewBtnCtHeight)];
    SampleTableContainer *table = (SampleTableContainer *)_expandView.subviews[0];
    v.translatesAutoresizingMaskIntoConstraints = NO;
    [_expandView addSubview:v];
    NSArray *arr = [NSLayoutConstraint
                     constraintsWithVisualFormat:
                    [NSString
                        stringWithFormat:@"V:[view]-%f-|",table.frame.size.height+expandViewBottomPadding]
                     options:0
                     metrics:nil
                     views:@{@"view":v,@"table":table}
                     ];
    NSArray *arr2 = [NSLayoutConstraint
                    constraintsWithVisualFormat:@"H:|[view]|"
                    options:0
                    metrics:nil
                    views:@{@"view":v}
                    ];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:v attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:expandViewBtnCtHeight];
    [_expandView addConstraints:arr];
    [_expandView addConstraints:arr2];
    [v addConstraint:height];
    [v.layer addSublayer:border];
    [self createExpandBtns:v];
    buttonCt = v;
}

-(void)createExpandBtns:(UIView *)ct
{
    UIButton *delBtn = [self createExpandBtn:@"Delete" ct:ct];
    UIButton *copyBtn = [self createExpandBtn:@"Copy" ct:ct];
    UIButton *openBtn = [self createExpandBtn:@"Open" ct:ct];
    delBtn.tag = 1;
    copyBtn.tag = 2;
    openBtn.tag = 3;
    NSDictionary *dict =@{@"copyBtn":copyBtn,@"delBtn":delBtn,@"openBtn":openBtn};
    
    NSLayoutConstraint *centerYDelBtn = [NSLayoutConstraint constraintWithItem:delBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:ct attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *centerYCopyBtn = [NSLayoutConstraint constraintWithItem:copyBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:ct attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *centerYOpenBtn = [NSLayoutConstraint constraintWithItem:openBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:ct attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSArray *HLayout = [NSLayoutConstraint
                    constraintsWithVisualFormat:
                        [NSString
                         stringWithFormat:
                            @"H:[openBtn(==%f)]-8-[copyBtn(==%f)]-8-[delBtn(==%f)]-8-|",
                                expandViewBtnWidth,expandViewBtnWidth,expandViewBtnWidth
                         ]
                    options:0
                    metrics:nil
                    views:dict];
    
    [ct addConstraint:centerYDelBtn];
    [ct addConstraint:centerYCopyBtn];
    [ct addConstraint:centerYOpenBtn];
    [ct addConstraints:HLayout];
}
-(void)onBtnTap:(UIButton *)btn
{
    //    delBtn.tag = 1;
    //    copyBtn.tag = 2;
    //    openBtn.tag = 3;
    [self resetButtonBackGroundColor:btn];
    if (self.delegate) {
        if (btn.tag == 1) {
            [self.delegate onDelBtnTap:btn model:_dataModel cell:self];
        }else if(btn.tag == 2){
            [self.delegate onCopyBtnTap:btn model:_dataModel cell:self];
        }else{
            [self.delegate onOpenBtnTap:btn model:_dataModel cell:self];
        }
    }
    

}
//工具栏按钮 点击
-(void)onBtnTapDown:(UIButton *)btn
{
    btn.alpha = .5;
}
-(void)resetButtonBackGroundColor:(UIButton *)btn
{
    btn.alpha = 1;
    //[btn setBackgroundColor:[UIColor whiteColor]];
}
-(UIButton *)createExpandBtn:(NSString *)text ct:(UIView *)ct
{
    //36 112 185
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitleColor:[UIColor
                        colorWithRed:29.0/255.0 green:91.0/255.0 blue:171.0/255.0 alpha:1]
                        forState:UIControlStateNormal];
    //[btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont fontWithName:btn.titleLabel.font.fontName size:12];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:text forState:UIControlStateNormal];
    btn.layer.cornerRadius = 5;//half of the width
    btn.layer.borderColor = [UIColor colorWithRed:126.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1].CGColor;
    btn.layer.borderWidth=.8f;
    [ct addSubview:btn];
    [self layoutExpandBtn:btn];
    [btn addTarget:self action:@selector(onBtnTapDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(onBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(resetButtonBackGroundColor:) forControlEvents:UIControlEventTouchUpOutside];
    return btn;
}
-(void)layoutExpandBtn:(UIButton *)btn
{
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:expandViewBtnHeight];
    [btn addConstraint:height];
}
-(CGFloat)calculateExpandHeight
{
    CGFloat titleLabelExpandHeight = [self calculateTitleLabelExpandHeight];
    NSDictionary *mdict = [self getDataDict];
    SampleTableContainer * ct = [[SampleTableContainer alloc] initWithData:mdict];
    return [ct calculateHeight] + expandViewBottomPadding + expandViewBtnCtHeight + titleLabelExpandHeight;
}
//计算titleLabel展开后的高度
-(CGFloat)calculateTitleLabelExpandHeight
{
    _titleLabel.numberOfLines = 0;
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGSize textViewSize = [_titleLabel sizeThatFits:CGSizeMake(_titleLabel.frame.size.width, FLT_MAX)];
    CGPoint p = [_titleLabel convertPoint:_titleLabel.frame.origin toView:_titleLabel.superview];
    CGFloat titleLabelExpandHeight = _titleLabel.superview.frame.size.height;//标题全字符展开高度
    if (size.height < textViewSize.height) {
        titleLabelExpandHeight = textViewSize.height + p.y;
    }
    if (titleLabelExpandHeight < CELLHEIGHT) {
        titleLabelExpandHeight = CELLHEIGHT;
    }
    return titleLabelExpandHeight;
}
//如果是点击的是expandView区域则返回nil
//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *v = [super hitTest:point withEvent:event];
//    if ([_expandView.subviews count] && ![v isKindOfClass:[UIButton class]]) {
//        CGPoint p = [_expandView convertPoint:point fromView:self.contentView];
//        //NSLog(@"point :%@ ,",NSStringFromCGPoint(p2));
//        if ((p.x < 0 || p.y < 0 )) {
//            return v;
//        }
//        return nil;
//    }
//    return v;
//}
@end
