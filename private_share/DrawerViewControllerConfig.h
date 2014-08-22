//
//  DrawerViewControllerConfig.h
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawerViewControllerConfig : NSObject

@property(nonatomic) CGFloat triggerShowDrawerViewMinWidth;
@property(nonatomic) CGFloat leftDrawerViewVisibleWidth;
@property(nonatomic) CGFloat triggerHideLeftDrawerViewX;
@property(nonatomic) CGFloat rightDrawerViewVisibleWidth;
@property(nonatomic) CGFloat triggerHideRightDrawerViewX;

+ (DrawerViewControllerConfig *)defaultConfig;

@end
