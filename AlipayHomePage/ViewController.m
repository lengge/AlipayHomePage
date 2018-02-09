//
//  ViewController.m
//  AlipayHomePage
//
//  Created by wex on 2018/2/7.
//  Copyright © 2018年 LXAPP. All rights reserved.
//

#import "ViewController.h"
#import "HomeToolBar.h"
#import "HomeGridView.h"
#import "MJRefresh.h"
#import "HomeCell.h"

#define ScreenW ([UIScreen mainScreen].bounds.size.width)
#define ScreenH ([UIScreen mainScreen].bounds.size.height)

#define HomeToolBarH    (140)
#define HomeGridViewH   (250)

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HomeToolBar *toolBar;

@property (nonatomic, strong) HomeGridView *gridView;

@property (nonatomic, assign) CGFloat laseContentOffsetY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    self.title = @"支付宝";
    
    [self p_setupSubviews];
}

#pragma mark - private
- (void)p_setupSubviews {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH - 64)];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
    _tableView.contentInset = UIEdgeInsetsMake((HomeToolBarH + HomeGridViewH), 0, 0, 0);
    _tableView.scrollIndicatorInsets = UIEdgeInsetsMake((HomeToolBarH + HomeGridViewH), 0, 0, 0);
    _tableView.estimatedRowHeight = 150;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    @weakify(self);
    [_tableView addHeaderWithCallback:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self.tableView headerEndRefreshing];
        });
    }];
    
    
    HomeToolBarItem *item1 = [HomeToolBarItem itemWithImage:[UIImage imageNamed:@"homeBarIcon0"] title:@"扫一扫"];
    HomeToolBarItem *item2 = [HomeToolBarItem itemWithImage:[UIImage imageNamed:@"homeBarIcon1"] title:@"付钱"];
    HomeToolBarItem *item3 = [HomeToolBarItem itemWithImage:[UIImage imageNamed:@"homeBarIcon2"] title:@"收钱"];
    HomeToolBarItem *item4 = [HomeToolBarItem itemWithImage:[UIImage imageNamed:@"homeBarIcon3"] title:@"卡包"];
    _toolBar = [[HomeToolBar alloc] initWithToolBarItems:@[item1, item2, item3, item4]];
    _toolBar.frame = CGRectMake(0, -(HomeGridViewH + HomeToolBarH), ScreenW, HomeToolBarH);
    [self.tableView addSubview:_toolBar];
    
    
    _gridView = [[HomeGridView alloc] initWithFrame:CGRectMake(0, -HomeGridViewH, ScreenW, HomeGridViewH)];
    [self.tableView addSubview:_gridView];
    NSArray *gridImages = @[@"i01", @"i02", @"i03", @"i04", @"i05", @"i06", @"i07", @"i08", @"i09", @"i10", @"i11"];
    NSArray *gridTitles = @[@"余额宝", @"转账", @"信用卡还贷", @"电影票", @"红包", @"亲密付", @"蚂蚁庄园", @"火车票", @"花呗", @"蚂蚁森林", @"更多"];
    NSMutableArray *items = [NSMutableArray array];
    [gridImages enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeGridItem *item = [HomeGridItem itemWithImage:[UIImage imageNamed:imageName] title:gridTitles[idx]];
        [items addObject:item];
    }];
    _gridView.items = items;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeCell *cell = [HomeCell cellWithTableView:tableView];
    
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _laseContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat tableViewOffsetY = scrollView.contentOffset.y;
    
    if (tableViewOffsetY < -(HomeGridViewH + HomeToolBarH)) {
        _toolBar.frame = CGRectMake(0, tableViewOffsetY, ScreenW, HomeToolBarH);
        _gridView.frame = CGRectMake(0, tableViewOffsetY + HomeToolBarH , ScreenW, HomeGridViewH);
    } else {
        _toolBar.frame = CGRectMake(0, -(HomeGridViewH + HomeToolBarH), ScreenW, HomeToolBarH);
        _gridView.frame = CGRectMake(0, -HomeGridViewH, ScreenW, HomeGridViewH);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat tableViewOffsetY = scrollView.contentOffset.y;
    
    if (tableViewOffsetY < -(HomeGridViewH + HomeToolBarH) || tableViewOffsetY > -HomeGridViewH) {
        return;
    }
    
    if (tableViewOffsetY > _laseContentOffsetY) {
        // 向上滑
        if (tableViewOffsetY > -(HomeGridViewH + HomeToolBarH) + 30) {
            [self.tableView setContentOffset:CGPointMake(0, -HomeGridViewH) animated:YES];
        } else {
            [self.tableView setContentOffset:CGPointMake(0, -(HomeGridViewH + HomeToolBarH)) animated:YES];
        }
    } else {
        // 向下滑
        if (tableViewOffsetY < -HomeGridViewH - 30) {
            [self.tableView setContentOffset:CGPointMake(0, -(HomeGridViewH + HomeToolBarH)) animated:YES];
        } else {
            [self.tableView setContentOffset:CGPointMake(0, -HomeGridViewH) animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat tableViewOffsetY = scrollView.contentOffset.y;
    
    if (tableViewOffsetY < -(HomeGridViewH + HomeToolBarH) || tableViewOffsetY > -HomeGridViewH) {
        return;
    }
    
    if (tableViewOffsetY > _laseContentOffsetY) {
        // 向上滑
        if (tableViewOffsetY > -(HomeGridViewH + HomeToolBarH) + 20) {
            [self.tableView setContentOffset:CGPointMake(0, -HomeGridViewH) animated:YES];
        } else {
            [self.tableView setContentOffset:CGPointMake(0, -(HomeGridViewH + HomeToolBarH)) animated:YES];
        }
    } else {
        // 向下滑
        if (tableViewOffsetY < -HomeGridViewH - 20) {
            [self.tableView setContentOffset:CGPointMake(0, -(HomeGridViewH + HomeToolBarH)) animated:YES];
        } else {
            [self.tableView setContentOffset:CGPointMake(0, -HomeGridViewH) animated:YES];
        }
    }
}


@end
