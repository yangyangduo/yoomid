//
//  ContactDisplayView.m
//  private_share
//
//  Created by Zhao yang on 8/13/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "ContactDisplayView.h"
#import "ShoppingCart.h"

CGFloat const kContactDisplayViewHeight = 78.f;

@implementation ContactDisplayView

@synthesize currentContact = _currentContact_;

- (instancetype)initWithFrame:(CGRect)frame contact:(Contact *)contact {
    self = [self initWithFrame:frame];
    if(self) {
        self.currentContact = contact;
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(50, 8, 100, 36)];
        _name.font = [UIFont systemFontOfSize:16.f];
        _name.text = @"曹大为";
        _name.textColor = [UIColor whiteColor];
        
        _phoneNumber = [[UILabel alloc]initWithFrame:CGRectMake(_name.frame.size.width+95, 8, 100, 36)];
        _phoneNumber.font = [UIFont systemFontOfSize:15.f];
        _phoneNumber.text = @"18508411020";
        _phoneNumber.textColor = [UIColor whiteColor];
        
        NSString *str = @"湖南省长沙市开福区三一大道156号工美大厦9楼4444号单位楼去人孔了";
        NSString *str1 = @"湖南省长沙市";
//        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-80, 100) lineBreakMode:NSLineBreakByClipping];
        
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
        CGSize labelSize1 = [str1 boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-80, 100) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        _address = [[UILabel alloc]initWithFrame:CGRectMake(50, 38, labelSize1.width, labelSize1.height)];
        _address.font = [UIFont systemFontOfSize:12.f];
        _address.text = str1;
        _address.numberOfLines = 0;//表示label可以多行显示
        _address.lineBreakMode = NSLineBreakByCharWrapping;
        _address.textColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, 25, 30)];
        imageView.image = [UIImage imageNamed:@"delivery_point"];
        
        [self addSubview:imageView];
        [self addSubview:_name];
        [self addSubview:_phoneNumber];
        [self addSubview:_address];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, kContactDisplayViewHeight)];
    if(self) {
        self.backgroundColor = [UIColor colorWithRed:93.f / 255.f green:105.f / 255.f blue:134.f / 255.f alpha:1.0f];
    }
    return self;
}

- (void)setCurrentContact:(Contact *)currentContact {
    _currentContact_ = currentContact;
    // should update display here
    
    _name.text = currentContact.name;
    _phoneNumber.text = currentContact.phoneNumber;
    _address.text = currentContact.address;
//    CGSize labelSize = {0, 0};
//    labelSize = [currentContact.address sizeWithAttributes:<#(NSDictionary *)#>];
//    _address.frame = CGRectMake(50, 28, [UIScreen mainScreen].bounds.size.width-80, 50);
}

@end
