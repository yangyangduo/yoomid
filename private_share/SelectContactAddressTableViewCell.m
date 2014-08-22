//
//  SelectContactAddressTableViewCell.m
//  private_share
//
//  Created by 曹大为 on 14-8-13.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "SelectContactAddressTableViewCell.h"

@implementation SelectContactAddressTableViewCell
{
    
    UIImageView *line;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 36)];
        _phoneNumber = [[UILabel alloc]initWithFrame:CGRectMake(150, 5, 150, 36)];
        _address = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, self.bounds.size.width-40, 30)];
        line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60-1, self.bounds.size.width, 1)];
        line.image = [UIImage imageNamed:@"line"];
        _address.font =[UIFont systemFontOfSize:11.f];
        
        [self addSubview:_name];
        [self addSubview:_phoneNumber];
        [self addSubview:_address];
        [self addSubview:line];
    }
    return self;
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
