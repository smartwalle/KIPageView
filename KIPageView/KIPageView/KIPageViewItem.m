//
//  KIPageViewItem.m
//  KIPageView
//
//  Created by SmartWalle on 15/8/14.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "KIPageViewItem.h"

@interface KIPageViewItem () {
    @private
    NSInteger _itemIndex;
}
@end

@implementation KIPageViewItem

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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setSelected:YES];
}

#pragma mark - Event response

#pragma mark - Methods
- (void)_initFinished {
    [self setClipsToBounds:YES];
    [self setUserInteractionEnabled:YES];
}

#pragma makr - Getters and Settters

@end
