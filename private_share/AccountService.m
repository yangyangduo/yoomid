//
//  AccountService.m
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AccountService.h"

@implementation AccountService

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password target:(id)target success:(SEL)success failure:(SEL)failure {
    NSData *body = [JsonUtil createJsonDataFromDictionary:@{ @"account" : userName, @"password" : password }];
    [self.httpClient post:@"/login" contentType:@"application/json" body:body target:target success:success failure:failure userInfo:nil];
}

- (void)getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber verifyCodeType:(VerifyCodeType)verifyCodeType target:(id)target success:(SEL)success failure:(SEL)failure {
    [self.httpClient get:[NSString stringWithFormat:@"mobile_code?mobile=%@&type=%@", phoneNumber, VerifyCodeTypeRegister == verifyCodeType ? @"register" : @"getVerifyCodeFailure"] target:target success:success failure:failure userInfo:nil];
}

- (void)updatePasswordWithUserName:(NSString *)userName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword target:(id)target success:(SEL)success failure:(SEL)failure {
    NSDictionary *body = @{ @"account" : userName, @"oldPassword" : oldPassword, @"password" : newPassword };
    NSData *bodyData = [JsonUtil createJsonDataFromDictionary:body];
    [self.httpClient put:@"/account/password" contentType:@"application/json" body:bodyData target:target success:success failure:failure userInfo:nil];
}

- (void)registerWithUserName:(NSString *)userName verifyCode:(NSString *)verifyCode invitationCode:(NSString *)invitationCode password:(NSString *)password target:(id)target success:(SEL)success failure:(SEL)failure {
    NSData *body = [JsonUtil createJsonDataFromDictionary:@{ @"account" : userName, @"password" : password, @"invitationCode" : invitationCode }];
    [self.httpClient post:[NSString stringWithFormat:@"/register?mobileCode=%@", verifyCode] contentType:@"application/json" body:body target:target success:success failure:failure userInfo:nil];
}

- (void)getContactInfo:(id)target success:(SEL)success failure:(SEL)failure {
    [self.httpClient get:[NSString stringWithFormat:@"/account_details/contact_info?%@", self.authenticationString] target:target success:success failure:failure userInfo:nil];
}

- (void)getAccountPoints:(NSString *)accountId target:(id)target success:(SEL)success failure:(SEL)failure {
    [self.httpClient get:[NSString stringWithFormat:@"/account_points?%@", self.authenticationString] target:target success:success failure:failure userInfo:nil];
}

@end
