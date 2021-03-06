//
//  ContactDisplayView.m
//  private_share
//
//  Created by Zhao yang on 8/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ContactDisplayView.h"
#import "ShoppingCart.h"
#import "UIColor+App.h"

CGFloat const kContactDisplayViewHeight = 75.f;

@implementation ContactDisplayView
{
    UIImageView *intoIamgeview;
    UILabel *contactIsNilLabel;
}

@synthesize currentContact = _currentContact_;
@synthesize currentConsignee = _currentConsignee;

- (instancetype)initWithFrame:(CGRect)frame contact:(Contact *)contact {
    self = [self initWithFrame:frame];
    if(self) {
        self.currentContact = contact;
        self.backgroundColor = [UIColor clearColor];

        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-10)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 250, 36)];
        _name.font = [UIFont systemFontOfSize:15.f];
        
        _phoneNumber = [[UILabel alloc]initWithFrame:CGRectMake(_name.frame.size.width+10, 8, 100, 36)];
        _phoneNumber.font = [UIFont systemFontOfSize:15.f];
        
        _address = [[UILabel alloc]init];
        _address.font = [UIFont systemFontOfSize:11.f];
        _address.numberOfLines = 0;//表示label可以多行显示
        _address.lineBreakMode = NSLineBreakByCharWrapping;
        _address.textColor = [UIColor grayColor];
        
        intoIamgeview = [[UIImageView alloc]initWithFrame:CGRectMake(bgView.bounds.size.width-40-20, bgView.bounds.size.height/2-30, 121.0/2, 121.0/2)];
        intoIamgeview.image = [UIImage imageNamed:@"into"];
        [bgView addSubview:intoIamgeview];
        
        contactIsNilLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 14, 250, 40)];
        contactIsNilLabel.text = @"";
        contactIsNilLabel.textColor = [UIColor appTextFieldGray];
        
        [bgView addSubview:contactIsNilLabel];
        [bgView addSubview:_name];
        [bgView addSubview:_phoneNumber];
        [bgView addSubview:_address];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kContactDisplayViewHeight)];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-10)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 250, 36)];
        _name.font = [UIFont systemFontOfSize:15.f];
        
        _phoneNumber = [[UILabel alloc]initWithFrame:CGRectMake(_name.frame.size.width+10, 8, 100, 36)];
        _phoneNumber.font = [UIFont systemFontOfSize:15.f];
        
        _address = [[UILabel alloc]init];
        _address.font = [UIFont systemFontOfSize:11.f];
        _address.numberOfLines = 0;//表示label可以多行显示
        _address.lineBreakMode = NSLineBreakByCharWrapping;
        _address.textColor = [UIColor grayColor];
        
        intoIamgeview = [[UIImageView alloc]initWithFrame:CGRectMake(bgView.bounds.size.width-40-20, bgView.bounds.size.height/2-30, 121.0/2, 121.0/2)];
        intoIamgeview.image = [UIImage imageNamed:@"into"];
        [bgView addSubview:intoIamgeview];
        
        contactIsNilLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 14, 250, 40)];
        contactIsNilLabel.text = @"";
        contactIsNilLabel.textColor = [UIColor appTextFieldGray];
        
        [bgView addSubview:contactIsNilLabel];
        [bgView addSubview:_name];
        [bgView addSubview:_phoneNumber];
        [bgView addSubview:_address];
    }
    return self;
}

- (void)setCurrentContact:(Contact *)currentContact {
    _currentContact_ = currentContact;
    // should update display here
    if (currentContact == nil) {
        _name.text = @"";
        _phoneNumber.text = @"";
        _address.text = @"";
        contactIsNilLabel.text = @"点击增加收货人地址信息!";
//        intoIamgeview.image = nil;
    }
    else{
        _name.text = [NSString stringWithFormat:@"收货人:%@  %@",currentContact.name,currentContact.phoneNumber];
//        _phoneNumber.text = currentContact.phoneNumber;
        NSString *contactAddress = [NSString stringWithFormat:@"收货地址:%@",currentContact.address];
        _address.text = contactAddress;
    
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:11.f]};
        CGSize addressLabelSize = [contactAddress boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-55, 100) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _address.frame = CGRectMake(20, 38, addressLabelSize.width, addressLabelSize.height);
        contactIsNilLabel.text = @"";
    }
}

- (void)setCurrentConsignee:(Consignee *)currentConsignee
{
    _currentConsignee = currentConsignee;
    // should update display here
    if (currentConsignee == nil) {
        _name.text = @"";
        _phoneNumber.text = @"";
        _address.text = @"";
        contactIsNilLabel.text = @"点击增加收货人地址信息!";
        //        intoIamgeview.image = nil;
    }
    else{
        _name.text = [NSString stringWithFormat:@"收货人:%@  %@",currentConsignee.name,currentConsignee.phoneNumber];
        //        _phoneNumber.text = currentContact.phoneNumber;
        NSString *contactAddress = [NSString stringWithFormat:@"收货地址:%@",currentConsignee.address];
        _address.text = contactAddress;
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:11.f]};
        CGSize addressLabelSize = [contactAddress boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-55, 100) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _address.frame = CGRectMake(20, 38, addressLabelSize.width, addressLabelSize.height);
        contactIsNilLabel.text = @"";
    }

}
@end
