//
//  MerchandiseDetailViewController.h
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchandise.h"
#import "NumberPicker.h"
#import "Constants.h"

@interface MerchandiseDetailViewController : UIViewController<NumberPickerDelegate>

- (instancetype)initWithMerchandise:(Merchandise *)merchandise;

@end
