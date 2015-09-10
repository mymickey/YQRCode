//
//  ResultItemModel.m
//  YQRCode
//
//  Created by mickey on 15/8/30.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ResultItemModel.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"
#import "MTLValueTransformer.h"

@implementation ResultItemModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title":@"data",
             @"url":@"data",
             @"data":@"data",
             @"dataType":@"data"
             };
}
+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
+(NSValueTransformer *)dataTypeJSONTransformer
{    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if (value) {
            NSURL *url = [NSURL URLWithString:value];
            if (url && url.scheme && url.host) {
                return @1;
            }
        }
        return @2;
    }];
}

@end
