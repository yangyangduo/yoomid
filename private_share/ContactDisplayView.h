//
//  ContactDisplayView.h
//  private_share
//
//  Created by Zhao yang on 8/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

extern CGFloat const kContactDisplayViewHeight;

@interface ContactDisplayView : UIView

@property (nonatomic, strong) Contact *currentContact;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *phoneNumber;
@property (nonatomic, strong) UILabel *address;

- (instancetype)initWithFrame:(CGRect)frame contact:(Contact *)contact;
//- (void)setCurrentContact:(Contact *)currentContact;
@end
