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
}

- (id)initWithFrame:(CGRect)frame age:(NSInteger)age
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        ageArray = [[NSMutableArray alloc]init];
        for (int i = 1; i<=100; i++) {
            NSString *ageStr = [NSString stringWithFormat:@"%d",i];
            [ageArray addObject:ageStr];
        }
        agePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        agePickerView.dataSource = self;
        agePickerView.delegate = self;
        [agePickerView selectRow:age-1 inComponent:0 animated:NO];
        
        [self addSubview:agePickerView];
    }
    return self;
}

#pragma mark- uipickerview delegeta 
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ageArray.count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [ageArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(setAge:)]) {
        [self.delegate setAge:[ageArray objectAtIndex:row]];
    }
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
