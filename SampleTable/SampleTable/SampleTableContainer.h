//
//  SampleTableContainer.h
//  SampleTable
//
//  Created by mickey on 15/9/5.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleTableContainer : UIView
@property (strong, nonatomic)  NSLayoutConstraint *heightContsraint;
@property (strong, nonatomic)  UIView *rowsContainer;
@property (strong, nonatomic)  UILabel *tableTitle;
@property (nonatomic,strong,readonly) NSArray *rows;
-(instancetype)initWithData:(NSDictionary *)dict;
-(CGFloat)calculateHeight;
@end
