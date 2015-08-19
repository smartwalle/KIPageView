//
//  KIPageViewImageItem.m
//  KIPageView
//
//  Created by SmartWalle on 15/8/16.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "KIPageViewImageItem.h"

@interface KIPageViewImageItem () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIImageView   *imageView;

@property (nonatomic, strong) UITapGestureRecognizer *zoomTapGestureRecongnizer;
@end

@implementation KIPageViewImageItem

#pragma mark - Lifecycle
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.scrollView setFrame:self.bounds];
    [self.imageView setFrame:self.bounds];
    
    [self.scrollView setZoomScale:1.0 animated:NO];
}

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self.scrollView setZoomScale:1.0 animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - UIGestureRecognizerDelegate


#pragma mrak - Event response
- (void)zoomTapGestureRecongnizerHandler:(UITapGestureRecognizer *)sender {
    CGFloat zoom = (self.scrollView.zoomScale > 1.0 ? self.scrollView.minimumZoomScale : self.scrollView.maximumZoomScale);
    [self.scrollView setZoomScale:zoom animated:YES];
}

#pragma mark - Getters and setters

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setBouncesZoom:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setMinimumZoomScale:1.0];
        [_scrollView setMaximumZoomScale:3.0];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView addGestureRecognizer:self.zoomTapGestureRecongnizer];
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

- (UITapGestureRecognizer *)zoomTapGestureRecongnizer {
    if (_zoomTapGestureRecongnizer == nil) {
        _zoomTapGestureRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(zoomTapGestureRecongnizerHandler:)];
        [_zoomTapGestureRecongnizer setNumberOfTapsRequired:2];
        [_zoomTapGestureRecongnizer setNumberOfTouchesRequired:1];
    }
    return _zoomTapGestureRecongnizer;
}

- (void)setZoomable:(BOOL)zoomable {
    [self.scrollView setMinimumZoomScale:1.0];
    [self.scrollView setMaximumZoomScale:(zoomable?3.0:1.0)];
}

- (BOOL)zoomable {
    return (self.scrollView.maximumZoomScale > self.scrollView.minimumZoomScale);
}

@end
