//
//  SettingViewController.h
//  private_share
//
//  Created by 曹大为 on 14-9-1.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TransitionViewController.h"
#import "TextViewController2.h"
#import "PickerPopupView.h"

@interface SettingViewController : TransitionViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,TextViewController2Delegate,PickerPopupViewDelegate>

@end
