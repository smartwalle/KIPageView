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
- (NSInteger)numberOfCellsInPageView:(KIPageView *)pageView {
    return self.dataSource.count;
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
    [pageViewCell setBackgroundColor:[UIColor redColor]];
    [label setText:self.dataSource[index]];
    
    return pageViewCell;
}

- (void)pageView:(KIPageView *)pageView didDisplayPage:(NSInteger)pageIndex {
    NSLog(@"didDisplayPage %ld", pageIndex);
}

- (void)pageView:(KIPageView *)pageView didEndDisplayingPage:(NSInteger)pageIndex {
    NSLog(@"didEndDisplayingPage %ld", pageIndex);
}

- (void)pageView:(KIPageView *)pageView didSelectedCellAtIndex:(NSInteger)index {
    NSLog(@"选中了第 %ld 项", index);
}

- (void)pageView:(KIPageView *)pageView didDeselectedCellAtIndex:(NSInteger)index {
    NSLog(@"取消选中 %ld", index);
}

@end
