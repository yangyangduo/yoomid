//
//  ShoppingItemCell.m
//  private_share
//
//  Created by Zhao yang on 7/17/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItemCell.h"
#import "ShoppingCart.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIParameterAlertView.h"
#import "UIColor+App.h"

CGFloat const TopInset = 18.f;
CGFloat const NameSize = 15.f;
CGFloat const NameWidth = 120.f;
CGFloat const PropertiesSize = 13.f;
CGFloat const ImageViewHeight = 60.f;

@implementation ShoppingItemCell {
    // basic element
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *propertiesLabel;
    UIButton *selectButton;
    UIView *lineView;
    
    // payment element
    UILabel *paymentLabel;
    NumberPicker *numberPicker;
}

@synthesize shoppingItem = _shoppingItem_;
@synthesize shoppingCartViewController;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        
        selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        selectButton.center = CGPointMake(selectButton.center.x, imageView.center.y);
        [selectButton setImage:[UIImage imageNamed:@"cb_unselect"] forState:UIControlStateNormal];
        [selectButton setImage:[UIImage imageNamed:@"cb_select"] forState:UIControlStateSelected];
        [selectButton addTarget:self action:@selector(selectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectButton];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(44, TopInset, ImageViewHeight, ImageViewHeight)];
        [self addSubview:imageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.bounds.size.width + 10, TopInset, NameWidth, 0)];
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:NameSize];
        nameLabel.textColor = [UIColor appTextColor];
        [self addSubview:nameLabel];
        
        propertiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.bounds.size.height + 5, NameWidth, 0)];
        propertiesLabel.numberOfLines = 0;
        propertiesLabel.lineBreakMode = NSLineBreakByWordWrapping;
        propertiesLabel.backgroundColor = [UIColor clearColor];
        propertiesLabel.font = [UIFont systemFontOfSize:PropertiesSize];
        propertiesLabel.textColor = [UIColor colorWithRed:137.f / 255 green:137.f / 255 blue:137.f / 255 alpha:1];
        [self addSubview:propertiesLabel];
        
        paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width, nameLabel.frame.origin.y - 2, 75, 20)];
        paymentLabel.backgroundColor = [UIColor clearColor];
        paymentLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:paymentLabel];
        
        numberPicker = [NumberPicker numberPickerWithPoint:CGPointMake(self.bounds.size.width - NameWidth, 0) height:26 buttonWidth:36 textWidth:40 direction:NumberPickerDirectionHorizontal];
        numberPicker.delegate = self;
        [self addSubview:numberPicker];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, numberPicker.bounds.size.height + numberPicker.frame.origin.y + 10, frame.size.width - 20, 0.5f)];
        lineView.backgroundColor = [UIColor colorWithRed:229.f / 255.f green:229.f / 255.f blue:229.f / 255.f alpha:1.0f];
        [self addSubview:lineView];
    }
    return self;
}

/*
 ------------------------------------
  |            |     
  |            |            18 px
  |            |
 
             nameLabel      x px
image height px
               |            5 px
 
  |       propertiesLabel   y px
  |
               |
                           |
                           |     10 px
                      numberPicker      26 px
                           |
                           |     20 px
                           |
 ------------------------------------
 */
+ (CGFloat)calcCellHeightWithShoppingItem:(ShoppingItem *)shoppingItem {
    if(shoppingItem != nil && shoppingItem.merchandise != nil) {
        NSString *nameString = shoppingItem.merchandise.name;
        NSString *propertiesString = [shoppingItem propertiesAsString];
        if(![@"" isEqualToString:nameString] && ![@"" isEqualToString:propertiesString]) {
            CGSize nameSize = [shoppingItem.merchandise.name boundingRectWithSize:CGSizeMake(NameWidth, 160) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:NameSize] } context:nil].size;
            CGSize propertiesSize = [shoppingItem.propertiesAsString boundingRectWithSize:CGSizeMake(NameWidth, 160) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:PropertiesSize] } context:nil].size;
            CGFloat allLabelHeight = TopInset + nameSize.height + 5 + propertiesSize.height;
            if(allLabelHeight < TopInset + ImageViewHeight) {
                allLabelHeight = TopInset + ImageViewHeight;
            }
            
            return allLabelHeight + 10 + 26 + 20;
        }
    }
    return TopInset + ImageViewHeight + 10 + 26 + 20;
}

- (void)setShoppingItem:(ShoppingItem *)shoppingItem {
    _shoppingItem_ = shoppingItem;
    if(_shoppingItem_ != nil) {
        selectButton.selected = shoppingItem.selected;
        
        [imageView setImageWithURL:[NSURL URLWithString:_shoppingItem_.merchandise.firstImageUrl] placeholderImage:[UIImage imageNamed:@"merchandise_placeholder"]];
        
        nameLabel.text = _shoppingItem_.merchandise.name;
        
        CGSize nameSize = [nameLabel.text boundingRectWithSize:CGSizeMake(nameLabel.frame.size.width, 160) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:NameSize] } context:nil].size;
        CGRect nFrame = nameLabel.frame;
        nFrame.size.height = nameSize.height;
        nameLabel.frame = nFrame;
        
        propertiesLabel.text = [_shoppingItem_ propertiesAsString];
        CGSize propertiesSize = [propertiesLabel.text boundingRectWithSize:CGSizeMake(propertiesLabel.frame.size.width, 160) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:PropertiesSize] } context:nil].size;
        CGRect pFrame = propertiesLabel.frame;
        pFrame.origin.y = nFrame.origin.y + nFrame.size.height + 5;
        pFrame.size.height = propertiesSize.height;
        propertiesLabel.frame = pFrame;
        
        CGRect npFrame = numberPicker.frame;
        CGFloat npY = propertiesLabel.bounds.size.height + propertiesLabel.frame.origin.y;
        if(npY < imageView.frame.origin.y + imageView.bounds.size.height) {
            npY = imageView.frame.origin.y + imageView.bounds.size.height;
        }
        npFrame.origin.y = npY + 10;
        numberPicker.frame = npFrame;
        numberPicker.number = shoppingItem.number;
        
        CGRect lFrame = lineView.frame;
        lFrame.origin.y = numberPicker.bounds.size.height + numberPicker.frame.origin.y + 10;
        lineView.frame = lFrame;
        
        CGRect selfFrame = self.frame;
        selfFrame.size.height = numberPicker.frame.origin.y + numberPicker.bounds.size.height + 20;
        self.frame = selfFrame;
        
        NSString *_payment_string_ = nil;
        if(PaymentTypePoints == _shoppingItem_.paymentType) {
            _payment_string_ = [NSString stringWithFormat:@"%ld", (long)shoppingItem.singlePayment.points];
        } else {
            _payment_string_ = [NSString stringWithFormat:@"%.1f", shoppingItem.singlePayment.cash];
        }
        NSMutableAttributedString *paymentString = [[NSMutableAttributedString alloc] initWithString:_payment_string_ attributes:
                @{
                    NSFontAttributeName : [UIFont systemFontOfSize:16.f],
                    NSForegroundColorAttributeName :  [UIColor appLightBlue] }];
        
        [paymentString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:(PaymentTypePoints == _shoppingItem_.paymentType ? NSLocalizedString(@"points", @"") : NSLocalizedString(@"yuan", @"")) attributes:
                @{
                    NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                    NSForegroundColorAttributeName :  [UIColor appTextColor] }]];
        
        paymentLabel.attributedText = paymentString;
    } else {
        imageView.image = nil;
        nameLabel.text = @"";
        propertiesLabel.text = @"";
        paymentLabel.text = @"";
        selectButton.selected = NO;
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)selectButtonPressed:(id)sender {
    //selectButton.selected = !selectButton.selected;
    [[ShoppingCart myShoppingCart] setSelect:!selectButton.selected forShoppingItem:self.shoppingItem];
}

- (void)refreshShoppingItemSelectProperty {
    selectButton.selected = self.shoppingItem.selected;
}

#pragma mark -
#pragma mark Number picker delegate

- (BOOL)numberPickerDelegate:(NumberPicker *)numberPicker valueWillChangeTo:(NSInteger)number {
    if(number == 0) {
        if(self.shoppingCartViewController != nil) {
            UIParameterAlertView *confirmAlertView = [[UIParameterAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:NSLocalizedString(@"merchandise_delete_tips", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"determine", @""), nil];
            [confirmAlertView setParameter:_shoppingItem_ forKey:@"shoppingItem"];
            confirmAlertView.delegate = self.shoppingCartViewController;
            [confirmAlertView show];
        }
        return NO;
    } else {
        self.shoppingItem.number = number;
        [[ShoppingCart myShoppingCart] publishEvent];
        return YES;
    }
}

@end




