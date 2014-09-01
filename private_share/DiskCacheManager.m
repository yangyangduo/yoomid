//
//  DiskCacheManager.m
//  private_share
//
//  Created by Zhao yang on 6/19/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DiskCacheManager.h"

NSString * const YOOMID_DIRECTORY_NAME = @"yoomid-data";

NSString * const kFileNameActivities = @"activities";
NSString * const kFileNameMerchandises = @"merchandises";
NSString * const kFileNameTaskCategories = @"task-categories";

NSString * const kFileNameProfile = @"profile";
NSString * const kFileNamePointsOrder = @"points-order";

@implementation DiskCacheManager {
    NSMutableArray *_activities_;
    NSMutableArray *_merchandises_;
    NSMutableArray *_task_categories_;
    
    NSString *_serve_account_;
    Profile *_profile_;
    NSMutableArray *_points_orders_;
}

+ (DiskCacheManager *)manager {
    static DiskCacheManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DiskCacheManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if(self) {
        _activities_ = [NSMutableArray array];
        _merchandises_ = [NSMutableArray array];
        _task_categories_ = [NSMutableArray array];
        
        _points_orders_ = [NSMutableArray array];
        
        [self initializeDirectoryWithPath:[DiskCacheManager YoomidDirectoryPath]];
    }
    return self;
}

- (void)serveForAccount:(NSString *)account {
    _serve_account_ = account;
    
    _profile_ = nil;
    [_points_orders_ removeAllObjects];
    
    if(_serve_account_ != nil) {
        NSString *userDirectory = [[self class] YoomidUserDirectoryPathWithAccountId:_serve_account_];
        if(userDirectory != nil) {
            [self initializeDirectoryWithPath:userDirectory];
        }
    }
}

#pragma mark -
#pragma mark get and read

+ (NSArray *)activities:(BOOL)isExpired {
    return nil;
}

+ (NSArray *)merchandises:(BOOL)isExpired {
    return nil;
}

+ (NSArray *)taskCategories:(BOOL)isExpired {
    return nil;
}

- (Profile *)profile:(BOOL)isExpired {
    
    return nil;
}

- (NSArray *)pointsOrdersWithPointsOrderType:(PointsOrderType)pointsOrderType isExpired:(BOOL *)isExpired {
    return nil;
}

#pragma mark -
#pragma mark set and save

- (void)setActivities:(NSArray *)activities {
    
}

- (void)setMerchandises:(NSArray *)merchandises {
    
}

- (void)setTaskCategories:(NSArray *)taskCategories {
    
}

- (void)setProfile:(Profile *)profile {
    
}

- (void)setPointsOrders:(NSArray *)pointsOrders pointsOrderType:(PointsOrderType)pointsOrderType {
    
}

#pragma mark -
#pragma mark Directory and file manager

- (void)initializeDirectoryWithPath:(NSString *)directoryPath {
    if(directoryPath == nil || [@"" isEqualToString:directoryPath]) return;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:directoryPath]) {
        NSError *error;
        BOOL createDirectorySuccess = [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
#ifdef DEBUG
        if(!createDirectorySuccess || error != nil) {
            NSLog(@"[Disk Cache Manager] Create directory [%@] failure", directoryPath);
        } else {
            NSLog(@"[Disk Cache Manager] Create directory [%@] success", directoryPath);
        }
#endif
    } else {
#ifdef DEBUG
        NSLog(@"[Disk Cache Manager] Directory [%@] already exists", directoryPath);
#endif
    }
}

- (void)saveData:(NSData *)data withFileName:(NSString *)fileName inUserDirectory:(BOOL)inUserDirectory  {
    if(data == nil || data.length == 0) return;
    NSString *filePath;
    if(inUserDirectory) {
        if(_serve_account_ == nil) return;
        
        // get user directory
        NSString *directory = [[self class] YoomidUserDirectoryPathWithAccountId:_serve_account_];
        if(directory == nil) return;
        
        filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", fileName]];
    } else {
        filePath = [[self class] YoomidDirectoryPath];
    }
    
    if([data writeToFile:filePath atomically:YES]) {
        // success
    } else {
        // failed
    }
}

- (NSData *)loadDataWithFileName:(NSString *)fileName inUserDirectory:(BOOL)inUserDirectory {
    
    return nil;
}

+ (NSString *)YoomidDirectoryPath {
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:YOOMID_DIRECTORY_NAME];
}

+ (NSString *)YoomidUserDirectoryPathWithAccountId:(NSString *)accountId {
    if(accountId == nil || [@"" isEqualToString:accountId]) return nil;
    return [[[self class] YoomidDirectoryPath] stringByAppendingPathComponent:accountId];
}

@end