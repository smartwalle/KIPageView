//
//  KIPageViewImageItem.h
//  KIPageView
//
//  Created by SmartWalle on 15/8/16.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "KIPageViewItem.h"

@interface KIPageViewImageItem : KIPageViewItem

@property (nonatomic, assign) BOOL zoomable;

- (UIImageView *)imageView;

@end
