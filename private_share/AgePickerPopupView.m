//
//  AgePickerPopupView.m
//  private_share
//
//  Created by 曹大为 on 14-9-2.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "AgePickerPopupView.h"

@implementation AgePickerPopupView
{
    UIPickerView *agePickerView;
    NSMutableArray *ageArray;
    UIDatePicker *birthdayDatePicker;
}

- (id)initWithFrame:(CGRect)frame date:(NSString *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(self.bounds.size.width - 80, 0, 80, 55);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(actionDoneClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,55, self.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:228.f/255.f green:230.f/255.f blue:230/255.f alpha:1];//228 230  230
        [self addSubview:line];
        
        birthdayDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height-40)];
        birthdayDatePicker.date = [NSDate date];
        birthdayDatePicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM+8"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        birthdayDatePicker.minimumDate = [dateFormatter dateFromString:@"1900-01-01"]; // 设置最小时间
        birthdayDatePicker.maximumDate = [NSDate date]; // 设置最大时间
        birthdayDatePicker.datePickerMode = UIDatePickerModeDate;
        [birthdayDatePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [birthdayDatePicker setDate:[dateFormatter dateFromString:date]];
        [self addSubview:birthdayDatePicker];
    }
    return self;
}

-(void)actionDoneClick
{
    NSDate *selectDate = [birthdayDatePicker date];
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [selectDateFormatter stringFromDate:selectDate];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setDate:)]) {
        [self.delegate setDate:dateStr];
    }
    [self closeView];
}

#pragma mark - 实现oneDatePicker的监听方法
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
