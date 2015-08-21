//
//  KIPageView.h
//  KIPageView
//
//  Created by SmartWalle on 15/8/14.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIPageViewCell.h"

@class KIPageView;

#pragma mark - Typedef - KIPageViewOrientation
typedef NS_OPTIONS(NSUInteger, KIPageViewOrientation) {
    KIPageViewHorizontal = 1,
    KIPageViewVertical   = 2,
};

#pragma mark - Protocol - KIPageViewDelegate
@protocol KIPageViewDelegate <NSObject>

@required
- (NSInteger)numberOfCellsInPageView:(KIPageView *)pageView;
- (KIPageViewCell *)pageView:(KIPageView *)pageView cellAtIndex:(NSInteger)index;

@optional
//只有当 infinite 为 NO 或者 pagingEnabled 为 NO 的时候，才会调用
- (void)pageView:(KIPageView *)pageView willDisplayCell:(KIPageViewCell *)pageViewCell atIndex:(NSInteger)index;
- (void)pageView:(KIPageView *)pageView didEndDisplayingCell:(KIPageViewCell *)pageViewCell atIndex:(NSInteger)index;

- (CGFloat)pageView:(KIPageView *)pageView widthForCellAtIndex:(NSInteger)index;
- (CGFloat)pageView:(KIPageView *)pageView heightForCellAtIndex:(NSInteger)index;


//只有当 infinite 为 YES 或者 pagingEnabled 为 YES 的时候，才会调用
- (void)pageView:(KIPageView *)pageView didDisplayPage:(NSInteger)pageIndex;
- (void)pageView:(KIPageView *)pageView didEndDisplayingPage:(NSInteger)pageIndex;


- (void)pageView:(KIPageView *)pageView didSelectedCellAtIndex:(NSInteger)index;
- (void)pageView:(KIPageView *)pageView didDeselectedCellAtIndex:(NSInteger)index;

@end


#pragma mark - Interface - KIPageView
@interface KIPageView : UIView

@property (nonatomic, assign) id<KIPageViewDelegate>    delegate;
@property (nonatomic, assign) BOOL                      infinite;

@property (nonatomic, assign) BOOL                      pagingEnabled;
@property (nonatomic, assign) BOOL                      bounces;

//只有当infinite为YES的时候，才会生效
@property (nonatomic, assign) NSInteger                 cellMargin;

- (instancetype)initWithOrientation:(KIPageViewOrientation)orientation;

- (KIPageViewOrientation)pageViewOrientation;

- (NSInteger)numberOfPages;

- (CGRect)rectForPageViewCellAtIndex:(NSInteger)index;

- (NSInteger)indexOfPageViewCell:(KIPageViewCell *)item;

- (KIPageViewCell *)pageViewCellAtIndex:(NSInteger)index;

- (KIPageViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)scrollToPageViewCellAtIndex:(NSInteger)index;
- (void)scrollToPageViewCellAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)scrollToNextPage;
- (void)scrollToPreviousPage;

- (void)selectCellAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)deselectCellAtIndex:(NSInteger)index animated:(BOOL)animated;

//只有当infinite为YES的时候，才会生效；改变delegate之后，将取消自动翻页。
- (void)flipOverWithTime:(NSUInteger)time;

- (void)reloadData;

@end
