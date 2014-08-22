//
//  MyPointsRecordViewController.m
//  private_share
//
//  Created by 曹大为 on 14-8-20.
//  Copyright (c) 2014年 hentre. All rights reserved.
//
static CGRect oldframe;

#import "MyPointsRecordViewController.h"

@interface MyPointsRecordViewController ()

@end

@implementation MyPointsRecordViewController {
    PullTableView *pullTableView;
    UIView *topView;
    UIView *numberView;
    
    UIButton *addBtn;
    UIButton *reduceBtn;
    
    UIImageView *levelImage;
}

-(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
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
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-44, self.view.bounds.size.height/2)];
    topView.backgroundColor = [UIColor colorWithRed:28.0f / 255.0f green:33.0f / 255.0f blue:38.0f / 255.0f alpha:1.0f];
    
    [self.view addSubview:topView];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, topView.frame.size.height-50, topView.bounds.size.width/2, 50);
    addBtn.backgroundColor = [UIColor colorWithRed:44.0f / 255.0f green:55.0f / 255.0f blue:66.0f / 255.0f alpha:1.0f];
    [addBtn addTarget:self action:@selector(addPoints:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn setTitle:@" 收入" forState:UIControlStateNormal];
    
    reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceBtn.frame = CGRectMake(addBtn.bounds.size.width+1, topView.frame.size.height-50, self.view.frame.size.width/2, 50);
    reduceBtn.backgroundColor = [UIColor colorWithRed:44.0f / 255.0f green:55.0f / 255.0f blue:66.0f / 255.0f alpha:1.0f];
    [reduceBtn addTarget:self action:@selector(reducePoints:) forControlEvents:UIControlEventTouchUpInside];
    [reduceBtn setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    [reduceBtn setTitle:@" 支出" forState:UIControlStateNormal];
    
    [topView addSubview:addBtn];
    [topView addSubview:reduceBtn];
    
    numberView = [[UIView alloc]init];
    numberView.backgroundColor = [UIColor clearColor];
    [self setPoints:@"2700"];
    [topView addSubview:numberView];
    
    UIImageView *triangleImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, (topView.bounds.size.height - addBtn.bounds.size.height)/2 - 55, 19, 16)];
    triangleImage.image = [UIImage imageNamed:@"triangle"];
    [topView addSubview:triangleImage];
    
    UIImageView *mm = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-33 -44, (topView.bounds.size.height-addBtn.bounds.size.height)/2 + 20, 66, 66)];
    mm.image = [UIImage imageNamed:@"mm"];
    [topView addSubview:mm];
    
    levelImage = [[UIImageView alloc]initWithFrame:CGRectMake(topView.bounds.size.width - 70, (topView.bounds.size.height - addBtn.bounds.size.height)/2 - 28, 50, 50)];
    levelImage.image = [UIImage imageNamed:@"icon_domob"];
    
    [topView addSubview:levelImage];
    
    levelImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushContactInfo:)];
    [levelImage addGestureRecognizer:tapGesture];
    
    
    pullTableView = [[PullTableView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-topView.bounds.size.height, self.view.frame.size.width-44, self.view.bounds.size.height) style:UITableViewStylePlain];
    pullTableView.delegate = self;
    pullTableView.dataSource = self;
    pullTableView.pullDelegate = self;
    
    [self.view addSubview:pullTableView];
}

-(void)setPoints:(NSString*)numberStr
{
    for (UIView *v in [numberView subviews]) {
        [v removeFromSuperview];
    }
    for (int i = 0; i<numberStr.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *num = [numberStr substringWithRange:range];
        
        UIImageView *numberimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:num]];
        numberimage.frame = CGRectMake(i*30 + 4*i, 0, 30, 50);
        [numberView addSubview:numberimage];
    }
    numberView.frame = CGRectMake((self.view.bounds.size.width/2 - (numberStr.length*30)/2) - 44, (topView.bounds.size.height-addBtn.bounds.size.height)/2-25, numberStr.length * 30, 50);
}

- (void)pushContactInfo:(id)sender
{
    [self showImage:levelImage];//调用方法
}


-(void)addPoints:(id)sender
{
    [self setPoints:@"000"];
}

-(void)reducePoints:(id)sender
{
    [self setPoints:@"111"];
}

#pragma mark UITableView delegate mothed
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12.5f];
        cell.textLabel.text = @"2014-8-21 12:30:30 看图猜图获得200积分";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.f;
}

#pragma mark PullTableView delegate

-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    
}

-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    
}

@end
