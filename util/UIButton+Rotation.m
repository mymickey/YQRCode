//
//  UIButton+Rotation.m
//  YQRCode
//
//  Created by mickey on 15/9/4.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "UIButton+Rotation.h"
#import <objc/runtime.h>
#import "ObjectiveSugar.h"
@implementation UIButton (Rotation)



-(void)toggleState
{
    //self.transform = CGAffineTransformMakeRotation( ( 180 * M_PI ) / 180 );
    [self setImage:[UIImage imageNamed:@"unfold-2"] forState:UIControlStateNormal];
}


@end
