//
//  TaskCategory.h
//  private_share
//
//  Created by Zhao yang on 9/1/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

typedef NS_ENUM(NSUInteger, TaskCategoryType) {
    TaskCategoryTypeUnknow,
    TaskCategoryTypeProductExperience,
    TaskCategoryTypeGuessPicture,
    TaskCategoryTypeSurvey,
    TaskCategoryTypeGame,
    TaskCategoryTypeSocialSharing
};

@interface TaskCategory : BaseModel

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *parentCategory;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, assign) NSInteger requiredUserLevel;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) BOOL hasParent;
@property (nonatomic, assign) BOOL isLocked;

@property (nonatomic, assign) TaskCategoryType taskCategoryType;

- (NSString *)iconName;
+ (NSString *)taskNameWithCategoryId:(NSString *)categoryId;

@end
