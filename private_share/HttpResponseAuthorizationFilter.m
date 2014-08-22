//
//  HttpResponseAuthorizationFilter.m
//  private_share
//
//  Created by Zhao yang on 6/11/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "HttpResponseAuthorizationFilter.h"
#import "XXAlertView.h"
#import "ViewControllerAccessor.h"
#import "UINavigationViewInitializer.h"
#import "LeftDrawerViewController.h"
#import "LoginViewController.h"
#import "GlobalConfig.h"
#import "ShoppingCart.h"
#import "Account.h"
#import "AppDelegate.h"

@implementation HttpResponseAuthorizationFilter

- (BOOL)filter:(HttpFilterContext *)context {
    HttpResponse *resp = context.response;
    if(resp.statusCode == 403) {
#ifdef DEBUG
        NSLog(@"Filter: status code is 403, need refresh access token now.");
#endif
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app clearUserInfoButShoppingCart];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[XXAlertView currentAlertView] setMessage:NSLocalizedString(@"access_token_invalid", @"") forType:AlertViewTypeFailed];
            if(AlertViewStateDidAppear == [XXAlertView currentAlertView].alertViewState
               || AlertViewStateWillAppear == [XXAlertView currentAlertView].alertViewState) {
                [[XXAlertView currentAlertView] delayDismissAlertView];
            } else {
                [[XXAlertView currentAlertView] alertForLock:NO autoDismiss:YES];
            }
            
            /*
            LeftDrawerViewController *leftViewController = (LeftDrawerViewController *)[ViewControllerAccessor defaultAccessor].drawerViewController.leftViewController;
            leftViewController.selectedItem = @"activity";
             */
            
            // present login view controller
            UINavigationController *loginNavigationViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
            [UINavigationViewInitializer initialWithDefaultStyle:loginNavigationViewController];
            [[ViewControllerAccessor defaultAccessor].drawerViewController presentViewController:loginNavigationViewController animated:YES completion:^{ }];

        });
        return YES;
    }
    return YES;
}

- (NSString *)identifier {
    return @"unauthorizedResponseFilter";
}

@end
