//
//  MerchandiseParametersPicker.h
//  private_share
//
//  Created by Zhao yang on 7/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PopupView.h"
#import "Merchandise.h"
#import "MerchandiseProperty.h"
#import "DynamicGroupButtonView.h"
#import "ShoppingCart.h"

typedef NS_ENUM(NSInteger, MerchandisePickerMode) {
    MerchandisePickerModeForShoppingCart,
    MerchandisePickerModePurchase
};

@protocol MerchandiseParametersPickerDelegate;

@interface MerchandiseParametersPicker : PopupView<DynamicGroupButtonViewDelegate>

@property (nonatomic, strong) Merchandise *merchandise;
@property (nonatomic, assign) MerchandisePickerMode pickerMode;
@property (nonatomic, weak) id<MerchandiseParametersPickerDelegate> delegate;

+ (instancetype)pickerWithMerchandise:(Merchandise *)merchandise;
- (instancetype)initWithFrame:(CGRect)frame merchandise:(Merchandise *)merchandise;

@end

@protocol MerchandiseParametersPickerDelegate <NSObject>

- (void)merchandiseParametersPicker:(MerchandiseParametersPicker *)picker didPickMerchandiseWithPaymentType:(PaymentType)paymentType number:(NSInteger)number properties:(NSArray *)properties;

@end
