//
//  BaseViewController.h
//  KIPageView
//
//  Created by SmartWalle on 15/8/19.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIPageView.h"

@interface BaseViewController : UIViewController <KIPageViewDelegate> {
    KIPageView *_pageView;
}

@property (nonatomic, strong) KIPageView        *pageView;
@property (nonatomic, strong) NSMutableArray    *dataSource;
@end
