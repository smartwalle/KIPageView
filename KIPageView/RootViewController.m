//
//  RootViewController.m
//  KIPageView
//
//  Created by SmartWalle on 15/8/19.
//  Copyright (c) 2015年 SmartWalle. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.dataSource addObject:@"PageViewController"];
    [self.dataSource addObject:@"HorizontalListViewController"];
    [self.dataSource addObject:@"VerticalListViewController"];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    
    [cell.textLabel setText:self.dataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.dataSource[indexPath.row];
    Class cls = NSClassFromString(className);
    if (cls != NULL) {
        id obj = [[cls alloc] init];
        if ([obj isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:(UIViewController *)obj animated:YES];
        }
    }
}

#pragma mark - Getters and setters
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
