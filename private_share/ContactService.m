//
//  ContactService.m
//  private_share
//
//  Created by 曹大为 on 14-8-14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "ContactService.h"

@implementation ContactService

- (void)addContactIsDefaule:(NSString *)isDefaule name:(NSString *)name phoneNumber:(NSString *)phoneNumber address:(NSString *)address target:(id)target success:(SEL)success failure:(SEL)failure
{
    NSData *body = [JsonUtil createJsonDataFromDictionary:@{@"isDefault" : isDefaule, @"name" : name, @"contactPhone" : phoneNumber, @"deliveryAddress" : address }];
    [self.httpClient post:[NSString stringWithFormat:@"/contacts?%@", self.authenticationString] contentType:@"application/json" body:body target:target success:success failure:failure userInfo:nil];
}

-(void)getContactInfo:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient get:[NSString stringWithFormat:@"/contacts?%@", self.authenticationString] target:target success:success failure:failure userInfo:nil];
}

-(void)deleteContactInfo:(NSString *)contactID target:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient delete:[NSString stringWithFormat:@"/contacts/%@?%@",contactID , self.authenticationString] target:target success:success failure:failure userInfo:nil];
}

-(void)updateContactInfo:(NSString *)contactID name:(NSString *)name phoneNumber:(NSString *)phoneNumber address:(NSString *)address target:(id)target success:(SEL)success failure:(SEL)failure
{
    NSData *body = [JsonUtil createJsonDataFromDictionary:@{@"id" : contactID, @"name" : name, @"contactPhone" : phoneNumber, @"deliveryAddress" : address }];
    [self.httpClient put:[NSString stringWithFormat:@"/contacts?%@", self.authenticationString] contentType:@"application/json" body:body target:target success:success failure:failure userInfo:nil];
}

- (void)setDefauleContact:(NSString *)contactID target:(id)target success:(SEL)success failure:(SEL)failure
{
    [self.httpClient get:[NSString stringWithFormat:@"/contacts/default?id=%@&%@",contactID,self.authenticationString] target:target success:success failure:failure userInfo:nil];
}
@end
