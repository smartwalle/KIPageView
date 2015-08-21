//
//  KIPageViewCell.m
//  KIPageView
//
//  Created by SmartWalle on 15/8/14.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "KIPageViewCell.h"

@interface KIPageViewCell () {
    @private
    NSInteger _cellIndex;
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
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setHighlighted:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self updateSelectedStatus:YES];
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
        [self setSelected:select animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setPageViewCellSelected:selected];
    
    [UIView animateKeyframesWithDuration:animated?0.3:0
                                   delay:0
                                 options:0
                              animations:^{
                                  [self.backgroundView setAlpha:self.pageViewCellSelected?0:1];
                                  [self.selectedBackgroundView setAlpha:self.pageViewCellSelected?1:0];
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

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (BOOL)selected {
    return self.pageViewCellSelected;
}

@end
