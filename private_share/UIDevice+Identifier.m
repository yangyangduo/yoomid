//
//  UIDevice+Identifier.m
//  private_share
//
//  Created by Zhao yang on 6/24/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UIDevice+Identifier.h"
#import <AdSupport/AdSupport.h>

@implementation UIDevice (Identifier)

+ (NSString *)idfaString {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
}

@end
