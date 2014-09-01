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

NSString * const kFileNameContacts = @"contacts";
NSString * const kFileNamePointsOrder = @"points-order";

@implementation DiskCacheManager {
    NSString *_serve_account_;
    
    //
    CacheData *_activities_data_;
    CacheData *_merchandises_data_;
    CacheData *_task_categories_data_;
    
    //
    CacheData *_contacts_data_;
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
    
    _contacts_data_ = nil;
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
    NSMutableArray *merchandises = [NSMutableArray array];
    
    BOOL readDisk = NO;
    
    // read from disk first
    if(_merchandises_data_ == nil) {
        NSData *data = [self loadDataWithFileName:kFileNameMerchandises inUserDirectory:NO];
        
        id json = [JsonUtil createDictionaryOrArrayFromJsonData:data];
        if(json != nil) {
            _merchandises_data_ = [[CacheData alloc] initWithJson:json];
#ifdef DEBUG
            NSLog(@"[Disk Cache Manager] Load merchandises from disk cache");
#endif
            readDisk = YES;
        }
    }
    
    // json data convert to entity type
    if(_merchandises_data_ != nil) {
        NSArray *jsonArray = _merchandises_data_.data;
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                [merchandises addObject:[[Merchandise alloc] initWithJson:[jsonArray objectAtIndex:i]]];
            }
#ifdef DEBUG
            if(!readDisk) {
                NSLog(@"[Disk Cache Manager] Load merchandises from memory cache");
            }
#endif
        }
    }
    
    *isExpired = _merchandises_data_ == nil ? YES : _merchandises_data_.isExpired;
    return merchandises.count == 0 ? nil : merchandises;
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

- (NSArray *)contacts:(BOOL *)isExpired {
    NSMutableArray *contacts = [NSMutableArray array];
    
    BOOL readDisk = NO;
    
    // read from disk first
    if(_contacts_data_ == nil) {
        NSData *data = [self loadDataWithFileName:kFileNameContacts inUserDirectory:YES];
        
        id json = [JsonUtil createDictionaryOrArrayFromJsonData:data];
        if(json != nil) {
            _contacts_data_ = [[CacheData alloc] initWithJson:json];
#ifdef DEBUG
            NSLog(@"[Disk Cache Manager] Load contacts from disk cache");
#endif
            readDisk = YES;
        }
    }
    
    // json data convert to entity type
    if(_contacts_data_ != nil) {
        NSArray *jsonArray = _contacts_data_.data;
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                [contacts addObject:[[Contact alloc] initWithJson:[jsonArray objectAtIndex:i]]];
            }
#ifdef DEBUG
            if(!readDisk) {
                NSLog(@"[Disk Cache Manager] Load contacts from memory cache");
            }
#endif
        }
    }
    
    *isExpired = _contacts_data_.data == nil ? YES : _contacts_data_.isExpired;
    return contacts.count == 0 ? nil : contacts;
}

- (NSArray *)pointsOrdersWithPointsOrderType:(PointsOrderType)pointsOrderType isExpired:(BOOL *)isExpired {
    
    return nil;
}

#pragma mark -
#pragma mark set and save

- (void)setActivities:(NSArray *)activities {
}

- (void)setMerchandises:(NSArray *)merchandises {
    if(_merchandises_data_ == nil) {
        _merchandises_data_ = [[CacheData alloc] init];
    }
    
    NSMutableArray *data = [NSMutableArray array];
    if(merchandises != nil) {
        for(int i=0; i<merchandises.count; i++) {
            id<JsonEntity> merchandise = [merchandises objectAtIndex:i];
            [data addObject:[merchandise toJson]];
        }
    }
    _merchandises_data_.data = data.count == 0 ? nil : data;
    _merchandises_data_.lastRefreshTime = [NSDate date];
    
    [self saveData:_merchandises_data_ withFileName:kFileNameMerchandises inUserDirectory:NO];
#ifdef DEBUG
    NSLog(@"[Disk Cache Manager] Store merchandises to disk cache");
#endif
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
#ifdef DEBUG
    NSLog(@"[Disk Cache Manager] Store task categories to disk cache");
#endif
}

- (void)setContacts:(NSArray *)contacts {
    if(_contacts_data_ == nil) {
        _contacts_data_ = [[CacheData alloc] init];
    }
    
    NSMutableArray *data = [NSMutableArray array];
    if(contacts != nil) {
        for(int i=0; i<contacts.count; i++) {
            id<JsonEntity> contact = [contacts objectAtIndex:i];
            [data addObject:[contact toJson]];
        }
    }
    _contacts_data_.data = data.count == 0 ? nil : data;
    _contacts_data_.lastRefreshTime = [NSDate date];
    
    [self saveData:_contacts_data_ withFileName:kFileNameContacts inUserDirectory:YES];
#ifdef DEBUG
    NSLog(@"[Disk Cache Manager] Store contacts to disk cache");
#endif
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
