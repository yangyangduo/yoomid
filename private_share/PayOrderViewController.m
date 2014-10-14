//
//  PayOrderViewController.m
//  private_share
//
//  Created by 曹大为 on 14/10/14.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "PayOrderViewController.h"
#import "UIDevice+ScreenSize.h"
#import "YoomidRectModalView.h"
#import "ReturnMessage.h"
#import "XXAlertView.h"
#import "MerchandiseService.h"
#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "alipay/AlixLibService.h"

@interface PayOrderViewController ()

@end

@implementation PayOrderViewController
{
    UIScrollView *scrollView_;
    
    UILabel *orderLabel;
    UILabel *mallLabel;
    UILabel *merchandiseLabel;
    UILabel *cashLabel;
}

@synthesize aliPayment = _aliPayment;
@synthesize wxPayment = _wxPayment;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"支付订单";
    
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"new_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    scrollView_.alwaysBounceVertical = YES;
    scrollView_.contentSize = CGSizeMake(scrollView_.bounds.size.width, 0);
    scrollView_.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollView_];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 180, 40)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"以下是支付的详细信息:";
    [scrollView_ addSubview:label];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(180, 3, 200/2, 162/2)];
    imageView.image = [UIImage imageNamed:@"perfectinformation2"];
    [scrollView_ addSubview:imageView];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(320/2-250/2, 84, 501/2, 501/2)];
    imageView2.image = [UIImage imageNamed:@"levelbg"];
    [scrollView_ addSubview:imageView2];
    
    orderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, imageView2.bounds.size.width-10, 50)];
    orderLabel.textAlignment = NSTextAlignmentLeft;
    orderLabel.font = [UIFont systemFontOfSize:16];
    [imageView2 addSubview:orderLabel];

    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0,50, imageView2.bounds.size.width, 0.8f)];
    line1.backgroundColor = [UIColor colorWithRed:228.f/255.f green:230.f/255.f blue:230/255.f alpha:1];
    [imageView2 addSubview:line1];
    
    mallLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 51, imageView2.bounds.size.width-10, 50)];
    mallLabel.textAlignment = NSTextAlignmentLeft;
    mallLabel.font = [UIFont systemFontOfSize:16];
    [imageView2 addSubview:mallLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0,101, imageView2.bounds.size.width, 0.8f)];
    line2.backgroundColor = [UIColor colorWithRed:228.f/255.f green:230.f/255.f blue:230/255.f alpha:1];//228 230  230
    [imageView2 addSubview:line2];

    merchandiseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 102, imageView2.bounds.size.width-10, 80)];
    merchandiseLabel.textAlignment = NSTextAlignmentLeft;
    merchandiseLabel.numberOfLines = 3;
    merchandiseLabel.font = [UIFont systemFontOfSize:16];
    [imageView2 addSubview:merchandiseLabel];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0,182, imageView2.bounds.size.width, 0.8f)];
    line3.backgroundColor = [UIColor colorWithRed:228.f/255.f green:230.f/255.f blue:230/255.f alpha:1];//228 230  230
    [imageView2 addSubview:line3];
    
    cashLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 183, imageView2.bounds.size.width-10, 40)];
    cashLabel.textAlignment = NSTextAlignmentLeft;
    cashLabel.font = [UIFont systemFontOfSize:16];
    [imageView2 addSubview:cashLabel];

    UIButton *payBtn =[[UIButton alloc]initWithFrame:CGRectMake(20, [UIDevice is4InchDevice] ? self.view.bounds.size.height - 140 : 125, scrollView_.bounds.size.width-40, 40)];
    [payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [payBtn setTintColor:[UIColor whiteColor]];
    [payBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [payBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [payBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView_ addSubview:payBtn];
    
    [self setPaymen];

}

- (void)setPaymen
{
    if (self.paymentMode == PaymentModeWXPay) {
        if (_wxPayment == nil) {
            return;
        }
        orderLabel.text = [NSString stringWithFormat:@"单号: %@", _wxPayment.out_trade_no];
        mallLabel.text = [NSString stringWithFormat:@"商城: %@",_wxPayment.mallName];
        merchandiseLabel.text = [NSString stringWithFormat:@"商品: %@",_wxPayment.merchandiseName];
        float cashF = [_wxPayment.total_fee floatValue];
        cashLabel.text = [NSString stringWithFormat:@"现金: %.2f元",cashF /= 100];

    }else if (self.paymentMode == PaymentModeAliPay){
        if (_aliPayment == nil) {
            return;
        }
        orderLabel.text = [NSString stringWithFormat:@"单号: %@", _aliPayment.out_trade_no];
        mallLabel.text = [NSString stringWithFormat:@"商城: %@",_aliPayment.subject];
        merchandiseLabel.text = [NSString stringWithFormat:@"商品: %@",_aliPayment.body];
        cashLabel.text = [NSString stringWithFormat:@"现金: %@元",_aliPayment.total_fee];
    }
}

- (void)payBtnClick{
    if (self.paymentMode == PaymentModeWXPay) {
        
        NSMutableDictionary *tempD = [[NSMutableDictionary alloc] initWithDictionary:[_wxPayment toJson]];
        [[XXAlertView currentAlertView] setMessage:@"正在打开微信支付..." forType:AlertViewTypeWaitting];
        [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:NO];
        
        MerchandiseService *service = [[MerchandiseService alloc] init];
        [service submitPayRequestBody:[JsonUtil createJsonDataFromDictionary:tempD] target:self success:@selector(submitWXPayRequestSuccess:) failure:@selector(submitFailure:) userInfo:nil];

    }else if (self.paymentMode == PaymentModeAliPay){
        NSDictionary *tempD = @{@"info": [_aliPayment toStrings]};
        
        MerchandiseService *service = [[MerchandiseService alloc] init];
        [service submitAliPaySign:[JsonUtil createJsonDataFromDictionary:tempD] target:self success:@selector(submitAliPaySignSuccess:) failure:@selector(submitFailure:) userInfo:nil];
    }

}

//支付宝支付 请求 -------------------------------------
- (void)submitAliPaySignSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 201) {
        NSDictionary *sign_json_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        _aliPayment.sign = [sign_json_ objectForKey:@"sign"];
        
        NSMutableString * signStr = [NSMutableString string];
        [signStr appendString:[_aliPayment toStrings]];
        [signStr appendFormat:@"&sign=\"%@\"", _aliPayment.sign ? _aliPayment.sign : @""];
        [signStr appendFormat:@"&sign_type=\"%@\"", @"RSA"];
        
        [AlixLibService payOrder:signStr AndScheme:@"YoomidAliPay" seletor:@selector(paymentResult:) target:self];
        return;
    }
    [self submitFailure:resp];
}

-(void)paymentResult:(NSString *)resultd{
}
//-----------------------------------------------------

//微信支付 请求***********************************
- (void)submitWXPayRequestSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {
        NSDictionary *access_token_json = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if (access_token_json != nil) {
            [_wxPayment setAccess_tokens:access_token_json];
        }
        
        NSMutableDictionary *paramsD = [NSMutableDictionary dictionary];
        [paramsD setObject:_wxPayment.wxAppId forKey:@"appid"];
        [paramsD setObject:_wxPayment.noncestr forKey:@"noncestr"];
        [paramsD setObject:_wxPayment.timestamp forKey:@"timestamp"];
        [paramsD setObject:_wxPayment.traceid forKey:@"traceid"];
        [paramsD setObject:_wxPayment.package_content forKey:@"package"];
        [paramsD setObject:_wxPayment.app_signature forKey:@"app_signature"];
        [paramsD setObject:@"sha1" forKey:@"sign_method"];
        //        NSLog(@"%@",paramsD);
        
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsD options:NSJSONWritingPrettyPrinted error: &error];
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSString *urlStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@",_wxPayment.access_token];
        
        NSMutableURLRequest *mrequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
        
        //设置提交方式
        [mrequest setHTTPMethod:@"POST"];
        //设置数据类型
        [mrequest addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
        //设置编码
        [mrequest setValue:@"UTF-8" forHTTPHeaderField:@"charset"];
        
        [mrequest setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:mrequest];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *prepayid_json = [JsonUtil createDictionaryOrArrayFromJsonData:responseObject];
            long errCode = [[prepayid_json objectForKey:@"errcode"] longValue];
            if (errCode == 0) {
                NSLog(@"JSON: %@", prepayid_json);
                _wxPayment.prepayid = [prepayid_json objectForKey:@"prepayid"];
                NSLog(@"prepay ID:%@",_wxPayment.prepayid);
                
                NSDictionary *paySignDict = @{@"prepayid": _wxPayment.prepayid,
                                              @"package": @"Sign=WXPay",
                                              @"noncestr": _wxPayment.noncestr,
                                              @"timestamp": _wxPayment.timestamp
                                              };
                
                MerchandiseService *service = [[MerchandiseService alloc] init];
                [service submitWXPaySign:[JsonUtil createJsonDataFromDictionary:paySignDict] target:self success:@selector(submitWXPaySignSuccess:) failure:@selector(submitFailure:) userInfo:nil];
            }else{
                [[XXAlertView currentAlertView] setMessage:@"打开微信支付失败!" forType:AlertViewTypeFailed];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[XXAlertView currentAlertView] setMessage:@"打开微信支付错误!" forType:AlertViewTypeFailed];
            [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
            NSLog(@"Error: %@", error);
        }];
        [operation start];
        
        return;
    }
    [self submitFailure:resp];
}

- (void)submitWXPaySignSuccess:(HttpResponse *)resp {
    if (resp.statusCode == 201) {
        [[XXAlertView currentAlertView] dismissAlertView];
        NSDictionary *sign_json = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        NSLog(@"JSON: %@", sign_json);
        
        _wxPayment.sign = [sign_json objectForKey:@"sign"];
        
        PayReq *payRequest = [[PayReq alloc] init];
        payRequest.partnerId = @"1220874801";
        payRequest.prepayId = _wxPayment.prepayid;
        payRequest.package = @"Sign=WXPay";
        payRequest.nonceStr = _wxPayment.noncestr;
        payRequest.timeStamp = (UInt32)[_wxPayment.timestamp longLongValue];
        payRequest.sign = _wxPayment.sign;
        
        [WXApi safeSendReq:payRequest];
        return;
    }
    [self submitFailure:resp];
}
// *********************************



- (void)submitFailure:(HttpResponse *)resp {
    NSString *errorMessage = @"出错啦!";
    if(1001 == resp.statusCode) {
        errorMessage = @"请求超时!";
    } else if(400 == resp.statusCode) {
        if(resp.contentType != nil && resp.body != nil && [resp.contentType rangeOfString:@"application/json" options:NSCaseInsensitiveSearch].location != NSNotFound) {
            NSDictionary *_json_ = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
            if(_json_ != nil) {
                ReturnMessage *message = [[ReturnMessage alloc] initWithJson:_json_];
                errorMessage = [NSString stringWithFormat:@"对不起,%@!", message.message];
            }
        }
    } else if(403 == resp.statusCode) {
        errorMessage = @"请重新登录后再尝试!";
    } else {
        errorMessage = @"出错啦!";
    }
    [[XXAlertView currentAlertView] dismissAlertViewCompletion:^{
        YoomidRectModalView *modal = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(280, 340) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cry@2x" ofType:@"png"]] message:errorMessage buttonTitles:@[ @"支付失败" ] cancelButtonIndex:0];

        [modal showInView:self.navigationController.view completion:nil];
    }];
}


- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

@end
