//
//  PageViewController.m
//  KIPageView
//
//  Created by SmartWalle on 15/8/19.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"无限循环Page"];
}

#pragma mark - KIPageViewDelegate
- (NSInteger)numberOfPagesInPageView:(KIPageView *)pageView {
    return self.dataSource.count;
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
    [pageViewItem setBackgroundColor:[UIColor redColor]];
    [label setText:self.dataSource[index]];
    return pageViewItem;
}

- (void)pageView:(KIPageView *)pageView didDisplayPage:(NSInteger)pageIndex {
    NSLog(@"didDisplayPage %ld", pageIndex);
}

- (void)pageView:(KIPageView *)pageView didEndDisplayingPage:(NSInteger)pageIndex {
    NSLog(@"didEndDisplayingPage %ld", pageIndex);
}

- (void)pageView:(KIPageView *)pageView didSelectedItem:(KIPageViewItem *)pageViewItem atIndex:(NSInteger)index {
    NSLog(@"选中了第 %ld 项", index);
}


@end
