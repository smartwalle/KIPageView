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
- (NSInteger)numberOfPagesInPageView:(KIPageView *)pageView {
    return self.dataSource.count;
}

- (CGFloat)pageView:(KIPageView *)pageView widthForItemAtIndex:(NSInteger)index {
    return 50;
}

- (KIPageViewItem *)pageView:(KIPageView *)pageView itemAtIndex:(NSInteger)index {
    static NSString *PAGE_VIEW_ITEM_IDENTIFIER = @"PageViewItem";
    
    KIPageViewItem *pageViewItem = [pageView dequeueReusableItemWithIdentifier:PAGE_VIEW_ITEM_IDENTIFIER];
    UILabel *label = (UILabel *)[pageViewItem viewWithTag:1001];
    if (pageViewItem == nil) {
        pageViewItem = [[KIPageViewItem alloc] initWithIdentifier:PAGE_VIEW_ITEM_IDENTIFIER];
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        [label setTextColor:[UIColor blackColor]];
        [label setTag:1001];
        [pageViewItem addSubview:label];
    }
    if (index % 2 == 0) {
        [pageViewItem setBackgroundColor:[UIColor greenColor]];
    } else {
        [pageViewItem setBackgroundColor:[UIColor redColor]];
    }
    
    [label setText:[NSString stringWithFormat:@"%ld", index]];
    return pageViewItem;
}

- (void)pageView:(KIPageView *)pageView willDisplayItem:(KIPageViewItem *)pageViewItem atIndex:(NSInteger)index {
    NSLog(@"willDisplayItem %ld", index);
}

- (void)pageView:(KIPageView *)pageView didEndDisplayingItem:(KIPageViewItem *)pageViewItem atIndex:(NSInteger)index {
    NSLog(@"didEndDisplayingItem %ld", index);
}

- (void)pageView:(KIPageView *)pageView didSelectedItem:(KIPageViewItem *)pageViewItem atIndex:(NSInteger)index {
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
