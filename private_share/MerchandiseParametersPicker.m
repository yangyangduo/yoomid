//
//  MerchandiseParametersPicker.m
//  private_share
//
//  Created by Zhao yang on 7/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "MerchandiseParametersPicker.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "NumberPicker.h"
#import "UIColor+App.h"
#import "PaymentButton.h"
#import "UIImage+Color.h"
#import "UIDevice+ScreenSize.h"
#import "XXAlertView.h"
#import "ShoppingCart.h"
#import "Constants.h"

@implementation MerchandiseParametersPicker {
    UIImageView *imageView;
    UIImageView *pointsImageView;
    UILabel *merchandiseNameLabel;
    UILabel *pointsLabel;
    
    PaymentButton *pointsPaymentButton;
    PaymentButton *cashPaymentButton;
    NSMutableArray *groupButtonsViews;
    
    NumberPicker *numberPicker;
    
    UIScrollView *scrollView;
}

@synthesize merchandise = _merchandise_;

+ (instancetype)pickerWithMerchandise:(Merchandise *)merchandise {
    MerchandiseParametersPicker *picker = [[MerchandiseParametersPicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 400) merchandise:merchandise];
    return picker;
}

- (instancetype)initWithFrame:(CGRect)frame merchandise:(Merchandise *)merchandise {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _merchandise_ = merchandise;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 75)];
        [imageView setImageWithURL:[NSURL URLWithString:_merchandise_.firstImageUrl] placeholderImage:nil];
        [self addSubview:imageView];
        
        merchandiseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + 10, 7, 160, 44)];
        merchandiseNameLabel.backgroundColor = [UIColor clearColor];
        merchandiseNameLabel.font = [UIFont systemFontOfSize:17.f];
        merchandiseNameLabel.numberOfLines = 2;
        merchandiseNameLabel.textColor = [UIColor grayColor];
        merchandiseNameLabel.text = merchandise.name;
        [self addSubview:merchandiseNameLabel];
        
        pointsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(merchandiseNameLabel.frame.origin.x, merchandiseNameLabel.frame.origin.y + merchandiseNameLabel.frame.size.height + 12, 20, 20)];
        pointsImageView.image = [UIImage imageNamed:@"points_blue"];
        [self addSubview:pointsImageView];
        
        pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointsImageView.frame.origin.x + pointsImageView.frame.size.width + 5, pointsImageView.frame.origin.y, 100, 20)];
        pointsLabel.center = CGPointMake(pointsLabel.center.x, pointsImageView.center.y);
        pointsLabel.backgroundColor = [UIColor clearColor];
        pointsLabel.font = [UIFont systemFontOfSize:15.f];
        pointsLabel.text = [NSString stringWithFormat:@"%ld%@", (long)_merchandise_.points, NSLocalizedString(@"points", @"")];
        pointsLabel.textColor = [UIColor grayColor];
        [self addSubview:pointsLabel];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 49.f / 2 - 10, 40, 49.f / 2, 49.f / 2)];
        [closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self addSubview:closeButton];
        
        UIView *firstLine = [self lineViewWithY:imageView.frame.origin.y + imageView.frame.size.height + 10];
        [self addSubview:firstLine];
        
        // scroll view begin
        CGFloat lastY = firstLine.frame.origin.y + 11;
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lastY, self.bounds.size.width, 200)];
        lastY = 0;
        
        if(_merchandise_.properties != nil) {
            groupButtonsViews = [NSMutableArray array];
            for(int i=0; i<_merchandise_.properties.count; i++) {
                MerchandiseProperty *property = [_merchandise_.properties objectAtIndex:i];
                
                UILabel *propertyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lastY, 300, 30)];
                propertyLabel.text = property.name;
                propertyLabel.textColor = [UIColor darkGrayColor];
                [scrollView addSubview:propertyLabel];
                lastY += propertyLabel.bounds.size.height + 2;
                
                [scrollView addSubview:[self lineViewWithX:10 y:lastY]];
                lastY += 11.f;
                
                if(property.values != nil) {
                    NSMutableArray *propertyValues = [NSMutableArray array];
                    for(int j=0; j<property.values.count; j++) {
                        [propertyValues addObject:[[NameValue alloc] initWithName:[property.values objectAtIndex:j] value:nil]];
                    }
                    DynamicGroupButtonView *groupButtonView = [DynamicGroupButtonView dynamicGroupButtonViewWithPoint:CGPointMake(0, lastY) nameValues:propertyValues];
                    groupButtonView.identifier = property.name;
                    groupButtonView.delegate = self;
                    groupButtonView.tintColor = [UIColor appColor];
                    if(propertyValues.count == 1) {
                        groupButtonView.selectedItem = [propertyValues objectAtIndex:0];
                    }
                    [scrollView addSubview:groupButtonView];
                    lastY += groupButtonView.bounds.size.height + 10;
                    [groupButtonsViews addObject:groupButtonView];
                }
            }
        }
        
        UILabel *exchangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lastY, 100, 30)];
        exchangeLabel.textColor = [UIColor darkGrayColor];
        exchangeLabel.text = NSLocalizedString(@"exchange_type", @"");
        [scrollView addSubview:exchangeLabel];
        
        lastY += exchangeLabel.bounds.size.height + 2.f;
        [scrollView addSubview:[self lineViewWithX:10 y:lastY]];
        lastY += 11.f;
        
        pointsPaymentButton = [[PaymentButton alloc] initWithPoint:CGPointMake(10, lastY) paymentType:PaymentTypePoints points:_merchandise_.points returnPoints:0];
        [scrollView addSubview:pointsPaymentButton];
        
        cashPaymentButton = [[PaymentButton alloc] initWithPoint:CGPointMake(pointsPaymentButton.frame.origin.x + pointsPaymentButton.bounds.size.width + 10, lastY) paymentType:PaymentTypeCash points:_merchandise_.points returnPoints:_merchandise_.returnPoints];
        [scrollView addSubview:cashPaymentButton];
        
        [pointsPaymentButton addTarget:self action:@selector(paymentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cashPaymentButton addTarget:self action:@selector(paymentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        lastY += pointsPaymentButton.bounds.size.height + 15.f;
        
        [scrollView addSubview:[self lineViewWithX:10 y:lastY]];
        lastY += 11.f;
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, lastY, 100, 30)];
        numberLabel.textColor = [UIColor darkGrayColor];
        numberLabel.text = NSLocalizedString(@"purchase_number", @"");
        [scrollView addSubview:numberLabel];
        numberPicker = [NumberPicker numberPickerWithPoint:CGPointMake(200, lastY) height:30 buttonWidth:34 textWidth:40 direction:NumberPickerDirectionHorizontal];
        numberPicker.number = 1;
        numberPicker.center = CGPointMake(numberPicker.center.x, numberLabel.center.y);
        [scrollView addSubview:numberPicker];
        
        lastY += numberLabel.bounds.size.height + 10;
        scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, lastY);
        [self addSubview:scrollView];
        // scroll view end
        
        // re-calc size begin
        CGFloat head=firstLine.frame.origin.y + 11, body=scrollView.contentSize.height, foot = 10 + 26 + 10, maxHeight = [UIDevice is4InchDevice] ? 488 : 400, totalHeight = 0;
        
        totalHeight = head + body + foot;
        if(totalHeight > maxHeight) {
            body = maxHeight - head - foot;
            totalHeight = maxHeight;
        }
        
        CGRect selfFrame = self.frame;
        selfFrame.size.height = totalHeight;
        self.frame = selfFrame;
        
        CGRect scrollFrame = scrollView.frame;
        scrollFrame.size.height = body;
        scrollView.frame = scrollFrame;
        // re-calc size end
        
        // purchase button
        [self addSubview:[self lineViewWithY:self.bounds.size.height - 10 - 26 - 10]];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 9 - 26 - 10, self.bounds.size.width, 9 + 26 + 10)];
        bottomView.backgroundColor = [UIColor colorWithRed:250.f / 255.f green:250.f / 255.f blue:250.f / 255.f alpha:1.0];
        [self addSubview:bottomView];
        
        UIButton *purchaseButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 10, 120, 26)];
        [purchaseButton addTarget:self action:@selector(confirmMerchandiseSelect:) forControlEvents:UIControlEventTouchUpInside];
        [purchaseButton setBackgroundImage:[UIImage imageWithColor:[UIColor appColor] size:CGSizeMake(120, 26)] forState:UIControlStateNormal];
        purchaseButton.layer.cornerRadius = 5;
        purchaseButton.layer.masksToBounds = YES;
        [purchaseButton setTitle:NSLocalizedString(@"determine", @"") forState:UIControlStateNormal];
        [bottomView addSubview:purchaseButton];
    }
    return self;
}

- (UIView *)lineViewWithY:(CGFloat)y {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, 1.f)];
    line.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
    return line;
}

- (UIView *)lineViewWithX:(CGFloat)x y:(CGFloat)y {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.bounds.size.width - x, 1.f)];
    line.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
    return line;
}

#pragma mark -
#pragma mark 

- (void)dynamicGroupButtonView:(DynamicGroupButtonView *)dynamicGroupButtonView selectedItemDidChangeTo:(NameValue *)nameValue {
}

- (void)paymentButtonPressed:(PaymentButton *)paymentButton {
    if(paymentButton.selected) return;
    paymentButton.selected = !paymentButton.selected;
    if(paymentButton == pointsPaymentButton) {
        cashPaymentButton.selected = !paymentButton.selected;
    } else {
        pointsPaymentButton.selected = !paymentButton.selected;
    }
}

- (void)confirmMerchandiseSelect:(id)sender {
    NSMutableArray *properties = [NSMutableArray array];
    if(groupButtonsViews != nil) {
        for(int i=0; i<groupButtonsViews.count; i++) {
            DynamicGroupButtonView *groupButtonView = [groupButtonsViews objectAtIndex:i];
            if(groupButtonView.selectedItem == nil) {
                [[XXAlertView currentAlertView] setMessage:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"please_select", @""), groupButtonView.identifier] forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
                return;
            } else {
                [properties addObject:@{ @"name" : groupButtonView.identifier, @"value" : groupButtonView.selectedItem.name }];
            }
        }
    }
    
    if(!cashPaymentButton.selected && !pointsPaymentButton.selected) {
        [[XXAlertView currentAlertView] setMessage:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"please_select", @""), NSLocalizedString(@"exchange_type", @"")] forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    
    PaymentType paymentType = pointsPaymentButton.selected ? PaymentTypePoints : PaymentTypeCash;
    [[ShoppingCart myShoppingCart] putMerchandise:_merchandise_ shopID:kHentreStoreID number:numberPicker.number paymentType:paymentType properties:properties];
    
    
    /*
    BOOL success = [[ShoppingCart myShoppingCart] putMerchandise:_merchandise_ shopID:kHentreStoreID number:numberPicker.number paymentType:paymentType];
    if(success) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"added_to_shopping_cart", @"") forType:AlertViewTypeSuccess];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        [self dismissViewController:sender];
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"points_not_enough", @"") forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
    }
     */
    
    [self closeView];
}

@end
