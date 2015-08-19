//
//  KIPageView.h
//  KIPageView
//
//  Created by SmartWalle on 15/8/14.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIPageViewItem.h"

@class KIPageView;

#pragma mark - Typedef - KIPageViewOrientation
typedef NS_OPTIONS(NSUInteger, KIPageViewOrientation) {
    KIPageViewHorizontal = 1,
    KIPageViewVertical   = 2,
};

#pragma mark - Protocol - KIPageViewDelegate
@protocol KIPageViewDelegate <NSObject>

@required
- (NSInteger)numberOfPagesInPageView:(KIPageView *)pageView;
- (KIPageViewItem *)pageView:(KIPageView *)pageView itemAtIndex:(NSInteger)index;

@optional
//只有当 infinite 为 NO 或者 pagingEnabled 为 NO 的时候，才会调用
- (void)pageView:(KIPageView *)pageView willDisplayItem:(KIPageViewItem *)pageViewItem atIndex:(NSInteger)index;
- (void)pageView:(KIPageView *)pageView didEndDisplayingItem:(KIPageViewItem *)pageViewItem atIndex:(NSInteger)index;

- (CGFloat)pageView:(KIPageView *)pageView widthForItemAtIndex:(NSInteger)index;
- (CGFloat)pageView:(KIPageView *)pageView heightForItemAtIndex:(NSInteger)index;


//只有当 infinite 为 YES 或者 pagingEnabled 为 YES 的时候，才会调用
- (void)pageView:(KIPageView *)pageView didDisplayPage:(NSInteger)pageIndex;
- (void)pageView:(KIPageView *)pageView didEndDisplayingPage:(NSInteger)pageIndex;


- (void)pageView:(KIPageView *)pageView didSelectedItem:(KIPageViewItem *)pageViewItem atIndex:(NSInteger)index;
//- (void)pageView:(KIPageView *)pageView didDeselectedItem:(KIPageViewItem *)pageViewItem;

@end


#pragma mark - Interface - KIPageView
@interface KIPageView : UIView

@property (nonatomic, assign) id<KIPageViewDelegate>    delegate;
@property (nonatomic, assign) BOOL                      infinite;

@property (nonatomic, assign) BOOL                      pagingEnabled;
@property (nonatomic, assign) BOOL                      bounces;

//只有当infinite为YES的时候，才会生效
@property (nonatomic, assign) NSInteger                 itemMargin;

- (instancetype)initWithOrientation:(KIPageViewOrientation)orientation;

- (KIPageViewOrientation)pageViewOrientation;

- (NSInteger)numberOfPages;

- (CGRect)rectForPageViewItemAtIndex:(NSInteger)index;

- (NSInteger)indexOfPageViewItem:(KIPageViewItem *)item;

- (KIPageViewItem *)pageViewItemAtIndex:(NSInteger)index;

- (KIPageViewItem *)dequeueReusableItemWithIdentifier:(NSString *)identifier;

- (void)scrollToPageViewItemAtIndex:(NSInteger)index;
- (void)scrollToPageViewItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)scrollToNextPage;
- (void)scrollToPreviousPage;

//只有当infinite为YES的时候，才会生效；改变delegate之后，将取消自动翻页。
- (void)flipOverWithTime:(NSUInteger)time;

- (void)reloadData;

@end
