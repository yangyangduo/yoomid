//
//  AccountService.h
//  private_share
//
//  Created by Zhao yang on 6/4/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

typedef NS_ENUM(NSUInteger, VerifyCodeType) {
    VerifyCodeTypeRegister,
    VerifyCodeTypeForgotPassword,
    reset_password
};

@interface AccountService : BaseService

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password target:(id)target success:(SEL)success failure:(SEL)failure;

- (void)getVerifyCodeWithPhoneNumber:(NSString *)phoneNumber verifyCodeType:(VerifyCodeType)verifyCodeType target:(id)target success:(SEL)success failure:(SEL)failure;

- (void)registerWithUserName:(NSString *)userName verifyCode:(NSString *)verifyCode invitationCode:(NSString *)invitationCode password:(NSString *)password target:(id)target success:(SEL)success failure:(SEL)failure;

- (void)getContactInfo:(id)target success:(SEL)success failure:(SEL)failure;

- (void)getAccountPoints:(NSString *)accountId target:(id)target success:(SEL)success failure:(SEL)failure;

- (void)updatePasswordWithUserName:(NSString *)userName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword target:(id)target success:(SEL)success failure:(SEL)failure;

- (void)getVerifyCodeWithResetPasswordPhoneNumber:(NSString *)phoneNumber target:(id)target success:(SEL)success failure:(SEL)failure;

- (void)resetPasswordWithUserName:(NSString *)userName verifyCode:(NSString *)verifyCode password:(NSString *)password target:(id)target success:(SEL)success failure:(SEL)failure;

@end
