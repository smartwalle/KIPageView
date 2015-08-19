//
//  KIPageView.m
//  KIPageView
//
//  Created by SmartWalle on 15/8/14.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "KIPageView.h"

#pragma mark - Category KIPageViewItem(KIPageView)
@interface KIPageViewItem (KIPageView)
@end

@implementation KIPageViewItem (KIPageView)

- (NSInteger)_pageViewItemIndex {
    return [[self valueForKey:@"_itemIndex"] integerValue];
}

- (void)_setPageViewItemIndex:(NSInteger)index {
    [self setValue:@(index) forKey:@"_itemIndex"];
}

@end


#pragma mark - Extension KIPageView
@interface KIPageView () <UIScrollViewDelegate>

#pragma mark - Property
@property (nonatomic, assign) KIPageViewOrientation pageViewOrientation;
@property (nonatomic, strong) NSMutableSet          *visibleItems;
@property (nonatomic, strong) NSMutableSet          *recycledItems;
@property (nonatomic, strong) NSMutableDictionary   *reusableItems;
@property (nonatomic, strong) NSMutableArray        *rectForItems;

@property (nonatomic, assign) NSInteger     totalPages;
@property (nonatomic, assign) NSInteger     currentPageIndex;

@property (nonatomic, strong) UIScrollView  *scrollView;

@property (nonatomic, assign) NSUInteger    timeInterval;
@property (nonatomic, strong) NSTimer       *timer;

@end

@implementation KIPageView

#pragma mark - Lifecycle
- (void)dealloc {
    [self invalidTimer];
    [self.visibleItems enumerateObjectsUsingBlock:^(KIPageViewItem *obj, BOOL *stop) {
        [obj removeObserver:self forKeyPath:@"selected" context:nil];
    }];
}

- (instancetype)initWithOrientation:(KIPageViewOrientation)orientation {
    if (self = [super init]) {
        [self _initFinishedWithOrientation:orientation];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _initFinishedWithOrientation:KIPageViewHorizontal];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _initFinishedWithOrientation:KIPageViewHorizontal];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initFinishedWithOrientation:KIPageViewHorizontal];
    }
    return self;
}

- (void)removeFromSuperview {
    [self invalidTimer];
    [super removeFromSuperview];
}

- (void)layoutSubviews {
    CGRect rect = self.bounds;
    if ([self infinitable] || self.pagingEnabled) {
        if (self.pageViewOrientation == KIPageViewVertical) {
            rect.size.height += self.itemMargin;
        } else {
            rect.size.width += self.itemMargin;
        }
    }
    [self.scrollView setFrame:rect];
    
    if (self.delegate != nil) {
        if ([self indexOutOfBounds:self.currentPageIndex]) {
            [self setCurrentPageIndex:0];
        }
        [self reloadDataAndScrollToIndex:self.currentPageIndex];
    }
}

#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selected"] && [object isKindOfClass:[KIPageViewItem class]]) {
        
        BOOL selected = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (selected) {
            [self didSelectedItem:object];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updatePageViewItems];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //开始拖曳的时候，暂时将timer设置无效
    [self invalidTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //结束拖曳的时候，重新启动timer
    [self flipOverWithTime:self.timeInterval];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateDidDisplayPageIndex:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateDidDisplayPageIndex:scrollView];
}

#pragma mark - Methods
#pragma mark **************************************************
#pragma mark 【初始化】
#pragma mark **************************************************
- (void)_initFinishedWithOrientation:(KIPageViewOrientation)orientation {
    [self setTotalPages:0];
    [self setPageViewOrientation:orientation];
    [self setCurrentPageIndex:-1];
    [self setInfinite:YES];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setClipsToBounds:YES];
}

#pragma mark **************************************************
#pragma mark 【KIPageViewDelegate】
#pragma mark **************************************************
- (NSInteger)numberOfPages {
    if (self.totalPages <= 0 && self.delegate != nil && [self.delegate respondsToSelector:@selector(numberOfPagesInPageView:)]) {
        self.totalPages = [self.delegate numberOfPagesInPageView:self];
    }
    return self.totalPages;
}

- (KIPageViewItem *)itemAtIndex:(NSInteger)index {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:itemAtIndex:)]) {
        return [self.delegate pageView:self itemAtIndex:[self indexWithInfiniteIndex:index]];
    }
    return nil;
}

- (void)willDisplayItem:(KIPageViewItem *)item atIndex:(NSInteger)index {
    if (self.pagingEnabled) {
        return ;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:willDisplayItem:atIndex:)]) {
        [self.delegate pageView:self willDisplayItem:item atIndex:[self indexWithInfiniteIndex:index]];
    }
}

- (void)didEndDisplayingItem:(KIPageViewItem *)item atIndex:(NSInteger)index {
    if (self.pagingEnabled) {
        return ;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:didEndDisplayingItem:atIndex:)]) {
        [self.delegate pageView:self didEndDisplayingItem:item atIndex:[self indexWithInfiniteIndex:index]];
    }
}

- (CGFloat)widthForItemAtIndex:(NSInteger)index {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:widthForItemAtIndex:)]) {
        return [self.delegate pageView:self widthForItemAtIndex:index];
    }
    return 0;
}

- (CGFloat)heightForItemAtIndex:(NSInteger)index {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:heightForItemAtIndex:)]) {
        return [self.delegate pageView:self heightForItemAtIndex:index];
    }
    return 0;
}

- (void)didDisplayPage:(NSInteger)index {
    if (!self.pagingEnabled) {
        return ;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:didDisplayPage:)]) {
        [self.delegate pageView:self didDisplayPage:[self indexWithInfiniteIndex:index]];
    }
}

- (void)didEndDisplayingPage:(NSInteger)index {
    if (!self.pagingEnabled) {
        return ;
    }
    if (index == 0 || index == [self numberWithInfinitItems]-1) {
        return ;
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:didEndDisplayingPage:)]) {
        [self.delegate pageView:self didEndDisplayingPage:[self indexWithInfiniteIndex:index]];
    }
}

- (void)didSelectedItem:(KIPageViewItem *)item {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:didSelectedItem:atIndex:)]) {
        [self.delegate pageView:self didSelectedItem:item atIndex:[self indexWithInfiniteIndex:[item _pageViewItemIndex]]];
    }
}

//- (void)didDeselectedItem:(KIPageViewItem *)item {
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pageView:didDeselectedItem:)]) {
//        [self.delegate pageView:self didDeselectedItem:item];
//    }
//}

- (void)updateRectForItems {
    [self.rectForItems removeAllObjects];
    
    CGFloat x = 0, y = 0;
    CGFloat width = [self width], height = [self height];
    
    for (int i=0; i<[self numberWithInfinitItems]; i++) {
        CGRect rect;
        if (self.pageViewOrientation == KIPageViewVertical) {
            if ([self infinitable] || self.pagingEnabled) {
                y = ([self height] + self.itemMargin) * i;
                rect = CGRectMake(x, y, width, height);
            } else {
                height = [self heightForItemAtIndex:i];
                rect = CGRectMake(x, y, width, height);
                y += height;
            }
        } else {
            if ([self infinitable] || self.pagingEnabled) {
                x = ([self width] + self.itemMargin) * i;
                rect = CGRectMake(x, y, width, height);
            } else {
                width = [self widthForItemAtIndex:i];
                rect = CGRectMake(x, y, width, height);
                x += width;
            }
        }
        [self.rectForItems addObject:NSStringFromCGRect(rect)];
    }
}

- (void)updateContentSize {
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (self.pageViewOrientation == KIPageViewVertical) {
        width = [self width];
    } else {
        height = [self height];
    }
    
    if ([self infinitable] || self.pagingEnabled) {
        width = [self width];
        height = [self height];
        
        if (self.pageViewOrientation == KIPageViewVertical) {
            height += [self itemMargin];
            height *= [self numberWithInfinitItems];
        } else {
            width += [ self itemMargin];
            width *= [self numberWithInfinitItems];
        }
    } else {
        for (int i=0; i<[self numberWithInfinitItems]; i++) {
            if (self.pageViewOrientation == KIPageViewVertical) {
                height += CGRectFromString([self.rectForItems objectAtIndex:i]).size.height;
            } else {
                width += CGRectFromString([self.rectForItems objectAtIndex:i]).size.width;
            }
        }
        
        if (![self infinitable]) {
            [self.scrollView setAlwaysBounceHorizontal:self.pageViewOrientation==KIPageViewHorizontal];
            [self.scrollView setAlwaysBounceVertical:self.pageViewOrientation==KIPageViewVertical];
        }
    }
    [self.scrollView setContentSize:CGSizeMake(width, height)];
}

- (CGRect)rectForPageViewItemAtIndex:(NSInteger)index {
    if ([self indexOutOfBounds:index]) {
        return CGRectZero;
    }
    CGRect rect = CGRectFromString([self.rectForItems objectAtIndex:index]);
    return rect;
//    CGFloat x = 0, y = 0;
//    if (self.pageViewOrientation == KIPageViewVertical) {
//        y = ([self height] + self.itemMargin) * index;
//    } else {
//        x = ([self width] + self.itemMargin) * index;
//    }
//    CGRect rect = CGRectMake(x, y, [self width], [self height]);
//    return rect;
}

- (NSInteger)indexOfPageViewItem:(KIPageViewItem *)item {
    if (item == nil || ![item isKindOfClass:[KIPageViewItem class]]) {
        return -1;
    }
    
    return [self indexWithInfiniteIndex:[item _pageViewItemIndex]];
}

/*
 获取指定index的KIPageViewItem
 */
- (KIPageViewItem *)pageViewItemAtIndex:(NSInteger)index {
    if ([self indexOutOfBounds:index]) {
        return nil;
    }
    return [self itemAtIndex:index];
}

- (NSInteger)numberWithInfinitItems {
    NSInteger count = [self numberOfPages];
    if ([self infinitable] && count > 1) {
        return count + 2;
    }
    return count;
}

- (BOOL)infinitable{
    if (self.scrollView.pagingEnabled && self.infinite) {
        return YES;
    }
    return NO;
}

#pragma mark **************************************************
#pragma mark 【将无限循环的index修正为常规的index】
#pragma mark **************************************************
- (NSInteger)indexWithInfiniteIndex:(NSInteger)index {
    if ([self infinitable] && [self numberWithInfinitItems] > 1) {
        if (index == [self numberWithInfinitItems] - 1) {
            index = 1;
        } else if (index == [self numberWithInfinitItems] - 2) {
            index = 0;
        }
    }
    return index;
}

#pragma mark **************************************************
#pragma mark 【检测Index是否越界】
#pragma mark **************************************************
- (BOOL)indexOutOfBounds:(NSInteger)index {
    if (index < 0 || index >= [self numberWithInfinitItems]) {
        return YES;
    }
    return NO;
}

#pragma mark **************************************************
#pragma mark 【获取可以重用的Item】
#pragma mark **************************************************
- (KIPageViewItem *)dequeueReusableItemWithIdentifier:(NSString *)identifier {
    return [[self recycledItemsWithIdentifier:identifier] anyObject];
}

- (NSMutableDictionary *)reusableItemsWithIdentifier:(NSString *)identifier {
    NSMutableDictionary *reusableItems = [[self reusableItems] objectForKey:identifier];
    if (reusableItems == nil) {
        reusableItems = [[NSMutableDictionary alloc] init];
        [[self reusableItems] setObject:reusableItems forKey:identifier];
    }
    return reusableItems;
}

- (NSMutableSet *)recycledItemsWithIdentifier:(NSString *)identifier {
    NSMutableSet *recycledItems = [[self reusableItemsWithIdentifier:identifier] objectForKey:@"recycledItems"];
    if (recycledItems == nil) {
        recycledItems = [[NSMutableSet alloc] init];
        [[self reusableItemsWithIdentifier:identifier] setObject:recycledItems forKey:@"recycledItems"];
    }
    return recycledItems;
}

#pragma mark **************************************************
#pragma mark 【跳转到指定index】
#pragma mark **************************************************
- (void)scrollToPageViewItemAtIndex:(NSInteger)index {
    [self scrollToPageViewItemAtIndex:index animated:NO];
}

- (void)scrollToPageViewItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    if ([self indexOutOfBounds:index]) {
        return ;
    }
    
    if (index == 0) {
        [self updateDidDisplayPageIndex:self.scrollView];
    } else {
        CGRect rect = [self rectForPageViewItemAtIndex:index];
//        CGPoint offset = rect.origin;
//        if ([self infinitable]) {
//            CGFloat x = MAX(rect.origin.x, self.scrollView.contentSize.width-[self width]-rect.size.width);
//            CGFloat y = MAX(rect.origin.y, self.scrollView.contentSize.height-[self height]-rect.size.height);
//            CGPointMake(x, y);
//        }
//        [self.scrollView setContentOffset:offset animated:animated];
        [self.scrollView scrollRectToVisible:rect animated:animated];
    }
}

- (void)scrollToPageAtIndex:(NSInteger)pageIndex {
    [self scrollToPageViewItemAtIndex:pageIndex animated:YES];
}

- (void)scrollToNextPage {
    if ([self infinitable]) {
        NSInteger index = self.currentPageIndex;
        if (index == 0) {
            index = [self numberWithInfinitItems] - 2;
        }
        [self scrollToPageViewItemAtIndex:++index animated:YES];
    }
}

- (void)scrollToPreviousPage {
    if ([self infinitable]) {
        NSInteger index = self.currentPageIndex;
        if (index == 0) {
            index = [self numberWithInfinitItems] - 2;
        }
        [self scrollToPageViewItemAtIndex:--index animated:YES];
    }
}

#pragma mark **************************************************
#pragma mark 【自动翻页】
#pragma mark **************************************************
- (void)flipOverWithTime:(NSUInteger)time {
    [self setTimeInterval:time];
    
    [self invalidTimer];
    
    if (self.timeInterval == 0) {
        return ;
    }
    
    if (![self infinitable]) {
        return ;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval
                                                  target:self
                                                selector:@selector(scrollToNextPage)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidTimer {
    if (self.timer != nil) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

#pragma mark **************************************************
#pragma mark 【重新加载数据】
#pragma mark **************************************************
- (void)reloadData {
    [self.scrollView setContentOffset:CGPointZero animated:NO];
    
    [self setTotalPages:0];
    
    [self updateRectForItems];
    
    [self updateContentSize];
    [self updatePageViewItems];

    [self scrollToPageViewItemAtIndex:0];
//    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
//    [self updateDisplayingPageIndex:self.scrollView];
}

- (void)reloadDataAndScrollToIndex:(NSInteger)index {
    [self setTotalPages:0];
    
    if ([self indexOutOfBounds:index]) {
        index = 0;
    }
    
    [self updateRectForItems];
    
    [self updateContentSize];
    [self updatePageViewItems];
    
    [self reloadVisibleItems];
    
    [self scrollToPageViewItemAtIndex:index];
}

- (void)updatePageViewItems {
    CGPoint offset = self.scrollView.contentOffset;
    
    if (offset.x < 0 || offset.y < 0) {
        return ;
    }
    
    NSUInteger firstNeededPageIndex = 0;
    NSUInteger lastNeededPageIndex = 0;
    if (self.scrollView.pagingEnabled) {
        CGRect visibleBounds = self.scrollView.bounds;
        if (CGRectIsEmpty(visibleBounds)) {
            return ;
        }
        
        if (self.pageViewOrientation == KIPageViewVertical) {
            firstNeededPageIndex = floorf(CGRectGetMinY(visibleBounds) / CGRectGetHeight(visibleBounds));
            lastNeededPageIndex  = floorf((CGRectGetMaxY(visibleBounds)-1) / CGRectGetHeight(visibleBounds));
        } else {
            firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
            lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
        }
        
        firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
        lastNeededPageIndex  = MIN(lastNeededPageIndex, [self numberWithInfinitItems] - 1);
    } else {
        //第一项的index
        firstNeededPageIndex = 0;
        
        for (int i=0; i<[self numberWithInfinitItems]; i++) {
            CGRect rect = CGRectFromString([self.rectForItems objectAtIndex:i]);
            
            if (self.pageViewOrientation == KIPageViewVertical) {
                if (rect.origin.y <= offset.y && rect.origin.y+rect.size.height > offset.y) {
                    firstNeededPageIndex = i;
                    break;
                }
            } else {
                if (rect.origin.x <= offset.x && rect.origin.x+rect.size.width > offset.x) {
                    firstNeededPageIndex = i;
                    break;
                }
            }
        }
        
        //最后一项的index
        lastNeededPageIndex  = firstNeededPageIndex;
        CGFloat width = 0, height = 0;
        for (int i=(int)firstNeededPageIndex; i<[self numberWithInfinitItems]; i++) {
            CGRect rect = CGRectFromString([self.rectForItems objectAtIndex:i]);
            width += rect.size.width;
            height += rect.size.height;
            lastNeededPageIndex ++;
            
            if (self.pageViewOrientation == KIPageViewVertical) {
                if (height >= self.bounds.size.height) {
                    break;
                }
            } else {
                if (width >= self.bounds.size.width) {
                    break;
                }
            }
        }
        
        firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
        lastNeededPageIndex  = MIN(lastNeededPageIndex, [self numberWithInfinitItems]-1);
    }
    
    [self setCurrentPageIndex:firstNeededPageIndex];
    
    [self recycleItemsWithoutIndex:firstNeededPageIndex toIndex:lastNeededPageIndex];
    [self reloadItemAtIndex:firstNeededPageIndex toIndex:lastNeededPageIndex];
}

- (void)recycleItemsWithoutIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    for (KIPageViewItem *item in self.visibleItems) {
        NSInteger index = [item _pageViewItemIndex];
        if (index < fromIndex || index > toIndex) {
            NSMutableSet *recycledItems = [self recycledItemsWithIdentifier:item.reuseIdentifier];
            [recycledItems addObject:item];
            
            [item removeObserver:self forKeyPath:@"selected"];
            [self.recycledItems addObject:item];
            [item removeFromSuperview];
            
            if (self.pagingEnabled) {
                [self didEndDisplayingPage:index];
            } else {
                [self didEndDisplayingItem:item atIndex:index];
            }
        }
    }
    [self.visibleItems minusSet:self.recycledItems];
}

- (void)reloadItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    for (NSInteger index = fromIndex; index <= toIndex; index++) {
        if (![self isDisplayingItemAtIndex:index]) {
            KIPageViewItem *pageViewItem = [self itemAtIndex:index];
            if (pageViewItem != nil) {
                [self willDisplayItem:pageViewItem atIndex:index];
                
                [pageViewItem _setPageViewItemIndex:index];
                [pageViewItem setFrame:[self rectForPageViewItemAtIndex:index]];
                
                [pageViewItem addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
                
                [self.scrollView addSubview:pageViewItem];
                
                [self.visibleItems addObject:pageViewItem];
                [self.recycledItems removeObject:pageViewItem];
                
                [[self recycledItemsWithIdentifier:pageViewItem.reuseIdentifier] removeObject:pageViewItem];
            }
        }
    }
}

- (void)reloadVisibleItems {
    for (KIPageViewItem *item in self.visibleItems) {
        NSInteger index = [item _pageViewItemIndex];
        [item setFrame:[self rectForPageViewItemAtIndex:index]];
    }
}

- (BOOL)isDisplayingItemAtIndex:(NSInteger)index {
    BOOL foundItem = NO;
    for (KIPageViewItem *item in self.visibleItems) {
        if ([item _pageViewItemIndex] == index) {
            foundItem = YES;
            break;
        }
    }
    return foundItem;
}

- (void)updateDidDisplayPageIndex:(UIScrollView *)scrollView {
    if (!self.pagingEnabled) {
        return ;
    }
    
    NSInteger index = 0;
    if (self.pageViewOrientation == KIPageViewVertical) {
        index = scrollView.contentOffset.y / CGRectGetHeight(scrollView.frame);
    } else {
        index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    }
    
    if ([self infinitable]) {
        if (index == 0) {
            index = [self numberWithInfinitItems] - 2;
            [self.scrollView setContentOffset:[self rectForPageViewItemAtIndex:index].origin animated:NO];
        } else if (index == [self numberWithInfinitItems] - 1) {
            index = 1;
            [self.scrollView setContentOffset:[self rectForPageViewItemAtIndex:index].origin animated:NO];
        }
    }
    
    
//    if (self.currentPageIndex != index) {
//        [self setCurrentPageIndex:index];
    if (index >= 0) {
        [self didDisplayPage:index];
    }
    
//    }
}

#pragma mark - Getters and setters
- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setDelaysContentTouches:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableSet *)visibleItems {
    if (_visibleItems == nil) {
        _visibleItems = [[NSMutableSet alloc] init];
    }
    return _visibleItems;
}

- (NSMutableSet *)recycledItems {
    if (_recycledItems == nil) {
        _recycledItems = [[NSMutableSet alloc] init];
    }
    return _recycledItems;
}

- (NSMutableDictionary *)reusableItems {
    if (_reusableItems == nil) {
        _reusableItems = [[NSMutableDictionary alloc] init];
    }
    return _reusableItems;
}

- (NSMutableArray *)rectForItems {
    if (_rectForItems == nil) {
        _rectForItems = [[NSMutableArray alloc] init];
    }
    return _rectForItems;
}

- (void)setDelegate:(id<KIPageViewDelegate>)delegate {
    if (_delegate == delegate) {
        return;
    }
    
    _delegate = delegate;
    [self invalidTimer];
}

- (void)setInfinite:(BOOL)infinite {
    if (_infinite == infinite) {
        return ;
    }
    
    _infinite = infinite;
    if (_infinite) {
        [self.scrollView setPagingEnabled:YES];
    }
    
    [self setNeedsLayout];
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    if (self.scrollView.pagingEnabled == pagingEnabled) {
        return ;
    }
    
    [self.scrollView setPagingEnabled:pagingEnabled];
    
    [self setNeedsLayout];
}

- (BOOL)pagingEnabled {
    return self.scrollView.pagingEnabled;
}

- (void)setItemMargin:(NSInteger)itemMargin {
    if (_itemMargin == itemMargin) {
        return ;
    }
    
    _itemMargin = itemMargin;
    
    [self setNeedsLayout];
}

- (BOOL)bounces {
    return self.scrollView.bounces;
}

- (void)setBounces:(BOOL)bounces {
    [self.scrollView setBounces:bounces];
}

@end
