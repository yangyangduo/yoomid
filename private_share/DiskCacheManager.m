//
//  DiskCacheManager.m
//  private_share
//
//  Created by Zhao yang on 6/19/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DiskCacheManager.h"
#import "JsonUtil.h"

NSTimeInterval const CACHE_DATA_EXPIRED_MINUTES_INTERVAL = 5;

NSString * const YOOMID_DIRECTORY_NAME = @"yoomid-data";

NSString * const kFileNameActivities = @"activities";
NSString * const kFileNameMerchandises = @"merchandises";
NSString * const kFileNameTaskCategories = @"task-categories";

NSString * const kFileNameProfile = @"profile";
NSString * const kFileNamePointsOrder = @"points-order";

@implementation DiskCacheManager {
    NSString *_serve_account_;
    
    //
    CacheData *_activities_data_;
    CacheData *_merchandises_data_;
    CacheData *_task_categories_data_;
    
    //
    Profile *_profile_;
    CacheData *_points_orders_data_;
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
        [self initializeDirectoryWithPath:[DiskCacheManager YoomidDirectoryPath]];
    }
    return self;
}

- (void)serveForAccount:(NSString *)account {
    _serve_account_ = account;
    
    _profile_ = nil;
    _points_orders_data_ = nil;
    
    if(_serve_account_ != nil) {
        NSString *userDirectory = [[self class] YoomidUserDirectoryPathWithAccountId:_serve_account_];
        if(userDirectory != nil) {
            [self initializeDirectoryWithPath:userDirectory];
        }
    }
}

#pragma mark -
#pragma mark get and read

- (NSArray *)activities:(BOOL *)isExpired {
    
    return nil;
}

- (NSArray *)merchandises:(BOOL *)isExpired {
    return nil;
}

- (NSArray *)taskCategories:(BOOL *)isExpired {
    NSMutableArray *taskCategories = [NSMutableArray array];
    
    BOOL readDisk = NO;
    
    // read from disk first
    if(_task_categories_data_ == nil) {
        NSData *data = [self loadDataWithFileName:kFileNameTaskCategories inUserDirectory:NO];
    
        id json = [JsonUtil createDictionaryOrArrayFromJsonData:data];
        if(json != nil) {
            _task_categories_data_ = [[CacheData alloc] initWithJson:json];
#ifdef DEBUG
            NSLog(@"[Disk Cache Manager] Load task categories from disk cache");
#endif
            readDisk = YES;
        }
    }
    
    // json data convert to entity type
    if(_task_categories_data_ != nil) {
        NSArray *jsonArray = _task_categories_data_.data;
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                [taskCategories addObject:[[TaskCategory alloc] initWithJson:[jsonArray objectAtIndex:i]]];
            }
#ifdef DEBUG
            if(!readDisk) {
                NSLog(@"[Disk Cache Manager] Load task categories from memory cache");
            }
#endif
        }
    }
    
    *isExpired = _task_categories_data_ == nil ? YES : _task_categories_data_.isExpired;
    return taskCategories.count == 0 ? nil : taskCategories;
}

- (Profile *)profile:(BOOL *)isExpired {
    
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
    if(_task_categories_data_ == nil) {
        _task_categories_data_ = [[CacheData alloc] init];
    }
    
    NSMutableArray *data = [NSMutableArray array];
    if(taskCategories != nil) {
        for(int i=0; i<taskCategories.count; i++) {
            id<JsonEntity> taskCategory = [taskCategories objectAtIndex:i];
            [data addObject:[taskCategory toJson]];
        }
    }
    _task_categories_data_.data = data.count == 0 ? nil : data;
    _task_categories_data_.lastRefreshTime = [NSDate date];
    
    [self saveData:_task_categories_data_ withFileName:kFileNameTaskCategories inUserDirectory:NO];
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

- (void)saveData:(CacheData *)cacheData withFileName:(NSString *)fileName inUserDirectory:(BOOL)inUserDirectory  {
    if(cacheData == nil) return;
    
    NSData *data = [JsonUtil createJsonDataFromDictionary:[cacheData toJson]];
    if(data == nil || data.length == 0) return;
    
    NSString *filePath = [self cacheDataFilePathWithFileName:fileName inUserDirectory:inUserDirectory];
    if(filePath == nil) return;
    
    if(![data writeToFile:filePath atomically:YES]) {
#ifdef DEBUG
        NSLog(@"[Disk Cache Manager] Save file failure at path [%@]", filePath);
#endif
    }
}

- (NSData *)loadDataWithFileName:(NSString *)fileName inUserDirectory:(BOOL)inUserDirectory {
    NSString *filePath = [self cacheDataFilePathWithFileName:fileName inUserDirectory:inUserDirectory];
    if(filePath == nil) return nil;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
#ifdef DEBUG
        NSLog(@"[Disk Cache Manager] File not exists at path [%@]", filePath);
#endif
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways error:&error];
    if(error != nil) {
#ifdef DEBUG
        NSLog(@"[Disk Cache Manager] Reading file failure at path [%@]", filePath);
#endif
        return nil;
    }
    
    return data;
}

- (NSString *)cacheDataFilePathWithFileName:(NSString *)fileName inUserDirectory:(BOOL)inUserDirectory {
    NSString *filePath = nil;
    if(inUserDirectory) {
        if(_serve_account_ == nil) return nil;
        
        // get user directory
        NSString *directory = [[self class] YoomidUserDirectoryPathWithAccountId:_serve_account_];
        if(directory == nil) return nil;
        
        filePath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", fileName]];
    } else {
        filePath = [[[self class] YoomidDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", fileName]];
    }
    return filePath;
}

+ (NSString *)YoomidDirectoryPath {
    return [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:YOOMID_DIRECTORY_NAME];
}

+ (NSString *)YoomidUserDirectoryPathWithAccountId:(NSString *)accountId {
    if(accountId == nil || [@"" isEqualToString:accountId]) return nil;
    return [[[self class] YoomidDirectoryPath] stringByAppendingPathComponent:accountId];
}

@end


@implementation CacheData

@synthesize data = _data_;
@synthesize lastRefreshTime;

- (BOOL)isExpired {
    if(self.lastRefreshTime == nil) return YES;
    NSTimeInterval difference = abs(self.lastRefreshTime.timeIntervalSinceNow) / 60;
    return difference > CACHE_DATA_EXPIRED_MINUTES_INTERVAL;
}

- (void)setData:(id)data {
    if(data == nil) {
        _data_ = nil;
        return;
    }
    
    if([data isKindOfClass:[NSArray class]]
            || [data isKindOfClass:[NSDictionary class]]) {
        _data_ = data;
    } else {
#ifdef DEBUG
        NSLog(@"[Disk Cache Manager] Data type is not an array or dictionary");
#endif
    }
}

#pragma mark -
#pragma mark Json Entity

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
        self.data = [json notNSNullObjectForKey:@"data"];
        self.lastRefreshTime = [json dateWithTimeIntervalSince1970ForKey:@"lastRefreshTime"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setNoNilObject:self.data forKey:@"data"];
    [json setDateUsingTimeIntervalSince1970:self.lastRefreshTime forKey:@"lastRefreshTime"];
    return json;
}

@end
