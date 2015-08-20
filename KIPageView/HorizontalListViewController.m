//
//  HorizontalListViewController.m
//  KIPageView
//
//  Created by SmartWalle on 15/8/19.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "HorizontalListViewController.h"

@interface HorizontalListViewController ()

@end

@implementation HorizontalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - KIPageViewDelegate
- (NSInteger)numberOfCellsInPageView:(KIPageView *)pageView {
    return self.dataSource.count;
}

- (CGFloat)pageView:(KIPageView *)pageView widthForCellAtIndex:(NSInteger)index {
    return 50;
}

- (KIPageViewCell *)pageView:(KIPageView *)pageView cellAtIndex:(NSInteger)index {
    static NSString *PAGE_VIEW_CELL_IDENTIFIER = @"PageViewCell";
    
    KIPageViewCell *pageViewCell = [pageView dequeueReusableCellWithIdentifier:PAGE_VIEW_CELL_IDENTIFIER];
    UILabel *label = (UILabel *)[pageViewCell viewWithTag:1001];
    if (pageViewCell == nil) {
        pageViewCell = [[KIPageViewCell alloc] initWithIdentifier:PAGE_VIEW_CELL_IDENTIFIER];
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        [label setTextColor:[UIColor blackColor]];
        [label setTag:1001];
        [pageViewCell addSubview:label];
    }
    if (index % 2 == 0) {
        [pageViewCell setBackgroundColor:[UIColor greenColor]];
    } else {
        [pageViewCell setBackgroundColor:[UIColor redColor]];
    }
    
    [label setText:[NSString stringWithFormat:@"%ld", index]];
    return pageViewCell;
}

- (void)pageView:(KIPageView *)pageView willDisplayCell:(KIPageViewCell *)pageViewItem atIndex:(NSInteger)index {
    NSLog(@"willDisplayCell %ld", index);
}

- (void)pageView:(KIPageView *)pageView didEndDisplayingCell:(KIPageViewCell *)pageViewItem atIndex:(NSInteger)index {
    NSLog(@"didEndDisplayingCell %ld", index);
}

- (void)pageView:(KIPageView *)pageView didSelectedCell:(KIPageViewCell *)pageViewItem atIndex:(NSInteger)index {
    NSLog(@"选中了第 %ld 项", index);
}

#pragma mark - Getters and setters
- (KIPageView *)pageView {
    if (_pageView == nil) {
        _pageView = [[KIPageView alloc] initWithOrientation:KIPageViewHorizontal];
        [_pageView setBackgroundColor:[UIColor whiteColor]];
        [_pageView setDelegate:self];
        [_pageView setPagingEnabled:NO];
    }
    return _pageView;
}

@end
