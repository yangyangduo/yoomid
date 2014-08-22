//
//  QRCode.m
//  private_share
//
//  Created by Zhao yang on 6/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "QRCode.h"

@implementation QRCode

@synthesize codeType;
@synthesize codeContent;

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [super toDictionary];
    return dictionary;
}

@end
