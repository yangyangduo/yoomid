//
//  AllShopInfo.m
//  private_share
//
//  Created by 曹大为 on 14/11/6.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "AllShopInfo.h"

@implementation AllShopInfo
{
    NSMutableArray *_allShopInfo_;
}

+ (instancetype)allShopInfo
{
    static dispatch_once_t onceToken;
    static AllShopInfo *_allShopInfo;
    dispatch_once(&onceToken, ^{
        _allShopInfo = [[AllShopInfo alloc] init];
    });
    return _allShopInfo;
}

- (NSMutableArray*)getAllShopInfo
{
    return _allShopInfo_;
}

- (void)setAllShopInfo:(NSMutableArray *)info
{
    if (_allShopInfo_ == nil) {
        _allShopInfo_ = [[NSMutableArray alloc] initWithArray:info];
    }
}

@end
