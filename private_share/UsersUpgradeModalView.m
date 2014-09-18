//
//  UsersUpgradeModalView.m
//  private_share
//
//  Created by 曹大为 on 14-9-17.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "UsersUpgradeModalView.h"
#import "UIColor+App.h"
#import "TaskLevelService.h"
#import "XXAlertView.h"
#import "NSDictionary+Extension.h"
#import "UpgradeTask.h"

@implementation UsersUpgradeModalView

- (instancetype) initWithSize:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSString *)message
{
    self = [super initWithSize:size];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500/2, 761/2)];
        bgImageView.image = [UIImage imageNamed:@"bg6"];
        [self addSubview:bgImageView];
        
        CGFloat centerX = size.width / 2.f;
        CGFloat y = 170.f;
        
        if (titleMessage) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 250, 30)];
            titleLabel.font = [UIFont systemFontOfSize:20];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.center = CGPointMake(centerX, titleLabel.center.y);
            titleLabel.textColor = [UIColor appLightBlue];
            titleLabel.text = titleMessage;
            [self addSubview:titleLabel];
            
            y += titleLabel.bounds.size.height + 10.f;
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, 220, 1)];
        lineView.center = CGPointMake(centerX, lineView.center.y);
        lineView.backgroundColor = [UIColor colorWithRed:230.f / 255.f green:230.f / 255 blue:230.f / 255 alpha:1.0];
        [self addSubview:lineView];
        
        y += 15;
        
        if (message) {
            UIFont *messageFont = [UIFont systemFontOfSize:14.f];
            
            CGSize messageSize = [message boundingRectWithSize:CGSizeMake(size.width - 40, 100) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{ NSFontAttributeName : messageFont } context:nil].size;
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, messageSize.width, messageSize.height)];
            messageLabel.font = messageFont;
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.center = CGPointMake(centerX, messageLabel.center.y);
            messageLabel.textColor = [UIColor appTextFieldGray];
            messageLabel.text = message;
            [self addSubview:messageLabel];
        }
        
        y += 15;
        
        [self getTaskLevel];
    }
    return self;
}

- (void)getTaskLevel
{
    TaskLevelService *taskLevelService = [[TaskLevelService alloc]init];
    [taskLevelService getTasksLevelInfo:self success:@selector(getTaskLevelSuccess:) failure:@selector(handleFailureHttpResponse:)];
}

- (void)getTaskLevelSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 200 && resp.body != nil) {
        NSDictionary *jsonD = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];

//        NSMutableArray *taskLevelArray = [NSMutableArray array];
        UpgradeTask *upgradeTask = nil;
        if (jsonD != nil) {
//            [taskLevelArray addObject:[[UpgradeTask alloc]initWithJson:jsonD]];
            upgradeTask =[[UpgradeTask alloc]initWithJson:jsonD];
        }
    }
}

- (void)handleFailureHttpResponse:(HttpResponse *)resp {
    if(1001 == resp.statusCode) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
        return;
    } else if(400 == resp.statusCode) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"bad_request", @"") forType:AlertViewTypeFailed];
        return;
    } else if(403 == resp.statusCode) {
    } else if(500 == resp.statusCode) {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"server_error", @"") forType:AlertViewTypeFailed];
        return;
    } else {
        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"network_error", @"") forType:AlertViewTypeFailed];
        return;
    }

}

@end
