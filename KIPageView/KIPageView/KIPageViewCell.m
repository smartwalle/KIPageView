//
//  KIPageViewCell.m
//  KIPageView
//
//  Created by SmartWalle on 15/8/14.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "KIPageViewCell.h"

@protocol KIPageViewCellDelegate <NSObject>
@optional
- (void)pageViewCell:(KIPageViewCell *)cell updateSelectedStatus:(BOOL)selected;
@end

@interface KIPageViewCell () {
    @private
    NSInteger _cellIndex;
    UIView *_selectedBackgroundView;
    UIView *_backgroundView;
}

@property (nonatomic, assign) BOOL pageViewCellSelected;
@end

@implementation KIPageViewCell

#pragma mark - Lifecycle
- (void)dealloc {
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        [self setReuseIdentifier:identifier];
        [self _initFinished];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _initFinished];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _initFinished];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initFinished];
    }
    return self;
}

- (void)addSubview:(UIView *)view {
    [self.contentView addSubview:view];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backgroundView setFrame:self.bounds];
    [self.selectedBackgroundView setFrame:self.bounds];
    [self.contentView setFrame:self.bounds];
    [self bringSubviewToFront:self.contentView];
    [self sendSubviewToBack:self.backgroundView];
    [self insertSubview:self.selectedBackgroundView aboveSubview:self.backgroundView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setHighlighted:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setHighlighted:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self setHighlighted:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self updateSelectedStatus:YES];
    
    [self setHighlighted:NO];
}

#pragma mark - Event response

#pragma mark - Methods
- (void)_initFinished {
    [self setClipsToBounds:YES];
    [self setUserInteractionEnabled:YES];
    [self updateSelectedStatus:NO];
}

- (void)updateSelectedStatus:(BOOL)select {
    if (self.pageViewCellSelected != select) {
        [self setPageViewCellSelected:select];
        [self updateViewWithAnimated:YES touch:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setPageViewCellSelected:selected];
    [self updateViewWithAnimated:animated touch:NO];
}

- (void)updateViewWithAnimated:(BOOL)animated touch:(BOOL)touch {
    BOOL h = (_highlighted || _pageViewCellSelected);
    
    if (touch && self.pageViewCellSelected) {
        animated = NO;
    }
    
    [UIView animateKeyframesWithDuration:animated?0.3:0
                                   delay:0
                                 options:0
                              animations:^{
                                  [self.backgroundView setAlpha:h?0:1];
                                  [self.selectedBackgroundView setAlpha:h?1:0];
                              } completion:^(BOOL finished) {
                                  
                              }];
}

#pragma makr - Getters and Settters
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [super addSubview:_contentView];
    }
    return _contentView;
}

- (UIView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        [_backgroundView setBackgroundColor:[UIColor whiteColor]];
        [super addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (void)setBackgroundView:(UIView *)backgroundView {
    _backgroundView = backgroundView;
    [super addSubview:_backgroundView];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self.backgroundView setBackgroundColor:backgroundColor];
}

- (UIColor *)backgroundColor {
    return [self.backgroundView backgroundColor];
}

- (UIView *)selectedBackgroundView {
    if (_selectedBackgroundView == nil) {
        _selectedBackgroundView = [[UIView alloc] init];
        [_selectedBackgroundView setBackgroundColor:[UIColor lightGrayColor]];
        [super addSubview:_selectedBackgroundView];
    }
    return _selectedBackgroundView;
}

- (void)setSelectedBackgroundView:(UIView *)selectedBackgroundView {
    _selectedBackgroundView = selectedBackgroundView;
    [super addSubview:_selectedBackgroundView];
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (BOOL)selected {
    return self.pageViewCellSelected;
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    [self updateViewWithAnimated:_highlighted touch:YES];
}

- (void)setPageViewCellSelected:(BOOL)pageViewCellSelected {
    _pageViewCellSelected = pageViewCellSelected;
    if ([self.superview.superview respondsToSelector:@selector(pageViewCell:updateSelectedStatus:)]) {
        id<KIPageViewCellDelegate> delegate = (id)self.superview.superview;
        [delegate pageViewCell:self updateSelectedStatus:_pageViewCellSelected];
    }
}

@end
