//
//  AllConsignee.m
//  private_share
//
//  Created by 曹大为 on 14/11/13.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "AllConsignee.h"
#import "ContactService.h"
#import "ViewControllerAccessor.h"

@implementation AllConsignee
{
    Consignee *currentConsignee;
}

@synthesize allConsignee = _allConsignee;

+ (instancetype)myAllConsignee {
    static dispatch_once_t onceToken;
    static AllConsignee *consignee;
    dispatch_once(&onceToken, ^{
        consignee = [[AllConsignee alloc] init];
    });
    return consignee;
}

- (BOOL)isEmpty{
    return _allConsignee.count > 0 ? NO : YES;
}

- (NSMutableArray *)consignee{
    return _allConsignee;
}

- (void)getContact
{
    [self getContactInfo];
}

- (void)getContactInfo {
    if(_allConsignee == nil) {
        _allConsignee = [NSMutableArray array];
    } else {
        [_allConsignee removeAllObjects];
    }
    currentConsignee = nil;
    
    ContactService *contactService = [[ContactService alloc]init];
    [contactService getContactInfo:self success:@selector(getContactSuccess:) failure:@selector(getContactFailure:)];
}

- (void)getContactSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200 && resp.body != nil) {
        NSMutableArray *_contacts_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        
        if(_contacts_ != nil) {
            for(int i=0; i<_contacts_.count; i++) {
                NSDictionary *contactJson = [_contacts_ objectAtIndex:i];
                Consignee *consignee = [[Consignee alloc] initWithJson:contactJson];
                [_allConsignee addObject:consignee];
            }
        }
        if (currentConsignee == nil) {
            [self setDefaultConsignee];
        }
        return;
    }else{
        [self getContactFailure:resp];
    }
}

- (void)getContactFailure:(HttpResponse *)resp {
    [[ViewControllerAccessor defaultAccessor].homePageViewController handleFailureHttpResponse:resp];
}

- (void)setDefaultConsignee{
    for (Consignee *consi in _allConsignee) {
        if ([consi.isDefault isEqualToString:@"1"]) {  //读取默认收货人 到 购物车收货人
            currentConsignee = consi;
        }else{
            currentConsignee = [_allConsignee objectAtIndex:0];
        }
    }
    if (_allConsignee.count ==  0) {
        currentConsignee = nil;
    }
}

- (Consignee *) currentConsignee{
    return currentConsignee;
}

- (void) setCurrentConsignee:(NSInteger)index
{
    if (_allConsignee.count > 0 && index <= _allConsignee.count) {
        currentConsignee = [_allConsignee objectAtIndex:index];
    }
}

//删除和修改 分两种情况：1、删除普通的 2、删除当前选中的
- (void)deleteConsigneeWithID:(NSString *)consigneeID
{
    for (Consignee *consi in _allConsignee) {
        if ([consi.identifier isEqualToString:consigneeID]) {
            [_allConsignee removeObject:consi];
            break;
        }
    }
    //删除的是当前的收货人
    if ([consigneeID isEqualToString:currentConsignee.identifier]) {
        [self setDefaultConsignee];//重新设置当前 收货人
    }
}

- (void)modifyConsigneeWithID:(Consignee *)consignee
{
    for (int i = 0; i < _allConsignee.count; i++) {
        Consignee *consi = [_allConsignee objectAtIndex:i];
        if ([consi.identifier isEqualToString:consignee.identifier]) {
            [_allConsignee removeObject:consi];
            [_allConsignee insertObject:consignee atIndex:i];
            
            //如果修改的是当前收货人
            if ([currentConsignee.identifier isEqualToString:consignee.identifier]) {
                currentConsignee = consignee;
            }
        }
    }
}

//设置为默认收货地址
- (void) setDefaultConsigneeWithID:(NSString *)consigneeID
{
    
}

//增加的话，
@end
