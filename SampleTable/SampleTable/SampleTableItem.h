//
//  SampleTableItem.h
//  SampleTable
//
//  Created by mickey on 15/9/5.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleTableItem : UIView

@property (strong, nonatomic)  UILabel *d_key;
@property (strong, nonatomic)  UILabel *d_value;

-(instancetype) initWithKey:(NSString *)key value:(NSString *)value hasBottomLine:(BOOL)hasbottomLine;
-(void)initElement;
+(CGFloat)getItemHeight;
@end
