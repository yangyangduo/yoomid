//
//  PaymentCollectionViewCell.m
//  private_share
//
//  Created by Zhao yang on 6/9/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PaymentCollectionViewCell.h"
#import "ShoppingCart.h"
#import "UIParameterAlertView.h"

@implementation PaymentCollectionViewCell {
    UILabel *titleLabel;
    UILabel *paymentLabel;
    ShoppingItem *_shoppingItem_;
    NumberPicker *numberPicker;
}

@synthesize shoppingCartViewController;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 135, 26)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:17.f];
        [self addSubview:titleLabel];
        
        numberPicker = [NumberPicker numberPickerWithPoint:CGPointMake(145, 1) direction:NumberPickerDirectionHorizontal];
        numberPicker.number = 1;
        numberPicker.minValue = 0;
        numberPicker.delegate = self;
        [self addSubview:numberPicker];
        
        paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(numberPicker.frame.origin.x + numberPicker.frame.size.width + 5, 0, 87, 26)];
        paymentLabel.backgroundColor = [UIColor clearColor];
        paymentLabel.textColor = [UIColor darkGrayColor];
        paymentLabel.font = [UIFont systemFontOfSize:16.f];
        paymentLabel.textAlignment = NSTextAlignmentRight;
        paymentLabel.text = @"";
        [self addSubview:paymentLabel];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setShoppingItem:(ShoppingItem *)shoppingItem {
    _shoppingItem_ = shoppingItem;
    if(shoppingItem == nil || shoppingItem.merchandise == nil) {
        titleLabel.text = @"";
        paymentLabel.text = @"";
        return;
    }
    titleLabel.text = shoppingItem.merchandise.name ? shoppingItem.merchandise.name : @"";
    numberPicker.number = shoppingItem.number;
    
    [self refreshPrice];
}

- (void)refreshPrice {
    if(PaymentTypeCash == _shoppingItem_.paymentType) {
        paymentLabel.text = [NSString stringWithFormat:@"￥%.1f ", _shoppingItem_.payment.cash];
    } else if(PaymentTypePoints == _shoppingItem_.paymentType) {
        paymentLabel.text = [NSString stringWithFormat:@"%ld%@", (long)_shoppingItem_.payment.points, NSLocalizedString(@"points", @"")];
    }
}

#pragma mark -
#pragma mark Number picker delegate

- (void)numberPickerDelegate:(NumberPicker *)numberPicker valueDidChangedTo:(NSInteger)number {
    [self refreshPrice];
}

- (BOOL)numberPickerDelegate:(NumberPicker *)numberPicker valueWillChangeTo:(NSInteger)number {
    if(number == 0) {
        UIParameterAlertView *confirmAlertView = [[UIParameterAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:NSLocalizedString(@"merchandise_delete_tips", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"determine", @""), nil];
        [confirmAlertView setParameter:_shoppingItem_ forKey:@"shoppingItem"];
        confirmAlertView.delegate = self.shoppingCartViewController;
        [confirmAlertView show];
        return NO;
    }
    
//    [[ShoppingCart myShoppingCart] setMerchandise:_shoppingItem_.merchandise shopID:kHentreStoreID number:number paymentType:_shoppingItem_.paymentType];
    return YES;
}

@end
