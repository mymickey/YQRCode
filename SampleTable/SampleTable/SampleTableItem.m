//
//  SampleTableItem.m
//  SampleTable
//
//  Created by mickey on 15/9/5.
//  Copyright (c) 2015年 mickey. All rights reserved.
//


#import "SampleTableItem.h"
static const CGFloat itemHeight = 18;
@interface SampleTableItem()
{
    CAShapeLayer *h_line;
    CAShapeLayer *key_line;
    CGFloat containerHeight;
    NSString *keyStr;
    NSString *valueStr;
    BOOL renderBottomLine;
}
@end
@implementation SampleTableItem
-(instancetype) initWithKey:(NSString *)key value:(NSString *)value hasBottomLine:(BOOL)hasBottomLine
{
    containerHeight = itemHeight;
    keyStr = key;
    valueStr = value;
    CGRect rect = CGRectMake(0, 0, 200, containerHeight);
    renderBottomLine = hasBottomLine;
    self = [super initWithFrame:rect];
    return self;
}
+(CGFloat)getItemHeight
{
    return itemHeight;
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    
    [super willMoveToSuperview:newSuperview];
    [self initElement];
}
-(void)initElement
{
    [self initSubView];
    [self setLayout];
}
-(void)initSubView
{
    _d_key = [[UILabel alloc] init];
    _d_value = [[UILabel alloc] init];
    _d_value.text = valueStr;
    _d_key.text = keyStr;
    _d_key.font = [UIFont fontWithName:_d_key.font.familyName size:12];
    _d_value.font = [UIFont fontWithName:_d_key.font.familyName size:12];
    [self addSubview:_d_key];
    [self addSubview:_d_value];

}
-(void)setLayout
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _d_value.translatesAutoresizingMaskIntoConstraints = NO;
    _d_key.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDict = @{@"key":_d_key,@"value":_d_value};
    //key value上下约束
    NSArray *key_topAndBottom = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"V:|-(-2)-[key]|"
                             options:0
                             metrics:nil
                             views:viewDict
                             ];
    NSArray *value_topAndBottom = [NSLayoutConstraint
                                 constraintsWithVisualFormat:@"V:|-(-2)-[value]|"
                                 options:0
                                 metrics:nil
                                 views:viewDict
                                 ];
    NSArray *keyLeft = [NSLayoutConstraint
                             constraintsWithVisualFormat:@"H:|-10-[key]"
                             options:0
                             metrics:nil
                             views:viewDict
                             ];
    NSArray *valueRight = [NSLayoutConstraint
                        constraintsWithVisualFormat:@"H:[value]-10-|"
                        options:0
                        metrics:nil
                        views:viewDict
                        ];
    NSArray *keyValueHSpace = [NSLayoutConstraint
                        constraintsWithVisualFormat:@"H:[key]-18-[value]"
                        options:0
                        metrics:nil
                        views:viewDict
                        ];
    [self addConstraints:key_topAndBottom];
    [self addConstraints:value_topAndBottom];
    [self addConstraints:keyLeft];
    [self addConstraints:valueRight];
    [self addConstraints:keyValueHSpace];
    //让key 键宽度等于父元素宽度的20%
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_d_key
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:0.2
                         constant:0]];
}
-(void)layoutSubviews
{
    
    [super layoutSubviews];
    [h_line removeFromSuperlayer];
    [key_line removeFromSuperlayer];
    [self addKeyLine];
    [self addHBorder];
}
- (void) addHBorder{
    if (!renderBottomLine) {
        return;
    }
    //参考http://itquestionz.com/questions/94344/dashed-line-border-around-uiview
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGSize frameSize = self.frame.size;
    
    //CGRect shapeRect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    [shapeLayer setBounds:CGRectMake(0.0f, 0.0f, frameSize.width, 0)];
    [shapeLayer setPosition:CGPointMake( frameSize.width/2,frameSize.height-1)];
    
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:217.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
      [NSNumber numberWithInt:1],
      nil]];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0  , 0)];
    [path addLineToPoint:CGPointMake(frameSize.width, 0)];
    [shapeLayer setPath:path.CGPath];
    
    [self.layer addSublayer:shapeLayer];
    h_line = shapeLayer;
}
-(void)addKeyLine
{
    //参考http://itquestionz.com/questions/94344/dashed-line-border-around-uiview
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGSize frameSize = self.d_key.frame.size;
    
    //CGRect shapeRect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    [shapeLayer setBounds:CGRectMake(0.0f, 0.0f, frameSize.width, 0)];
    [shapeLayer setPosition:CGPointMake( frameSize.width/2+frameSize.width + 6 ,0)];
    
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [shapeLayer setStrokeColor:[[UIColor colorWithRed:217.0f/255.0f green:217.0f/255.0f blue:217.0f/255.0f alpha:1] CGColor]];
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:1],
      [NSNumber numberWithInt:1],
      nil]];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(0,frameSize.height)];
    [shapeLayer setPath:path.CGPath];
    
    [self.d_key.layer addSublayer:shapeLayer];
    key_line =shapeLayer;
}
@end
