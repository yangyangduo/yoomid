//
//  CategoryButtonItem.h
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryButtonItemDelegate;

@interface CategoryButtonItem : UIView

@property (nonatomic, weak) id<CategoryButtonItemDelegate> delegate;

- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title imageName:(NSString *)imageName;

@end

@protocol CategoryButtonItemDelegate <NSObject>

- (void)categoryButtonItemDidSelectedWithIdentifier:(NSString *)identifier;

@end
