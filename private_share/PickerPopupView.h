//
//  PickerPopupView.h
//  private_share
//
//  Created by 曹大为 on 14-9-4.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "PopupView.h"

@protocol PickerPopupViewDelegate <NSObject>

-(void)setDate:(NSString *)date;
-(void)setProfession:(NSString *)profession;
@end

@interface PickerPopupView : PopupView<UIPickerViewDataSource,UIPickerViewDelegate>
- (id)initWithFrame:(CGRect)frame date:(NSString*)date;
- (id)initWithFrame:(CGRect)frame profession:(NSString*)profession;
@property (nonatomic,assign)id<PickerPopupViewDelegate>delegate;
@end
