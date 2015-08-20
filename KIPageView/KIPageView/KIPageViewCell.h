//
//  KIPageViewItem.h
//  KIPageView
//
//  Created by SmartWalle on 15/8/14.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIPageViewCell : UIView

@property (nonatomic, copy) NSString *reuseIdentifier;

@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithIdentifier:(NSString *)identifier;

@end
