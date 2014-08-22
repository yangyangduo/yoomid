//
//  ContactService.h
//  private_share
//
//  Created by 曹大为 on 14-8-14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "BaseService.h"

@interface ContactService : BaseService


-(void)addContactName:(NSString*)name phoneNumber:(NSString*)phoneNumber address:(NSString*)address target:(id)target success:(SEL)success failure:(SEL)failure;

-(void)getContactInfo:(id)target success:(SEL)success failure:(SEL)failure;
-(void)deleteContactInfo:(NSString*)contactID target:(id)target success:(SEL)success failure:(SEL)failure;
-(void)updateContactInfo:(NSString*)contactID name:(NSString*)name phoneNumber:(NSString*)phoneNumber address:(NSString*)address target:(id)target success:(SEL)success failure:(SEL)failure;
@end
