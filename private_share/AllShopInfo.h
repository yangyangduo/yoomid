//
//  AllShopInfo.h
//  private_share
//
//  Created by 曹大为 on 14/11/6.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllShopInfo : NSObject
+ (instancetype)allShopInfo;

- (NSMutableArray *)getAllShopInfo;
- (void)setAllShopInfo:(NSMutableArray*)info;
@end
