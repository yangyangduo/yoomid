//
//  PickerPopupView.m
//  private_share
//
//  Created by 曹大为 on 14-9-4.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "PickerPopupView.h"

@implementation PickerPopupView
{
    UIPickerView *professionPickerView;
    NSMutableArray *ageArray;
    UIDatePicker *birthdayDatePicker;
    NSArray *professionArray;
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
        
        if (date != nil && ![date isEqualToString:@""]) {
            [birthdayDatePicker setDate:[dateFormatter dateFromString:date]];
        }
        [self addSubview:birthdayDatePicker];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame profession:(NSString *)profession
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        professionArray = [NSArray arrayWithObjects:@"学生",@"创业",@"私企",@"国企",@"家里蹲",@"公职人员",@"事业单位", nil];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(self.bounds.size.width - 80, 0, 80, 40);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(actionDoneClick1) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:doneBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0,40, self.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:228.f/255.f green:230.f/255.f blue:230/255.f alpha:1];
        [self addSubview:line];
        
        professionPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, self.bounds.size.width, self.bounds.size.height-40)];
        professionPickerView.delegate = self;
        professionPickerView.dataSource = self;
        [self addSubview:professionPickerView];
        
        NSInteger selected = 0;
        for (int i = 0; i<professionArray.count; i++) {
            if ([profession isEqualToString:[professionArray objectAtIndex:i]]) {
                selected = i;
                break;
            }
        }
        
        [professionPickerView selectRow:selected inComponent:0 animated:YES];
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

-(void)actionDoneClick1
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setProfession:)]) {
        [self.delegate setProfession:[professionArray objectAtIndex:[professionPickerView selectedRowInComponent:0]]];
    }
    [self closeView];
}

#pragma mark - uipickerView delegeta
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return professionArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [professionArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
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
