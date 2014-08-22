//
//  UIParameterButton.h
//  private_share
//
//  Created by Zhao yang on 6/16/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIParameterButton : UIButton

@property (nonatomic, strong) NSString *identifier;

- (id)parameterForKey:(NSString *)key;
- (void)setParameter:(id)parameter forKey:(NSString *)key;
- (void)removeParameterForKey:(NSString *)key;

@end
