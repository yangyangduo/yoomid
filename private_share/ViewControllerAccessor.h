//
//  ViewControllerAccessor.h
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawerViewController.h"

@interface ViewControllerAccessor : NSObject

@property (nonatomic, strong) DrawerViewController *drawerViewController;

+ (instancetype)defaultAccessor;

@end
