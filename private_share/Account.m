//
//  Account.m
//  private_share
//
//  Created by Zhao yang on 6/12/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "Account.h"
#import "AccountService.h"
#import "AccountPointsUpdatedEvent.h"
#import "XXEventSubscriptionPublisher.h"
#import "ShoppingCart.h"

@implementation Account

@synthesize accountId = _accountId_;
@synthesize points = _points_;
@synthesize availablePoints = _availablePoints_;

+ (instancetype)currentAccount {
    static Account *account;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        account = [[Account alloc] init];
    });
    return account;
}

- (void)refreshPoints {
    if([XXStringUtils isBlank:self.accountId]) return;
    AccountService *service = [[AccountService alloc] init];
    [service getAccountPoints:self.accountId target:self success:@selector(getAccountPointsSuccess:) failure:@selector(getAccountPointsFailure:)];
}

- (void)getAccountPointsSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *_account_points_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(_account_points_ != nil) {
            _accountId_ = [_account_points_ noNilStringForKey:@"accountId"];
            _points_ = [_account_points_ numberForKey:@"points"].integerValue;
            _availablePoints_ = _points_ - [ShoppingCart myShoppingCart].totalPayment.points;
        }
        AccountPointsUpdatedEvent *event = [[AccountPointsUpdatedEvent alloc] initWithPoints:self.points];
        [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
        return;
    }
    [self getAccountPointsFailure:resp];
}

- (void)setPoints:(NSInteger)points {
    _points_ = points;
    _availablePoints_ = _points_ - [ShoppingCart myShoppingCart].totalPayment.points;
    AccountPointsUpdatedEvent *event = [[AccountPointsUpdatedEvent alloc] initWithPoints:self.points];
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
}

- (void)getAccountPointsFailure:(HttpResponse *)resp {
#ifdef DEBUG
    NSLog(@"[Account] Get account points failed, status code is %ld", (long)resp.statusCode);
#endif
}

- (void)clear {
    self.accountId = @"";
    self.points = 0;
    self.availablePoints = 0;
    AccountPointsUpdatedEvent *event = [[AccountPointsUpdatedEvent alloc] initWithPoints:self.points];
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:event];
}

@end
