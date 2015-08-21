//
//  KIPageViewCell.h
//  KIPageView
//
//  Created by SmartWalle on 15/8/14.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIPageViewCell : UIView

@property (nonatomic, copy) NSString    *reuseIdentifier;

@property (nonatomic, assign) BOOL      highlighted;
@property (nonatomic, assign) BOOL      selected;

@property (nonatomic, strong) UIView    *contentView;
@property (nonatomic, strong) UIView    *backgroundView;
@property (nonatomic, strong) UIView    *selectedBackgroundView;

- (instancetype)initWithIdentifier:(NSString *)identifier;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
