//
//  LeftDrawerViewController.h
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DrawerViewController.h"

@interface LeftDrawerViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSString *selectedItem;
@property (nonatomic, strong) UILabel *accountLabel;

@end
