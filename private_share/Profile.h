//
//  Profile.h
//  private_share
//
//  Created by Zhao yang on 8/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"

@interface Profile : NSObject

@property (nonatomic, assign) NSInteger points;
@property (nonatomic, strong) Contact *defaultContact;

@end
