//
//  ImageItem.h
//  private_share
//
//  Created by Zhao yang on 6/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title;

@end
