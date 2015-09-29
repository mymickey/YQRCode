//
//  SampleTableContainer.m
//  SampleTable
//
//  Created by mickey on 15/9/5.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "SampleTableContainer.h"
#import "SampleTableItem.h"
#import "UILabel+Copyable.h"
static CGFloat const titleAndRowCtVSpace = 4;
static CGFloat const titleHeight = 18;
@interface SampleTableContainer(){
    NSDictionary * _dict;
}
@end
@implementation SampleTableContainer
-(instancetype)initWithData:(NSDictionary *)dict
{
    CGRect rect = [UIScreen mainScreen].bounds;
    NSInteger count = [dict.allKeys count];
    CGFloat itemHeight = [SampleTableItem getItemHeight];
    CGFloat height = count * itemHeight + titleAndRowCtVSpace + titleHeight;
    self = [super initWithFrame:CGRectMake(0, 0, rect.size.width, height)];
    _dict = dict;
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    
    [super willMoveToSuperview:newSuperview];
    [self initSubview];
    [self setData:_dict];
}
-(void)initSubview
{
    _rowsContainer = [[UIView alloc] init];
    _tableTitle = [[UILabel alloc] init];
    _tableTitle.text= @"";
    _tableTitle.copyingEnabled = YES;
    _tableTitle.font = [UIFont fontWithName:_tableTitle.font.familyName size:12];
    _rowsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    _tableTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_tableTitle];
    [self addSubview:_rowsContainer];
    [self initSubviewLayout];
}
-(void)initSubviewLayout
{
    NSDictionary *viewDict = @{@"rowCt":_rowsContainer,@"label":_tableTitle};
    NSArray *label = [NSLayoutConstraint
                                 constraintsWithVisualFormat:@"H:|-10-[label]|"
                                 options:0
                                 metrics:nil
                                 views:viewDict
                                 ];
    NSArray *rowCt = [NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-20-[rowCt]-20-|"
                          options:0
                          metrics:nil
                          views:viewDict
                          ];
    NSArray *label_rowCt_v_space = [NSLayoutConstraint
                             constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[label]-%f-[rowCt]|",titleAndRowCtVSpace]
                             options:0
                             metrics:nil
                             views:viewDict
                             ];
    NSLayoutConstraint *rowCtHeight = [NSLayoutConstraint constraintWithItem:_rowsContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [self addConstraint:rowCtHeight];
    [self addConstraints:label];
    [self addConstraints:rowCt];
    [self addConstraints:label_rowCt_v_space];
    _heightContsraint = rowCtHeight;
}
-(void)setData:(NSDictionary *)dict
{
    
    SampleTableItem * instanceItem = [[SampleTableItem alloc] initWithKey:@"" value:@"" hasBottomLine:YES];
    CGRect rect = instanceItem.frame;
    CGFloat itemHeight = rect.size.height;
    NSInteger i =0;
    NSInteger keyCount = [[dict allKeys] count] ;
    for (NSString *key in dict) {
        BOOL has = keyCount != ( i + 1);
        SampleTableItem *item = [[SampleTableItem alloc] initWithKey:key value:[dict objectForKey:key] hasBottomLine:has];
        [_rowsContainer addSubview:item];
        [self setItemConstraint:item andTop:itemHeight * i];
        i++;
    }
   
    CGFloat height = rect.size.height * i;
    _heightContsraint.constant = height;
    
    //[self.superview layoutIfNeeded];
}

-(void)setItemConstraint:(UIView *)view andTop:(CGFloat)top
{
    NSArray *h = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|[view]|"
                             options:0
                             metrics:nil
                             views:@{@"view":view}
                             ];
    NSArray *topConstraint = [NSLayoutConstraint
                             constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[view]",top]
                             options:0
                             metrics:nil
                             views:@{@"view":view}
                             ];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[SampleTableItem getItemHeight]];
    [view.superview addConstraint:height];
    [view.superview addConstraints:h];
    [view.superview addConstraints:topConstraint];
    //[view.superview layoutIfNeeded];
}
-(CGFloat)calculateHeight
{
    CGFloat height;
    CGFloat itemHeight = [SampleTableItem getItemHeight];
    NSInteger itemCount = [[_dict allKeys] count];
    height = itemHeight * itemCount + titleHeight + titleAndRowCtVSpace;
    return height;
}
@end
