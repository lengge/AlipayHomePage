//
//  HomeToolBar.h
//  AlipayHomePage
//
//  Created by wex on 2018/2/8.
//  Copyright © 2018年 LXAPP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeToolBarButton : UIButton

+ (instancetype)buttonWithImage:(UIImage *)image title:(NSString *)title;

@end

@interface HomeToolBarItem: NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;

+ (instancetype)itemWithImage:(UIImage *)image title:(NSString *)title;

@end

@interface HomeToolBar : UIView

- (instancetype)initWithToolBarItems:(NSArray *)items;

@end
