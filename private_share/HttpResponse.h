//
//  HttpResponse.h
//  private_share
//
//  Created by Zhao yang on 6/5/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResponse : NSObject

@property (nonatomic, strong) NSData *body;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSString *MIMEType;
@property (nonatomic, strong) NSString *failureReason;

@end
