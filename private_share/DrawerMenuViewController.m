//
//  DrawerMenuViewController.m
//  private_share
//
//  Created by Zhao yang on 6/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DrawerMenuViewController.h"
#import "MerchandiseDetailViewController2.h"
#import "ViewControllerAccessor.h"
#import "ActivityDetailViewController.h"
#import "ShoppingCompleteViewController.h"
#import "PortalViewController.h"

@interface DrawerMenuViewController ()

@end

@implementation DrawerMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 59.f / 2, 59.f / 2)];
    [btnMenu addTarget:self action:@selector(showDrawerMenu:) forControlEvents:UIControlEventTouchUpInside];
    [btnMenu setBackgroundImage:[UIImage imageNamed:@"btn_menu"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnMenu];
    
    self.navigationController.delegate = self;
}

- (void)showDrawerMenu:(id)sender {
    [[ViewControllerAccessor defaultAccessor].drawerViewController showLeftView];
}

#pragma mark -
#pragma mark UINavigation controller delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if([viewController isKindOfClass:[DrawerMenuViewController class]]) {
        [[ViewControllerAccessor defaultAccessor].drawerViewController enableGestureForDrawerView];
        
        if([viewController isKindOfClass:[PortalViewController class]]) {
            [navigationController setNavigationBarHidden:YES animated:YES];
        } else {
            if(navigationController.navigationBarHidden) {
                [navigationController setNavigationBarHidden:NO animated:YES];
            }
        }
    } else {
        [[ViewControllerAccessor defaultAccessor].drawerViewController disableGestureForDrawerView];
        if([viewController isKindOfClass:[MerchandiseDetailViewController2 class]]
           || [viewController isKindOfClass:[ActivityDetailViewController class]]) {
            [navigationController setNavigationBarHidden:YES animated:YES];
        } else {
            [navigationController setNavigationBarHidden:NO animated:YES];
        }
    }
}

@end