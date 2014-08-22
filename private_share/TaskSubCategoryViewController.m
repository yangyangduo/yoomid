//
//  TaskSubCategoryViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-22.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "TaskSubCategoryViewController.h"

@interface TaskSubCategoryViewController ()

@end

@implementation TaskSubCategoryViewController {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.animationController.leftPanAnimationType = PanAnimationControllerTypePresentation;
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;

}

@end
