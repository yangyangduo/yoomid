//
//  AppDelegate.m
//  private_share
//
//  Created by Zhao yang on 5/27/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "LoginViewController.h"
#import "GuideViewController.h"
#import "ViewControllerAccessor.h"
#import "UINavigationViewInitializer.h"

#import "Account.h"
#import "SecurityConfig.h"
#import "Constants.h"
#import "ShoppingCart.h"
#import "DiskCacheManager.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialData.h"
#import "UMSocialQQHandler.h"
#import "UMSocialInstagramHandler.h"
#import "UMSocialSnsService.h"
#import "alipay/AlixPayResult.h"
#import "alipay/RSA/DataVerifier.h"

#import "HomePageViewController.h"
#import "AccountService.h"

@implementation AppDelegate


//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [WXApi registerApp:@"wxb3bc53583590b23f"];
    
    [UMSocialData setAppKey:@"54052fe0fd98c5170d06988e"];
    
    [UMSocialWechatHandler setWXAppId:@"wxb3bc53583590b23f" appSecret:@"a39d046b07684bab942b68e709ae137b" url:@"http://yoomid.com"];
    [UMSocialQQHandler setQQWithAppId:@"1102346164" appKey:@"T4tsAiwGE3oZNBVf" url:@"http://yoomid.com"];
    [UMSocialQQHandler setSupportWebView:YES];

//    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    HomePageViewController *homePageViewController = [[HomePageViewController alloc] init];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homePageViewController];

    [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

//    [ViewControllerAccessor defaultAccessor].homeViewController = homeViewController;
    [ViewControllerAccessor defaultAccessor].homePageViewController = homePageViewController;

    if ([SecurityConfig defaultConfig].isFirstLogin) {
        [homePageViewController presentViewController:[[GuideViewController alloc] init] animated:NO completion:^{}];
    }
    
    [self guestLogin];
//    if ([[SecurityConfig defaultConfig].userName isEqualToString:@"guest"]) {
//        [self guestLogin];
//    }else
//    {
//        [self doAfterLogin];
//    }
    
//    return YES;
//    
//    if(![SecurityConfig defaultConfig].isLogin) {
//        UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
//        [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
//        [homePageViewController presentViewController:loginNavigationViewController animated:NO completion:^{ }];
//        if ([SecurityConfig defaultConfig].isFirstLogin) {
//                    [loginNavigationViewController presentViewController:[[GuideViewController alloc] init] animated:NO completion:^{ }];
//        }
//    } else {
//        [self doAfterLogin];
//    }

    return YES;
}

//
- (void)guestLogin{
    AccountService *accountService = [[AccountService alloc] init];
    [accountService loginWithUserName:[SecurityConfig defaultConfig].userName password:[SecurityConfig defaultConfig].passWord target:self success:@selector(loginSuccess:) failure:@selector(lofinFailure:)];
}

- (void)loginSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 201) {
        NSDictionary *result = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [self doAfterLoginWithUserName:[SecurityConfig defaultConfig].userName password:[SecurityConfig defaultConfig].passWord securityKey:[result objectForKey:@"securityKey"] isFirstLogin:[SecurityConfig defaultConfig].isFirstLogin];
        
//        [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"login_success", @"") forType:AlertViewTypeSuccess];
//        [[XXAlertView currentAlertView] delayDismissAlertView];
    
        return;
    }
    [self lofinFailure:resp];
}

- (void)lofinFailure:(HttpResponse *)resp {
    [[SecurityConfig defaultConfig] clearAuthenticationInfo];
    [[ViewControllerAccessor defaultAccessor].homePageViewController handleFailureHttpResponse:resp];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self parse:url application:application];
    BOOL result = [UMSocialSnsService handleOpenURL:url];//友盟分享
    if (result == FALSE) {
        return [WXApi handleOpenURL:url delegate:self];//微信支付
    }
    return result;
    
    
}

//有支付宝客户端 的回调
- (void)parse:(NSURL *)url application:(UIApplication *)application {
    
    //结果处理
    AlixPayResult* result = [self handleOpenURL:url];
	if (result)
    {
		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */
            
            //交易成功
            NSString* key = AlipayPubKey;
            id<DataVerifier> verifier;
            verifier = CreateRSADataVerifier(key);
        
            if ([verifier verifyString:result.resultString withSign:result.signString])
            {
                        //验证签名成功，交易结果无篡改
                [[XXAlertView currentAlertView] setMessage:@"支付成功!" forType:AlertViewTypeSuccess];
                [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaymentResult" object:result];
            }
        }
        else if (result.statusCode == 6001)
        {
            //交易失败
            [[XXAlertView currentAlertView] setMessage:@"支付被取消!" forType:AlertViewTypeSuccess];
            [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
        }
        else{
            //交易失败
            [[XXAlertView currentAlertView] setMessage:@"支付失败!" forType:AlertViewTypeSuccess];
            [[XXAlertView currentAlertView] alertForLock:YES autoDismiss:YES];
        }
    }
    else
    {
        //失败
    }

}
- (AlixPayResult *)resultFromURL:(NSURL *)url {
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#if ! __has_feature(objc_arc)
    return [[[AlixPayResult alloc] initWithString:query] autorelease];
#else
	return [[AlixPayResult alloc] initWithString:query];
#endif
}

- (AlixPayResult *)handleOpenURL:(NSURL *)url {
	AlixPayResult * result = nil;
	
	if (url != nil && [[url host] compare:@"safepay"] == 0) {
		result = [self resultFromURL:url];
	}
    
	return result;
}

//微信支付回调
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WXPaymentResult" object:resp];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Login and logout

- (void)doAfterLogin {
    if([SecurityConfig defaultConfig].isLogin) {
        [Account currentAccount].accountId = [SecurityConfig defaultConfig].userName;
        [[Account currentAccount] refresh];
        [[DiskCacheManager manager] serveForAccount:[SecurityConfig defaultConfig].userName];
    }
}

- (void)doAfterLoginWithUserName:(NSString *)userName password:(NSString *)password securityKey:(NSString *)securityKey isFirstLogin:(BOOL)isFirstLogin {
    [SecurityConfig defaultConfig].userName = userName;
    [SecurityConfig defaultConfig].securityKey = securityKey;
    [SecurityConfig defaultConfig].isFirstLogin = isFirstLogin;
    [SecurityConfig defaultConfig].passWord = password;
    [[SecurityConfig defaultConfig] saveConfig];
    [self doAfterLogin];
}

- (void)doAfterLogout {
    [self clearUserInfo];
}

- (void)clearUserInfo {
    [self clearUserInfoButShoppingCart];
    [[ShoppingCart myShoppingCart] clearMyShoppingCart];
}

- (void)clearUserInfoButShoppingCart {
    [[ShoppingCart myShoppingCart] clearContactInfo];
    [[SecurityConfig defaultConfig] clearAuthenticationInfo];
    [[Account currentAccount] clear];
}

- (BOOL)checkLogin {
    if(![SecurityConfig defaultConfig].isLogin) {
        UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
        [[ViewControllerAccessor defaultAccessor].homeViewController presentViewController:loginNavigationViewController animated:YES completion:^{ }];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark Top view controller

- (UIViewController *)topViewController {
//    return [self topViewController:[ViewControllerAccessor defaultAccessor].homeViewController];
    return [self topViewController:[ViewControllerAccessor defaultAccessor].homePageViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if(rootViewController == nil) return nil;
    
    UIViewController *controller =
        rootViewController.presentedViewController == nil ? rootViewController : rootViewController.presentedViewController;
    
    if([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationViewController = (UINavigationController *)controller;
        UIViewController *viewController = [navigationViewController.viewControllers lastObject];
        if(viewController == nil) return navigationViewController;
        return [self topViewController:viewController];
    } else if([controller isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)controller;
        if(tabBarController.selectedViewController == nil) return tabBarController;
        [self topViewController:tabBarController.selectedViewController];
    }
    
    if(controller.presentedViewController == nil) {
        return controller;
    }
    
    return [self topViewController:controller.presentedViewController];
}

@end

/*
 
 // Configure drawer view controller's defaut appearance
 [DrawerViewController defaultConfig].leftDrawerViewVisibleWidth = 235;
 [DrawerViewController defaultConfig].triggerHideLeftDrawerViewX = 175;
 [DrawerViewController defaultConfig].rightDrawerViewVisibleWidth = self.window.bounds.size.width - 44;
 
 // Center view controller
 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[HomePageViewController alloc] init]];
 [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
 
 // Left view controller
 LeftDrawerViewController *leftDrawerViewController = [[LeftDrawerViewController alloc] init];
 
 // Drawer View Controller with left and center view controller
 DrawerViewController *drawerViewController = [[DrawerViewController alloc] initWithLeftViewController:leftDrawerViewController rightViewController:[[MyPointsRecordViewController alloc] init] centerViewController:navigationController];
 
 //
 [ViewControllerAccessor defaultAccessor].drawerViewController = drawerViewController;
 
 self.window.rootViewController = drawerViewController;
 [self.window makeKeyAndVisible];
 
 */
