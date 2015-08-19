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
    
    [self layoutSubviews];
}

#pragma mark - Methods
- (void)layoutSubviews {
    
    [self.pageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.pageView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTop
                                                             multiplier:1.0
                                                               constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageView
                                                              attribute:NSLayoutAttributeLeftMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageView
                                                             attribute:NSLayoutAttributeRightMargin
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                               constant:-10]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageView
                                                              attribute:NSLayoutAttributeBottomMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:-10]];
}

#pragma mark - Getters and setters
- (KIPageView *)pageView {
    if (_pageView == nil) {
        _pageView = [[KIPageView alloc] init];
        [_pageView setBackgroundColor:[UIColor whiteColor]];
        [_pageView setDelegate:self];
        [_pageView setItemMargin:10];
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
