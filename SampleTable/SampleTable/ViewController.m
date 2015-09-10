//
//  ViewController.m
//  SampleTable
//
//  Created by mickey on 15/9/5.
//  Copyright (c) 2015年 mickey. All rights reserved.
//

#import "ViewController.h"
#import "SampleTableContainer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view addConstraint:[NSLayoutConstraint
//                              constraintWithItem:self.leftView
//                              attribute:NSLayoutAttributeWidth
//                              relatedBy:NSLayoutRelationEqual
//                              toItem:self.view
//                              attribute:NSLayoutAttributeWidth
//                              multiplier:0.3
//                              constant:0]];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //return;
    NSDictionary *dict = @{
                           @"ke222y1":@"value1",
                           @"key2":@"value2",
                           @"key3":@"value3"
                           };
    SampleTableContainer * ct = [[SampleTableContainer alloc] initWithData:dict];
    //ct.backgroundColor = [UIColor whiteColor];
    //ct.frame = CGRectMake(0, 100, rect.size.width, 18 * 4 + 10);
    [self.targetView addSubview:ct];
    NSArray *arr = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":ct}];
    self.targetView.translatesAutoresizingMaskIntoConstraints = NO;
    ct.translatesAutoresizingMaskIntoConstraints = NO;
    [self.targetView addConstraints:arr];
    NSLog(@"rect:%i",self.targetView.translatesAutoresizingMaskIntoConstraints);
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
