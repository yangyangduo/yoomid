//
//  ShoppingItemTableViewCell.m
//  private_share
//
//  Created by Zhao yang on 9/14/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ShoppingItemTableViewCell.h"
#import "ShoppingCart.h"
#import "UIColor+App.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

CGFloat const TopInset3 = 18.f;
CGFloat const NameSize3 = 15.f;
CGFloat const NameWith3 = 140.f;
CGFloat const PropertiesSize3 = 13.f;
CGFloat const ImageViewHeight3 = 60.f;

@implementation ShoppingItemTableViewCell {
    // basic element
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *propertiesLabel;
    UIView *lineView;
    UILabel *numberLabel;
    
    // payment element
    UILabel *paymentLabel;
}

@synthesize shoppingItem = _shoppingItem_;
@synthesize shoppingCartViewController;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, TopInset3, ImageViewHeight3, ImageViewHeight3)];
        [self addSubview:imageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.bounds.size.width + 10, TopInset3, NameWith3, 0)];
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:NameSize3];
        nameLabel.textColor = [UIColor appTextColor];
        [self addSubview:nameLabel];
        
        propertiesLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.bounds.size.height + 5, NameWith3, 0)];
        propertiesLabel.numberOfLines = 0;
        propertiesLabel.lineBreakMode = NSLineBreakByWordWrapping;
        propertiesLabel.backgroundColor = [UIColor clearColor];
        propertiesLabel.font = [UIFont systemFontOfSize:PropertiesSize3];
        propertiesLabel.textColor = [UIColor colorWithRed:137.f / 255 green:137.f / 255 blue:137.f / 255 alpha:1];
        [self addSubview:propertiesLabel];
        
        paymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width, nameLabel.frame.origin.y - 2, 80, 20)];
        paymentLabel.textAlignment = NSTextAlignmentRight;
        paymentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:paymentLabel];
        
        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(paymentLabel.frame.origin.x, paymentLabel.frame.origin.y + paymentLabel.bounds.size.height + 8, 80, 20)];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.font = [UIFont systemFontOfSize:14.f];
        numberLabel.textColor = [UIColor lightGrayColor];
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.text = @"";
        [self addSubview:numberLabel];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(10, imageView.frame.origin.y + imageView.bounds.size.height + 19.5f, [UIScreen mainScreen].bounds.size.width - 20, 0.5f)];
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
 
 |                  propertiesLabel   y px
 |
 |     30 px
 |
 ------------------------------------
 */
+ (CGFloat)calcCellHeightWithShoppingItem:(ShoppingItem *)shoppingItem {
    if(shoppingItem != nil && shoppingItem.merchandise != nil) {
        NSString *nameString = shoppingItem.merchandise.name;
        NSString *propertiesString = [shoppingItem propertiesAsString];
        if(![@"" isEqualToString:nameString] && ![@"" isEqualToString:propertiesString]) {
            CGSize nameSize = [shoppingItem.merchandise.name boundingRectWithSize:CGSizeMake(NameWith3, 160) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:NameSize3] } context:nil].size;
            CGSize propertiesSize =  [shoppingItem.propertiesAsString boundingRectWithSize:CGSizeMake(NameWith3, 160) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:PropertiesSize3] } context:nil].size;
            CGFloat allLabelHeight = TopInset3 + nameSize.height + 5 + propertiesSize.height;
            if(allLabelHeight < TopInset3 + ImageViewHeight3) {
                allLabelHeight = TopInset3 + ImageViewHeight3;
            }
            return allLabelHeight + 30;
        }
    }
    return TopInset3 + ImageViewHeight3 + 30;
}

- (void)setShoppingItem:(ShoppingItem *)shoppingItem {
    _shoppingItem_ = shoppingItem;
    if(_shoppingItem_ != nil) {
        [imageView setImageWithURL:[NSURL URLWithString:_shoppingItem_.merchandise.firstImageUrl] placeholderImage:[UIImage imageNamed:@"merchandise_placeholder"]];
        
        nameLabel.text = _shoppingItem_.merchandise.name;
        CGSize nameSize = [nameLabel.text boundingRectWithSize:CGSizeMake(nameLabel.frame.size.width, 160) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:NameSize3] } context:nil].size;
        CGRect nFrame = nameLabel.frame;
        nFrame.size.height = nameSize.height;
        nameLabel.frame = nFrame;
        
        propertiesLabel.text = [_shoppingItem_ propertiesAsString];
        CGSize propertiesSize = [propertiesLabel.text boundingRectWithSize:CGSizeMake(propertiesLabel.frame.size.width, 160) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:PropertiesSize3] } context:nil].size;
        
        CGRect pFrame = propertiesLabel.frame;
        pFrame.origin.y = nFrame.origin.y + nFrame.size.height + 5;
        pFrame.size.height = propertiesSize.height;
        propertiesLabel.frame = pFrame;
        
        CGFloat lY = propertiesLabel.bounds.size.height + propertiesLabel.frame.origin.y;
        if(lY < imageView.frame.origin.y + imageView.bounds.size.height) {
            lY = imageView.frame.origin.y + imageView.bounds.size.height;
        }
        
        CGRect lFrame = lineView.frame;
        lFrame.origin.y = lY + 19.5f;
        lineView.frame = lFrame;
        
        CGRect selfFrame = self.frame;
        selfFrame.size.height = lY + 30;
        self.frame = selfFrame;
        
        NSString *_payment_string_ = nil;
        if(PaymentTypePoints == _shoppingItem_.paymentType) {
            _payment_string_ = [NSString stringWithFormat:@"%ld", (long)shoppingItem.singlePayment.points];
        } else {
            _payment_string_ = [NSString stringWithFormat:@"¥ %.2f", shoppingItem.singlePayment.cash];
        }
        NSMutableAttributedString *paymentString = [[NSMutableAttributedString alloc] initWithString:_payment_string_ attributes:
                                                    @{
                                                      NSFontAttributeName : [UIFont systemFontOfSize:16.f],
                                                      NSForegroundColorAttributeName :  [UIColor appLightBlue] }];
        
//        [paymentString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:(PaymentTypePoints == _shoppingItem_.paymentType ? NSLocalizedString(@"points", @"") : NSLocalizedString(@"yuan", @"")) attributes:
//                                               @{
//                                                 NSFontAttributeName : [UIFont systemFontOfSize:13.f],
//                                                 NSForegroundColorAttributeName :  [UIColor appTextColor] }]];
        
        paymentLabel.attributedText = paymentString;
        
        numberLabel.text = [NSString stringWithFormat:@"x%d", shoppingItem.number];
    } else {
        imageView.image = nil;
        nameLabel.text = @"";
        propertiesLabel.text = @"";
        paymentLabel.text = @"";
        numberLabel.text = @"";
    }
}

@end
