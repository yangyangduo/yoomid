//
//  Contact.h
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

@interface Contact : BaseModel

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL isDefault;

- (BOOL)isEmpty;

@end
