//
//  SettingViewController.h
//  private_share
//
//  Created by 曹大为 on 14-9-1.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "AgePickerPopupView.h"
#import "TextViewController2.h"

@interface SettingViewController : TransitionViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,AgePickerPopupViewDelegate,TextViewController2Delegate>

@end
