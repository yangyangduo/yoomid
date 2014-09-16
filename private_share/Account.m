//
//  Account.m
//  private_share
//
//  Created by Zhao yang on 6/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Account.h"
#import "AccountService.h"
#import "AccountInfoUpdatedEvent.h"
#import "XXEventSubscriptionPublisher.h"
#import "ShoppingCart.h"

@implementation Account {
    NSDate *lastRefreshTime;
}

@synthesize accountId = _accountId_;
@synthesize points = _points_;
@synthesize experience = _experience_;
@synthesize taskCount = _taskCount_;
@synthesize level = _level_;

+ (instancetype)currentAccount {
    static Account *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[Account alloc] init];
    });
    return account;
}

- (void)mayRefresh {
    if(lastRefreshTime != nil) {
        if(abs(lastRefreshTime.timeIntervalSinceNow) > 20) {
#ifdef DEBUG
            NSLog(@"start to refresh");
#endif
            [self refresh];
            return;
        }
    }
#ifdef DEBUG
    NSLog(@"dosen't need to refresh");
#endif
}

- (void)refresh {
    if([XXStringUtils isBlank:self.accountId]) return;
    lastRefreshTime = [NSDate date];
    AccountService *service = [[AccountService alloc] init];
    [service getAccountPoints:self.accountId target:self success:@selector(getAccountPointsSuccess:) failure:@selector(getAccountPointsFailure:)];
}

- (void)getAccountPointsSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *_account_points_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(_account_points_ != nil) {
            _accountId_ = [_account_points_ noNilStringForKey:@"accountId"];
            _points_ = [_account_points_ numberForKey:@"points"].integerValue;
            _experience_ = [_account_points_ numberForKey:@"experience"].longValue;
            _taskCount_ = [_account_points_ numberForKey:@"taskCount"].longValue;
            _level_ = [_account_points_ numberForKey:@"level"].longValue;
        }
        [self publishEvent];
        return;
    }
    [self getAccountPointsFailure:resp];
}

- (void)setPoints:(NSInteger)points {
    _points_ = points;
    [self publishEvent];
}

- (void)getAccountPointsFailure:(HttpResponse *)resp {
#ifdef DEBUG
    NSLog(@"[Account] Get account points failed, status code is %ld", (long)resp.statusCode);
#endif
}

- (void)clear {
    self.accountId = @"";
    self.points = 0;
    self.experience = 0;
    self.taskCount = 0;
    self.level = 0;
    [self publishEvent];
}

- (void)publishEvent {
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[AccountInfoUpdatedEvent alloc] init]];
}

@end
