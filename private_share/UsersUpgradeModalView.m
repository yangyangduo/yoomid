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
#import "AnswerOptions.h"
#import "YoomidRectModalView.h"
#import "AppDelegate.h"
#import "UIDevice+Identifier.h"
#import "TaskService.h"
#import "Account.h"

@implementation UsersUpgradeModalView
{
    NSMutableArray *optionsBtnArray;
    UpgradeTask *upgradeTask;
    NSString *answers;
}
//升级成功后，确认用的
- (instancetype)initWithSize1:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSMutableAttributedString *)message buttonTitles:(NSArray *)buttonTitles cancelButtonIndex:(NSInteger)cancelButtonIndex {
    self = [super initWithSize:size];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        
        if(backgroundImage) {
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
            backgroundImageView.image = backgroundImage;
            [self addSubview:backgroundImageView];
        }
        
        CGFloat centerX = size.width / 2.f;
        CGFloat y = 170.f;
        
        if(titleMessage) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 160, 30)];
            titleLabel.font = [UIFont systemFontOfSize:22];
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
        
        y += 10;
        
        if(message) {
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, 250, 35)];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.center = CGPointMake(centerX, messageLabel.center.y);
            messageLabel.attributedText = message;
            [self addSubview:messageLabel];
            
            y += messageLabel.bounds.size.height + 10.f;
        }
        
        if(buttonTitles != nil && buttonTitles.count > 0) {
            for(int i=0; i<buttonTitles.count; i++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, 90, 40)];
                button.center = CGPointMake(centerX, button.center.y);
                [button setBackgroundImage:[UIImage imageNamed:((i % 2 == 0) ? @"button_up" : @"button_down")] forState:UIControlStateNormal];
                if(i % 2 == 0) {
                    button.titleEdgeInsets = UIEdgeInsetsMake(9, 0, 0, 0);
                } else {
                    button.titleEdgeInsets = UIEdgeInsetsMake(-6, 2, 0, 0);
                }
                if(cancelButtonIndex == i) {
                    [button addTarget:self action:@selector(closeViewInternal) forControlEvents:UIControlEventTouchUpInside];
                }else
                {
                    [button addTarget:self action:@selector(Share) forControlEvents:UIControlEventTouchUpInside];
                }
                
                [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [self addSubview:button];
                y += button.bounds.size.height + 20;
            }
        }
    }
    return self;
}

//升级答题用的
- (instancetype) initWithSize:(CGSize)size backgroundImage:(UIImage *)backgroundImage titleMessage:(NSString *)titleMessage message:(NSString *)message upgradeTask:(UpgradeTask *)upgradeTasks
{
    self = [super initWithSize:size];
    if(self) {
        upgradeTask = upgradeTasks;
        
        self.backgroundColor = [UIColor clearColor];
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500/2, 761/2)];
        bgImageView.image = [UIImage imageNamed:@"bg6"];
        [self addSubview:bgImageView];
        
        CGFloat centerX = size.width / 2.f;
        CGFloat y = 160.f;
        
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
        
        y += 10;
    
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
        
        y += 10;
        UILabel *answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 240, 250, 30)];
        answerLabel.font = [UIFont systemFontOfSize:16];
        answerLabel.numberOfLines = 2;
        answerLabel.textAlignment = NSTextAlignmentCenter;
        answerLabel.textColor = [UIColor appLightBlue];
        answerLabel.text = upgradeTask.question;
        [self addSubview:answerLabel];
        
        CGFloat x = 15;
        if (optionsBtnArray == nil) {
            optionsBtnArray = [[NSMutableArray alloc]init];
        }
        for (int i = 0; i<upgradeTask.options.count; i++) {
            UIButton *optionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            optionsBtn.tag = i;
            optionsBtn.frame = CGRectMake(x, 285, 50, 35);
            AnswerOptions *upgrade = [upgradeTask.options objectAtIndex:i];
            [optionsBtn setTitle:upgrade.description forState:UIControlStateNormal];
            optionsBtn.backgroundColor = [UIColor grayColor];
            [optionsBtn.layer setMasksToBounds:YES];
            [optionsBtn.layer setCornerRadius:4.0];
            optionsBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            [optionsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [optionsBtn addTarget:self action:@selector(actionoptionsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:optionsBtn];
            [optionsBtnArray addObject:optionsBtn];
            x += 56;
        }
        
        UIButton *OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        OKBtn.frame = CGRectMake(250/2 - 90/2, 330, 90, 40);
        [OKBtn setBackgroundImage:[UIImage imageNamed:@"button_up"] forState:UIControlStateNormal];
        [OKBtn setTitle:@"确   认" forState:UIControlStateNormal];
        [OKBtn addTarget:self action:@selector(actionOKBtnClick) forControlEvents:UIControlEventTouchUpInside];
        OKBtn.titleEdgeInsets = UIEdgeInsetsMake(9, 0, 0, 0);
        [self addSubview:OKBtn];
    }
    return self;
}

-(void)actionOKBtnClick
{
    if (answers == nil) {
        [[XXAlertView currentAlertView] setMessage:@"请选择答案!" forType:AlertViewTypeFailed];
        [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
        return;
    }
    if ([answers isEqualToString:upgradeTask.answer]) {
        [self closeViewAnimated:YES completion:^{
            
            NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
            [content setMayBlankString:[SecurityConfig defaultConfig].userName forKey:@"userId"];
            [content setMayBlankString:[UIDevice idfaString] forKey:@"deviceId"];
            [content setMayBlankString:upgradeTask.categoryId forKey:@"categoryId"];
            [content setInteger:upgradeTask.points forKey:@"points"];
            [content setMayBlankString:upgradeTask.name forKey:@"name"];
            [content setMayBlankString:upgradeTask.identifier forKey:@"taskId"];
            [content setMayBlankString:upgradeTask.provider forKey:@"providerId"];

            TaskService *service = [[TaskService alloc] init];
            [service postAnswers:content target:self success:@selector(postAnswersSuccess:) failure:@selector(handleFailureHttpResponse:) taskResult:1];
            
            NSMutableAttributedString *pointsString = [[NSMutableAttributedString alloc] init];
            [pointsString appendAttributedString:[[NSAttributedString alloc] initWithString:@"额外获得 " attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName :  [UIFont systemFontOfSize:18.f] }]];
            
            [pointsString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d",upgradeTask.points] attributes:@{ NSForegroundColorAttributeName : [UIColor appLightBlue], NSFontAttributeName :  [UIFont systemFontOfSize:24.f] }]];
            
            [pointsString appendAttributedString:[[NSAttributedString alloc] initWithString:@" 米米" attributes:@{ NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName :  [UIFont systemFontOfSize:18.f] }]];
            
            //将等级写入缓存...
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//            [dictionary setInteger:[Account currentAccount].level+1 forKey:kLevelKey];
//            [defaults setObject:dictionary forKey:[Account currentAccount].accountId];
//            [defaults synchronize];
            
            UsersUpgradeModalView *successModal = [[UsersUpgradeModalView alloc]initWithSize1:CGSizeMake(500/2, 761/2) backgroundImage:[UIImage imageNamed:@"bg5"] titleMessage:@"恭喜哈尼答对了!" message:pointsString buttonTitles:@[@"确   定",@"分享好友"] cancelButtonIndex:0];
            [successModal showInView:[UIApplication sharedApplication].keyWindow completion:nil];
         
        }];
    }
    else
    {
        YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 330) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sad@2x" ofType:@"png"]] message:@"很遗憾!回答错误!" buttonTitles:@[ @"确  定" ] cancelButtonIndex:0];
        [modal showInView:[UIApplication sharedApplication].keyWindow completion:nil];

    }
}

- (void)postAnswersSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        NSInteger stat = resp.statusCode;
        
    }
}

-(void)actionoptionsBtnClick:(id)send
{
    for (int i = 0; i<optionsBtnArray.count; i++) {
        UIButton *btn = [optionsBtnArray objectAtIndex:i];
        if (((UIButton*)send).tag == btn.tag) {
            btn.backgroundColor = [UIColor appLightBlue];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else
        {
            btn.backgroundColor = [UIColor grayColor];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }

    }
    
    AnswerOptions *upgrade = [upgradeTask.options objectAtIndex:((UIButton*)send).tag];
    answers = upgrade.option;
//    NSLog(@"点击的答案:%@",upgrade.option);

}

-(void)Share
{
    [self closeViewInternal];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIViewController *topVC = [app topViewController];
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

- (void)closeViewInternal {
    [self closeViewAnimated:YES completion:nil];
}


@end
