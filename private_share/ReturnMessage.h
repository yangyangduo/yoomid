//
//  ReturnMessage.h
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

@interface ReturnMessage : BaseModel

@property (nonatomic, strong) NSString *messageKey;
@property (nonatomic, strong) NSString *message;

@end
