//
//  AdPlatformPickerView.h
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ModalView.h"
#import "SubTaskCategoryView.h"
#import "CategoryButtonItem.h"

@interface AdPlatformPickerView : SubTaskCategoryView<CategoryButtonItemDelegate>

@property (nonatomic, weak) id<CategoryButtonItemDelegate> delegate;

@end
