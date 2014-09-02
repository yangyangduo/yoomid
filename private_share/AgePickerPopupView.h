//
//  AgePickerPopupView.h
//  private_share
//
//  Created by 曹大为 on 14-9-2.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "PopupView.h"
@protocol AgePickerPopupViewDelegate <NSObject>

-(void)setAge:(NSString *)age;

@end


@interface AgePickerPopupView : PopupView<UIPickerViewDataSource,UIPickerViewDelegate>

- (id)initWithFrame:(CGRect)frame age:(NSInteger)age;
@property (nonatomic,assign)id<AgePickerPopupViewDelegate>delegate;

@end
