//
//  ColumnView.m
//  private_share
//
//  Created by 曹大为 on 14/10/31.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ColumnView.h"

@implementation ColumnView

@synthesize imgUrl;
@synthesize types;
@synthesize viewType;
@synthesize cid;
@synthesize names;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.imgUrl = [json noNilStringForKey:@"img"];
        self.types = [json numberForKey:@"type"].integerValue;
        self.viewType = [json numberForKey:@"viewType"].integerValue;
        self.cid = [json noNilStringForKey:@"cid"];
        self.names = [json noNilStringForKey:@"name"];
    }
    return self;
}

@end
