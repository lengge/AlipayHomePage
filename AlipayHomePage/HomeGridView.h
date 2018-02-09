//
//  HomeGridView.h
//  AlipayHomePage
//
//  Created by wex on 2018/2/8.
//  Copyright © 2018年 LXAPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeGridItemView : UIButton

+ (instancetype)itemViewWithImage:(UIImage *)image title:(NSString *)title;

@end

@interface HomeGridItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title;

@end

@interface HomeGridView : UIView

@property (nonatomic, strong) NSArray *items;

@end
