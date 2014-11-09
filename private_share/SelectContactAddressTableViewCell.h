//
//  SelectContactAddressTableViewCell.h
//  private_share
//
//  Created by 曹大为 on 14-8-13.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "Consignee.h"

@interface SelectContactAddressTableViewCell : UITableViewCell

@property (nonatomic,strong)Contact *contact;
@property (nonatomic,strong)Consignee *consignee;
@property (nonatomic,strong)UIImageView *selectedImageView;
@end
