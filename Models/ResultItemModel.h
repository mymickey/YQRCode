//
//  ResultItemModel.h
//  YQRCode
//
//  Created by mickey on 15/8/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "MTLJSONAdapter.h"
#import "MTLModel.h"

typedef enum :NSInteger
{
    ResultItemTypeJSON,
    ResultItemTypeUrl,
    ResultItemTypeUnknow
}ResultItemType;

@interface ResultItemModel : MTLModel<MTLJSONSerializing>
@property(copy,nonatomic) NSString *title;
@property(copy,nonatomic,readonly)NSURL *url;
@property(assign,nonatomic,readonly) ResultItemType dataType;
@property(copy,nonatomic,readonly) NSString * data;
@end
