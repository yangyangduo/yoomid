//
//  SettingViewController.m
//  private_share
//
//  Created by 曹大为 on 14-9-1.
//  Copyright (c) 2014年 hentre. All rights reserved.
//

#import "SettingViewController.h"
#import "AddContactInfoViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
{
    UIImageView *perfectinformation2;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"new_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    UIImageView *perfectinformation1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 22, 345/2, 35/2)];
    perfectinformation1.image = [UIImage imageNamed:@"perfectinformation1"];
    [self.view addSubview:perfectinformation1];
    
     perfectinformation2 = [[UIImageView alloc]initWithFrame:CGRectMake(30+perfectinformation1.bounds.size.width, 32, 200/2, 162/2)];
    perfectinformation2.image = [UIImage imageNamed:@"perfectinformation2"];
//    [self.view addSubview:perfectinformation2];
//    [[UIApplication sharedApplication].delegate.window addSubview:perfectinformation2];
    [self.navigationController.navigationBar addSubview:perfectinformation2];

    UIImage *bgImage = [UIImage imageNamed:@"setupbg"];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    bgImage = [bgImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 81-12, self.view.bounds.size.width-30, 330)];
    bgImageView.image = bgImage;
    [self.view addSubview:bgImageView];
    
    UIButton *editBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, bgImageView.frame.origin.y + bgImageView.bounds.size.height, 143/2, 91/2)];
    [editBtn setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    
    UIButton *exitBtn =[[UIButton alloc]initWithFrame:CGRectMake(20, editBtn.frame.origin.y + editBtn.bounds.size.height, self.view.bounds.size.width-40, 40)];
    [exitBtn setTitle:@"退出当前账户" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [exitBtn setTintColor:[UIColor whiteColor]];
    [exitBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [exitBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 0)];
    [exitBtn addTarget:self action:@selector(exitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitBtn];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [perfectinformation2 setHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [perfectinformation2 setHidden:YES];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)editBtnClick
{
    AddContactInfoViewController *add = [[AddContactInfoViewController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}


-(void)exitBtnClick
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
