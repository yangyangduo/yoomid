//
//  QRCode.h
//  private_share
//
//  Created by Zhao yang on 6/20/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSUInteger, QRCodeType) {
    QRCodeTypeMerchandiseOrder        =        1
};

@interface QRCode : BaseModel

@property(nonatomic, assign) QRCodeType codeType;
@property(nonatomic, strong) NSDictionary *codeContent;

@end
