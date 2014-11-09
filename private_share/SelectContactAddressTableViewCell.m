//
//  SelectContactAddressTableViewCell.m
//  private_share
//
//  Created by 曹大为 on 14-8-13.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "SelectContactAddressTableViewCell.h"
#import "UIColor+App.h"

@implementation SelectContactAddressTableViewCell
{
    UILabel *nameAndPhone;
    UILabel *phoneNumber;
    UILabel *address;

    UIView *topView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        
        topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 72.5)];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        
        _selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(topView.bounds.size.width-56,topView.bounds.size.height/2-25, 50, 50)];
        [topView addSubview:_selectedImageView];
        
        nameAndPhone = [[UILabel alloc]initWithFrame:CGRectMake(23, 10, 200, 25)];
        address = [[UILabel alloc]init];
        address.font = [UIFont systemFontOfSize:11.f];
        address.textColor = [UIColor grayColor];
        address.numberOfLines = 0;//表示label可以多行显示
        address.lineBreakMode = NSLineBreakByCharWrapping;
        
        [topView addSubview:nameAndPhone];
        [topView addSubview:address];
    }
    return self;
}

-(void)setConsignee:(Consignee *)consignee
{
    if (consignee == nil) {
        return;
    }
    NSString *nameAndPhoneStr = [NSString stringWithFormat:@"%@  %@",consignee.name,consignee.phoneNumber];
    nameAndPhone.text = nameAndPhoneStr;
    
    NSMutableAttributedString *addressAttributedStr = [[NSMutableAttributedString alloc] init];
    if ([consignee.isDefault isEqualToString:@"1"]) {
        [addressAttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @"[默认]"] attributes:@{ NSForegroundColorAttributeName : [UIColor appLightBlue], NSFontAttributeName :  [UIFont systemFontOfSize:11.f] }]];
    }
    [addressAttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"收货地址:%@",consignee.address] attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName :  [UIFont systemFontOfSize:11.f] }]];
    
    
    NSString *addressStr = [NSString stringWithFormat:@"[默认]收货地址:%@",consignee.address];
    
    address.attributedText = addressAttributedStr;
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:11.f]};
    CGSize addressLabelSize = [addressStr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-70, 100) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    address.frame = CGRectMake(20, 38, addressLabelSize.width, addressLabelSize.height);
}

-(void)setContact:(Contact *)contact
{
    if (contact == nil)return;
    
    NSString *nameAndPhoneStr = [NSString stringWithFormat:@"%@  %@",contact.name,contact.phoneNumber];
    nameAndPhone.text = nameAndPhoneStr;

    NSMutableAttributedString *addressAttributedStr = [[NSMutableAttributedString alloc] init];
    if (contact.isDefault) {
        [addressAttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @"[默认]"] attributes:@{ NSForegroundColorAttributeName : [UIColor appLightBlue], NSFontAttributeName :  [UIFont systemFontOfSize:11.f] }]];
    }
    [addressAttributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"收货地址:%@",contact.address] attributes:@{ NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName :  [UIFont systemFontOfSize:11.f] }]];

    
    NSString *addressStr = [NSString stringWithFormat:@"[默认]收货地址:%@",contact.address];

    address.attributedText = addressAttributedStr;
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:11.f]};
    CGSize addressLabelSize = [addressStr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-70, 100) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    address.frame = CGRectMake(20, 38, addressLabelSize.width, addressLabelSize.height);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
