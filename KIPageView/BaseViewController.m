//
//  BaseViewController.m
//  KIPageView
//
//  Created by SmartWalle on 15/8/19.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)loadView {
    [super loadView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self.view addSubview:self.pageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self layoutSubviews];
}

#pragma mark - Methods
- (void)layoutSubviews {
    [self.pageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.pageView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.pageView setFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.frame) - 20, CGRectGetHeight(self.view.frame) - 20)];
}

#pragma mark - Getters and setters
- (KIPageView *)pageView {
    if (_pageView == nil) {
        _pageView = [[KIPageView alloc] init];
        [_pageView setBackgroundColor:[UIColor whiteColor]];
        [_pageView setDelegate:self];
//        [_pageView setInfinite:NO];
        [_pageView setCellMargin:10];
    }
    return _pageView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        for (int i=0; i<20; i++) {
            [_dataSource addObject:[NSString stringWithFormat:@"这是第 %d 页", i]];
        }
    }
    return _dataSource;
}

@end
