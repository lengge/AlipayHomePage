//
//  HomeGridView.m
//  AlipayHomePage
//
//  Created by wex on 2018/2/8.
//  Copyright © 2018年 LXAPP. All rights reserved.
//

#import "HomeGridView.h"

@implementation HomeGridItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat imageW = 29;
    CGFloat imageH = 29;
    CGFloat imageX = (self.frame.size.width - imageW) / 2;
    self.imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
    
    CGFloat titleY = imageH + 5;
    self.titleLabel.frame = CGRectMake(0, titleY, self.frame.size.width, 15.0f);
}

+ (instancetype)itemViewWithImage:(UIImage *)image title:(NSString *)title {
    HomeGridItemView *button = [[HomeGridItemView alloc] initWithFrame:CGRectZero];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}

@end

@implementation HomeGridItem

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title {
    HomeGridItem *item = [[HomeGridItem alloc] init];
    item.image = image;
    item.title = title;
    return item;
}

@end

@interface HomeGridView ()

@property (nonatomic, strong) NSMutableArray *itemViews;

@end

@implementation HomeGridView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _itemViews = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.frame.size.width / 4;
    CGFloat h = 54;
    CGFloat spaceY = (self.frame.size.height - 3 * h) / 6;
    [_itemViews enumerateObjectsUsingBlock:^(HomeGridItemView *itemView, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx > 11) {
            *stop = YES;
        }
        
        NSInteger row = idx / 4;
        NSInteger col = idx % 4;
        itemView.frame = CGRectMake(col * w, spaceY + (h + spaceY * 2) * row, w, h);
    }];
}

- (void)setItems:(NSArray *)items {
    _items = items;
    
    [_itemViews enumerateObjectsUsingBlock:^(HomeGridItemView *itemView, NSUInteger idx, BOOL * _Nonnull stop) {
        [itemView removeFromSuperview];
    }];
    
    [items enumerateObjectsUsingBlock:^(HomeGridItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeGridItemView *itemView = [HomeGridItemView itemViewWithImage:item.image title:item.title];
        [self addSubview:itemView];
        [_itemViews addObject:itemView];
    }];
}

@end
