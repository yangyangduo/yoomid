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
    
    UILabel *name;
    UILabel *phoneNumber;
    UILabel *address;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        name = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 25)];
        [name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        phoneNumber = [[UILabel alloc]initWithFrame:CGRectMake(180, 10, 150, 25)];
        address = [[UILabel alloc]init];
        address.font = [UIFont systemFontOfSize:12.f];
        address.textColor = [UIColor grayColor];
        address.numberOfLines = 0;//表示label可以多行显示
        address.lineBreakMode = NSLineBreakByCharWrapping;

        line = [[UIImageView alloc]init];
        line.image = [UIImage imageNamed:@"line"];
        address.font =[UIFont systemFontOfSize:11.f];
        
        [self addSubview:name];
        [self addSubview:phoneNumber];
        [self addSubview:address];
        [self addSubview:line];
    }
    return self;
}

-(void)setRowData:(NSDictionary *)rowData
{
    if (rowData == nil)return;
    name.text = [rowData objectForKey:@"name"];
    phoneNumber.text = [rowData objectForKey:@"contactPhone"];
    address.text = [rowData objectForKey:@"deliveryAddress"];
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12.f]};
    CGSize addressLabelSize = [[rowData objectForKey:@"deliveryAddress"] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-42, 100) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    address.frame = CGRectMake(20, 35, addressLabelSize.width, addressLabelSize.height);
    line.frame = CGRectMake(0, (35+addressLabelSize.height+15)-0.5, self.bounds.size.width, 0.5);

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
