//
//  HomeToolBar.m
//  AlipayHomePage
//
//  Created by wex on 2018/2/8.
//  Copyright © 2018年 LXAPP. All rights reserved.
//

#import "HomeToolBar.h"
#import "Masonry.h"

@implementation HomeToolBarButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageW = 50;
    CGFloat imageH = 50;
    CGFloat imageX = (self.frame.size.width - imageW) / 2;
    self.imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
    
    CGFloat titleY = imageH + 15;
    self.titleLabel.frame = CGRectMake(0, titleY, self.frame.size.width, 15.0f);
}

+ (instancetype)buttonWithImage:(UIImage *)image title:(NSString *)title {
    HomeToolBarButton *button = [[HomeToolBarButton alloc] initWithFrame:CGRectZero];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}

@end

@implementation HomeToolBarItem

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title {
    HomeToolBarItem *item = [[HomeToolBarItem alloc] init];
    item.image = image;
    item.title = title;
    return item;
}

@end

@interface HomeToolBar ()

@property (nonatomic, strong) NSMutableArray *itemButtonArray;

@end

@implementation HomeToolBar

- (instancetype)initWithToolBarItems:(NSArray *)items {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:27 / 255.0 green:130 / 255.0 blue:209 / 255.0 alpha:1];
        _itemButtonArray = [NSMutableArray array];
        [self setupSubviewsWithItems:items];
    }
    return self;
}

- (void)setupSubviewsWithItems:(NSArray *)items {
    [items enumerateObjectsUsingBlock:^(HomeToolBarItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeToolBarButton *button = [HomeToolBarButton buttonWithImage:item.image title:item.title];
        [self addSubview:button];
        [self.itemButtonArray addObject:button];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width / self.itemButtonArray.count;
    CGFloat h = 80;
    [self.itemButtonArray enumerateObjectsUsingBlock:^(HomeToolBarButton *button, NSUInteger idx, BOOL * _Nonnull stop) {
        button.frame = CGRectMake(w * idx, (self.frame.size.height - 80) / 2, w, h);
    }];
}

@end
