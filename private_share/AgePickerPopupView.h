//
//  AgePickerPopupView.h
//  private_share
//
//  Created by 曹大为 on 14-9-2.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "PopupView.h"
@protocol AgePickerPopupViewDelegate <NSObject>

-(void)setDate:(NSString *)date;

@end


@interface AgePickerPopupView : PopupView

- (id)initWithFrame:(CGRect)frame date:(NSString*)date;
@property (nonatomic,assign)id<AgePickerPopupViewDelegate>delegate;

@end
