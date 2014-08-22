//
//  YJFCustomScore.h
//  YJFSDK2.0
//
//  Created by emaryjf on 14-5-30.
//  Copyright (c) 2014年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol YJFCustomScoreDelegate <NSObject>
@optional
- (void) getDataSuccess;
- (void) getDataFailed;
@end

@interface YJFCustomScore : NSObject<NSURLConnectionDelegate,YJFCustomScoreDelegate>
{
    id<YJFCustomScoreDelegate> delegate;
}
+ (YJFCustomScore *)shareInstance;
+ (void)destroyInstance;
-(void) getScoreData:(int)pageSize : (int)pageNumber;
-(void) clickToAppStore:(NSString *)adId : (int)adType : (NSString *)adUrl : (NSString *)appUrl;
@property(assign) id<YJFCustomScoreDelegate> delegate;
@property (retain) NSMutableData *receiveData;
@property (nonatomic, retain) NSMutableArray* array;
@property int pageCount;
@property (nonatomic,copy) NSString *jsonStr;
@end
