//
//  UINavigationViewInitializer.m
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "UINavigationViewInitializer.h"
#import "UIDevice+SystemVersion.h"
#import "UIColor+App.h"
#import "UIImage+Color.h"

@implementation UINavigationViewInitializer

+ (void)initialWithDefaultStyle:(UINavigationController *)navigationController {
    if(navigationController == nil) return;
    
    navigationController.navigationBar.translucent = NO;
    navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
    UIImage *backgroundImage = [UIImage imageWithColor:[UIColor appColor] size:
                                CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)];
    
    [navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
    if([UIDevice systemVersionIsMoreThanOrEqual7]) {
       // navigationController.navigationBar.barTintColor = [UIColor appDarkOrange];
        navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        //navigationController.navigationBar.tintColor = [UIColor appDarkOrange];0,164,229
    }
    
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName : [UIColor appLightBlue],
                                     NSFontAttributeName : [UIFont systemFontOfSize:20.f]
                                     //UITextAttributeTextShadowColor : [UIColor clearColor]
                                     };
    
    navigationController.navigationBar.titleTextAttributes = textAttributes;
}

@end
