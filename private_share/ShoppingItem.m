//
//  ShoppingItem.m
//  private_share
//
//  Created by Zhao yang on 6/6/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItem.h"
#import "BaseModel.h"

@implementation ShoppingItem

@synthesize paymentType;
@synthesize number;
@synthesize merchandise = _merchandise_;
@synthesize properties;
@synthesize selected = _selected_;
@synthesize shopId;

- (instancetype)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.merchandise = [[Merchandise alloc] init];
        self.merchandise.identifier = [json noNilStringForKey:@"merchandiseId"];
        NSString *imageUrl = [json noNilStringForKey:@"imageUrl"];
        self.merchandise.imageUrls = @[ imageUrl ];
        self.merchandise.name = [json noNilStringForKey:@"name"];
        [self setPropertiesUsingString:[json noNilStringForKey:@"properties"]];
        
        NSNumber *numberNumber = [json numberForKey:@"number"];
        if(numberNumber != nil) {
            self.number = numberNumber.integerValue;
        }
        
        NSNumber *paymentTypeNumber = [json numberForKey:@"paymentType"];
        if(paymentTypeNumber != nil) {
            if(paymentTypeNumber.integerValue == 1) {
                self.paymentType = PaymentTypePoints;
                NSNumber *pointsNumber = [json numberForKey:@"totalPoints"];
                if(pointsNumber != nil) {
                    self.merchandise.points = pointsNumber.integerValue / self.number;
                }
            } else if(paymentTypeNumber.integerValue == 2) {
                self.paymentType = PaymentTypeCash;
                NSNumber *cashNumber = [json numberForKey:@"totalCash"];
                if(cashNumber != nil) {
                    self.merchandise.points = cashNumber.floatValue * 100 / self.number;
                }
            }
        }
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *dic = [super toJson];
    if(self.merchandise == nil) return dic;
    
    [dic setMayBlankString:self.merchandise.identifier forKey:@"merchandiseId"];
    [dic setMayBlankString:self.merchandise.firstImageUrl forKey:@"imageUrl"];
    [dic setMayBlankString:self.merchandise.name forKey:@"name"];
    [dic setInteger:number forKey:@"number"];
    
    NSInteger pType = 1;
    if(PaymentTypePoints == self.paymentType) {
        pType = 1;
    } else if(PaymentTypeCash == self.paymentType) {
        pType = 2;
    }
    [dic setInteger:pType forKey:@"paymentType"];
    
    return dic;
}

- (Payment *)singlePayment {
    if(self.merchandise == nil) {
        return [[Payment alloc] initWithPoints:0 cash:0];
    }
    if(PaymentTypePoints == self.paymentType) {
        return [[Payment alloc] initWithPoints:self.merchandise.points cash:0];
    } else if(PaymentTypeCash == self.paymentType) {
//        float cash = ((float)self.merchandise.points) / 100.f;
        float cash = (float)self.merchandise.price;
        return [[Payment alloc] initWithPoints:0 cash:cash];
    }
    return [[Payment alloc] initWithPoints:0 cash:0];
}

- (Payment *)payment {
    if(self.merchandise == nil) {
        return [[Payment alloc] initWithPoints:0 cash:0];
    }
    if(PaymentTypePoints == self.paymentType) {
        return [[Payment alloc] initWithPoints:(self.merchandise.points * self.number) cash:0];
    } else if(PaymentTypeCash == self.paymentType) {
//        float cash = (((float)self.merchandise.points) / 100.f) * self.number;
        float cash = (float)self.merchandise.price * self.number;
        return [[Payment alloc] initWithPoints:0 cash:cash];
    }
    return [[Payment alloc] initWithPoints:0 cash:0];
}

- (NSString *)propertiesAsString {
    if(self.properties == nil || self.properties.count == 0) {
        return @"";
    }
    NSMutableString *string = [NSMutableString string];
    for(int i=0; i<self.properties.count; i++) {
        NSDictionary *property = [self.properties objectAtIndex:i];
        [string appendString:[property objectForKey:@"name"]];
        [string appendString:@":"];
        [string appendString:[property objectForKey:@"value"]];
        if(i != self.properties.count - 1) {
            [string appendString:@";"];
        }
    }
    return string;
}

- (void)setPropertiesUsingString:(NSString *)propertiesString {
    NSMutableArray *props = [NSMutableArray array];
    
    if(propertiesString != nil && ![@"" isEqualToString:propertiesString]) {
        NSArray *_properties_ = [propertiesString componentsSeparatedByString:@";"];
        for(NSString *_property_ in _properties_) {
            NSArray *property = [_property_ componentsSeparatedByString:@":"];
            [props addObject:@{ @"name" : [property objectAtIndex:0], @"value" : [property objectAtIndex:1] }];
        }
    }
    
    self.properties = [NSArray arrayWithArray:props];
}

@end
