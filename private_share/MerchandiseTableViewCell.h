//
//  MerchandiseTableViewCell.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Merchandise.h"

static CGFloat kMerchandiseTableViewCellHeight = 133.f;

@interface MerchandiseTableViewCell : UITableViewCell

@property (nonatomic, strong) Merchandise *merchandise;

@end
