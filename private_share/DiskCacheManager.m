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
NSString * const kFileNameRecommendedMerchandises = @"recommended-merchandises";
NSString * const kFileNameCompletedTaskIds = @"completed-task-ids";
NSString * const kFileNameShoppingCart = @"shopping-cart";

NSString * const kFileNameContacts = @"contacts";
NSString * const kFileNamePointsOrder = @"points-order";

NSString * const kFileNameMerchandisesIds = @"merchandises-ids";
NSString * const kUserInfos = @"userInfos";
NSString * const kFileNameActivitieIds = @"activitiesids";

NSString * const kFileNameMerchandiseTemplate = @"merchandise-template";

@implementation DiskCacheManager {
    NSString *_serve_account_;
    
    //
    CacheData *_activities_data_;
    CacheData *_merchandises_data_;
    CacheData *_task_categories_data_;
    CacheData *_recommended_merchandises_data_;
    CacheData *_completed_task_ids_data_;
    
    CacheData *_merchandises_ids_data_;
    CacheData *_userInfos_data_;
    CacheData *_activities_ids_data;
    //
    CacheData *_contacts_data_;
    CacheData *_income_points_orders_data_;
    CacheData *_pay_points_orders_data_;
    CacheData *_shopping_cart_data_;
    CacheData *_account_info_data_;
    
    CacheData *_merchandise_template_data_;
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
    _income_points_orders_data_ = nil;
    _pay_points_orders_data_ = nil;
    _account_info_data_ = nil;
    
    if(_serve_account_ != nil) {
        NSString *userDirectory = [[self class] YoomidUserDirectoryPathWithAccountId:_serve_account_];
        if(userDirectory != nil) {
            [self initializeDirectoryWithPath:userDirectory];
        }
    }
}

#pragma mark -
#pragma mark Cache data get and read

- (NSArray *)recommendedMerchandises:(BOOL *)isExpired {
    NSArray *merchandises = nil;
    
    if(_recommended_merchandises_data_ == nil) {
        _recommended_merchandises_data_ = [self cacheDataFromDisk:kFileNameRecommendedMerchandises inUserDirectory:NO];
    }
    
    if(_recommended_merchandises_data_ != nil) {
        merchandises = [self arrayFromCacheData:_recommended_merchandises_data_ withEntityClass:[Merchandise class]];
    }
    
    *isExpired = [self cacheDataIsExpired:_recommended_merchandises_data_];
    return merchandises;
}

- (NSArray *)merchandises:(BOOL *)isExpired {
    NSArray *merchandises = nil;
    
    if(_merchandises_data_ == nil) {
        _merchandises_data_ = [self cacheDataFromDisk:kFileNameMerchandises inUserDirectory:NO];
    }
    
    if(_merchandises_data_ != nil) {
        merchandises = [self arrayFromCacheData:_merchandises_data_ withEntityClass:[Merchandise class]];
    }
    
    *isExpired = [self cacheDataIsExpired:_merchandises_data_];
    return merchandises;
}

- (NSArray *)taskCategories:(BOOL *)isExpired {
    NSArray *taskCategories = nil;
    
    if(_task_categories_data_ == nil) {
        _task_categories_data_ = [self cacheDataFromDisk:kFileNameTaskCategories inUserDirectory:NO];
    }
    
    if(_task_categories_data_ != nil) {
        taskCategories = [self arrayFromCacheData:_task_categories_data_ withEntityClass:[TaskCategory class]];
    }
    
    *isExpired = [self cacheDataIsExpired:_task_categories_data_];
    return taskCategories;
}

- (NSArray *)contacts:(BOOL *)isExpired {
    NSArray *contacts = nil;
    
    if(_contacts_data_ == nil) {
        _contacts_data_ = [self cacheDataFromDisk:kFileNameContacts inUserDirectory:YES];
    }
    
    if(_contacts_data_ != nil) {
        contacts = [self arrayFromCacheData:_contacts_data_ withEntityClass:[Contact class]];
    }
    
    *isExpired = [self cacheDataIsExpired:_contacts_data_];
    return contacts;
}

- (NSArray *)pointsOrdersWithPointsOrderType:(PointsOrderType)pointsOrderType isExpired:(BOOL *)isExpired {
    NSArray *data = nil;
    CacheData *cacheData = nil;
    NSString *fileName = [NSString stringWithFormat:@"%@-%@",
            kFileNamePointsOrder, ((PointsOrderTypeIncome == pointsOrderType) ? @"income" : @"pay")];
    

    if(PointsOrderTypeIncome == pointsOrderType) {
        if(_income_points_orders_data_ == nil) {
            _income_points_orders_data_ = [self cacheDataFromDisk:fileName inUserDirectory:YES];
        }
        cacheData = _income_points_orders_data_;
    } else {
        if(_pay_points_orders_data_ == nil) {
            _pay_points_orders_data_ = [self cacheDataFromDisk:fileName inUserDirectory:YES];
        }
        cacheData = _pay_points_orders_data_;
    }
    
    if(cacheData != nil) {
        data = [self arrayFromCacheData:cacheData withEntityClass:[PointsOrder class]];
    }
    
    *isExpired = [self cacheDataIsExpired:cacheData];
    return data;
}

- (NSArray *)activities:(BOOL *)isExpired {
    NSArray *activities = nil;
    
    if(_activities_data_ == nil) {
        _activities_data_ = [self cacheDataFromDisk:kFileNameActivities inUserDirectory:NO];
    }
    
    if(_activities_data_ != nil) {
        activities = [self arrayFromCacheData:_activities_data_ withEntityClass:[Merchandise class]];
    }
    
    *isExpired = [self cacheDataIsExpired:_activities_data_];
    return activities;
}

- (NSArray *)completedTaskIds {
    NSArray *completedTaskIds = nil;
    
    if(_completed_task_ids_data_ == nil) {
        _completed_task_ids_data_ = [self cacheDataFromDisk:kFileNameCompletedTaskIds inUserDirectory:NO];
    }
    
    if(_completed_task_ids_data_ != nil && _completed_task_ids_data_.data != nil) {
        completedTaskIds = [NSArray arrayWithArray:_completed_task_ids_data_.data];
    }

    return completedTaskIds;
}

- (id)cacheDataFromDisk:(NSString *)fileName inUserDirectory:(BOOL)inUserDirectory {
    CacheData *cacheData = nil;
    
    NSData *data = [self loadDataWithFileName:fileName inUserDirectory:inUserDirectory];
    if(data != nil) {
        id json = [JsonUtil createDictionaryOrArrayFromJsonData:data];
        if(json != nil) {
            cacheData = [[CacheData alloc] initWithJson:json];
#ifdef DEBUG
            NSLog(@"[Disk Cache Manager] Load [%@] from disk cache", fileName);
#endif
        }
    }
    
    return cacheData;
}

- (NSArray *)arrayFromCacheData:(CacheData *)cacheData withEntityClass:(Class)entityClass {
    if(cacheData == nil) return nil;
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSArray *jsonArray = cacheData.data;
    if(jsonArray != nil) {
        for(int i=0; i<jsonArray.count; i++) {
            [dataArray addObject:[[entityClass alloc] initWithJson:[jsonArray objectAtIndex:i]]];
        }
        NSLog(@"[Disk Cache Manager] Load [%@] from memory cache", [entityClass description]);
    }
    
    return dataArray.count == 0 ? nil : dataArray;
}

- (NSArray *)merchandisesIds{
    NSArray *merchandisesIds = nil;
    if (_merchandises_ids_data_ == nil) {
        _merchandises_ids_data_ = [self cacheDataFromDisk:kFileNameMerchandisesIds inUserDirectory:YES];
    }
    
    if (_merchandises_ids_data_ != nil && _merchandises_ids_data_.data != nil) {
        merchandisesIds = [NSArray arrayWithArray:_merchandises_ids_data_.data];
    }
    return merchandisesIds;
}

- (NSArray *)userInfo
{
    NSArray *userInfos = nil;
    if (_userInfos_data_ == nil) {
        _userInfos_data_ = [self cacheDataFromDisk:kUserInfos inUserDirectory:YES];
    }
    
    if (_userInfos_data_ != nil && _userInfos_data_.data != nil) {
        userInfos = [NSArray arrayWithArray:_userInfos_data_.data];
    }
    return userInfos;
}

- (NSArray *)activitiesIds
{
    NSArray *activities = nil;
    if (_activities_ids_data == nil) {
        _activities_ids_data = [self cacheDataFromDisk:kFileNameActivitieIds inUserDirectory:YES];
    }
    if (_activities_ids_data != nil && _activities_ids_data.data != nil) {
        activities = [NSArray arrayWithArray:_activities_ids_data.data];
    }
    return activities;
}

- (NSArray *)merchandisesTemplate:(BOOL *)isExpired
{
    NSArray *merchandises_template = nil;
    if (_merchandise_template_data_ == nil) {
        _merchandise_template_data_ = [self cacheDataFromDisk:kFileNameMerchandiseTemplate inUserDirectory:NO];
    }
    if (_merchandise_template_data_ != nil) {
        merchandises_template = [self arrayFromCacheData:_merchandise_template_data_ withEntityClass:[RowView class]];
    }
    
    *isExpired = [self cacheDataIsExpired:_merchandise_template_data_];
    return merchandises_template;
    
    //****
//    NSArray *merchandises = nil;
//    
//    if(_recommended_merchandises_data_ == nil) {
//        _recommended_merchandises_data_ = [self cacheDataFromDisk:kFileNameRecommendedMerchandises inUserDirectory:NO];
//    }
//    
//    if(_recommended_merchandises_data_ != nil) {
//        merchandises = [self arrayFromCacheData:_recommended_merchandises_data_ withEntityClass:[Merchandise class]];
//    }
//    
//    *isExpired = [self cacheDataIsExpired:_recommended_merchandises_data_];
//    return merchandises;
//
}

#pragma mark -
#pragma mark Cache data set and save
- (void)setMerchandisesTemplate:(NSArray *)merchandise_template
{
    if(_merchandise_template_data_ == nil) {
        _merchandise_template_data_ = [[CacheData alloc] init];
    }
    [self setCacheData:_merchandise_template_data_ jsonEntities:merchandise_template fileName:kFileNameMerchandiseTemplate inUserDirectory:NO];
}

- (void)setActivitiesIds:(NSArray *)activitieIds
{
    if (_activities_ids_data == nil) {
        _activities_ids_data = [[CacheData alloc]init];
    }
    [self setCacheData:_activities_ids_data jsonEntities:activitieIds entityIsBasicType:YES fileName:kFileNameActivitieIds inUserDirectory:YES];
}

- (void)setUserInfo:(NSArray *)userInfo
{
    if (_userInfos_data_ == nil) {
        _userInfos_data_ = [[CacheData alloc]init];
    }
    [self setCacheData:_userInfos_data_ jsonEntities:userInfo entityIsBasicType:YES fileName:kUserInfos inUserDirectory:YES];
}

- (void)setMerchandisesIds:(NSArray *)merchandisesIds {
    if (_merchandises_ids_data_ == nil) {
        _merchandises_ids_data_ = [[CacheData alloc]init];
    }
    [self setCacheData:_merchandises_ids_data_ jsonEntities:merchandisesIds entityIsBasicType:YES fileName:kFileNameMerchandisesIds inUserDirectory:YES];
}

- (void)setRecommendedMerchandises:(NSArray *)merchandises {
    if(_recommended_merchandises_data_ == nil) {
        _recommended_merchandises_data_ = [[CacheData alloc] init];
    }
    [self setCacheData:_recommended_merchandises_data_ jsonEntities:merchandises fileName:kFileNameRecommendedMerchandises inUserDirectory:NO];
}

- (void)setMerchandises:(NSArray *)merchandises {
    if(_merchandises_data_ == nil) {
        _merchandises_data_ = [[CacheData alloc] init];
    }
    [self setCacheData:_merchandises_data_ jsonEntities:merchandises fileName:kFileNameMerchandises inUserDirectory:NO];
}

- (void)setTaskCategories:(NSArray *)taskCategories {
    if(_task_categories_data_ == nil) {
        _task_categories_data_ = [[CacheData alloc] init];
    }
    [self setCacheData:_task_categories_data_ jsonEntities:taskCategories fileName:kFileNameTaskCategories inUserDirectory:NO];
}

- (void)setContacts:(NSArray *)contacts {
    if(_contacts_data_ == nil) {
        _contacts_data_ = [[CacheData alloc] init];
    }
    [self setCacheData:_contacts_data_ jsonEntities:contacts fileName:kFileNameContacts inUserDirectory:YES];
}

- (void)setPointsOrders:(NSArray *)pointsOrders pointsOrderType:(PointsOrderType)pointsOrderType {
    CacheData *cacheData = nil;
    NSString *fileName = [NSString stringWithFormat:@"%@-%@",
            kFileNamePointsOrder, ((PointsOrderTypeIncome == pointsOrderType) ? @"income" : @"pay")];
    
    if(PointsOrderTypeIncome == pointsOrderType) {
        if(_income_points_orders_data_ == nil) {
            _income_points_orders_data_ = [[CacheData alloc] init];
        }
        cacheData = _income_points_orders_data_;
    } else {
        if(_pay_points_orders_data_ == nil) {
            _pay_points_orders_data_ = [[CacheData alloc] init];
        }
        cacheData = _pay_points_orders_data_;
    }
    [self setCacheData:cacheData jsonEntities:pointsOrders fileName:fileName inUserDirectory:YES];
}

- (void)setActivities:(NSArray *)activities {
    if(_activities_data_ == nil) {
        _activities_data_ = [[CacheData alloc] init];
    }
    [self setCacheData:_activities_data_ jsonEntities:activities fileName:kFileNameActivities inUserDirectory:NO];
}

- (void)setCompletedTaskIds:(NSArray *)taskIds {
    if(_completed_task_ids_data_ == nil) {
        _completed_task_ids_data_ = [[CacheData alloc] init];
    }
    [self setCacheData:_completed_task_ids_data_ jsonEntities:taskIds entityIsBasicType:YES fileName:kFileNameCompletedTaskIds inUserDirectory:NO];
}

- (void)setCacheData:(CacheData *)cacheData jsonEntities:(NSArray *)jsonEntities
            entityIsBasicType:(BOOL)entityIsBasicType fileName:(NSString *)fileName inUserDirectory:(BOOL)inUserDirectory {
    if(cacheData == nil || fileName == nil) {
        NSLog(@"[Disk Cache Manager] Parameter invalid");
        return;
    }
    
    NSMutableArray *data = nil;
    
    if(jsonEntities != nil) {
        if(entityIsBasicType) {
            data = [NSMutableArray arrayWithArray:jsonEntities];
        } else {
            data = [NSMutableArray array];
            for(int i=0; i<jsonEntities.count; i++) {
                id<JsonEntity> jsonEntity = [jsonEntities objectAtIndex:i];
                [data addObject:[jsonEntity toJson]];
            }
        }
    }
    
    cacheData.data = data.count == 0 ? nil : data;
    cacheData.lastRefreshTime = [NSDate date];
    
    [self saveData:cacheData withFileName:fileName inUserDirectory:inUserDirectory];
#ifdef DEBUG
    NSLog(@"[Disk Cache Manager] Store [%@] to disk cache", fileName);
#endif
}

- (void)setCacheData:(CacheData *)cacheData jsonEntities:(NSArray *)jsonEntities
            fileName:(NSString *)fileName inUserDirectory:(BOOL)inUserDirectory {
    [self setCacheData:cacheData jsonEntities:jsonEntities entityIsBasicType:NO fileName:fileName inUserDirectory:inUserDirectory];
}

- (BOOL)cacheDataIsExpired:(CacheData *)cacheData {
    if(cacheData == nil) return YES;
    return cacheData.isExpired;
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
        if(_serve_account_ == nil) {
#ifdef DEBUG
            NSLog(@"[Disk Cache Manager] Account is empty, should be login first");
#endif
            return nil;
        }
        
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
