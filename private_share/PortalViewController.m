//
//  PortalViewController.m
//  private_share
//
//  Created by Zhao yang on 7/3/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "PortalViewController.h"
#import "ViewControllerAccessor.h"
#import "MerchandiseView.h"
#import "MerchandiseOrdersViewController.h"
#import "AppDelegate.h"
#import "ProgressView.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "QRCodeScannerViewController.h"

@implementation PortalViewController {
    UIScrollView *scrollView;
    ImagesScrollView *activitiesView;
    UILabel *nickNameLabel;
    UILabel *expLabel;
    
    UILabel *nextLevelLabel;
    UILabel *currentLevelLabel;
    
    MerchandiseView *leftView;
    MerchandiseView *centerView;
    MerchandiseView *rightView;
    
    UIPageControl *pageControl;
}

- (instancetype)init {
    self = [super init];
    if(self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"home", @"");
    
    // container
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 54)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    // nav view
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)];
    topImageView.image = [UIImage imageNamed:@"black_top"];
    topImageView.userInteractionEnabled = YES;
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 25.5f, 29, 29)];
    [menuButton addTarget:self action:@selector(showDrawerView:) forControlEvents:UIControlEventTouchUpInside];
    [menuButton setImage:[UIImage imageNamed:@"btn_menu"] forState:UIControlStateNormal];
    [self.view addSubview:topImageView];
    [self.view addSubview:menuButton];
    
    UIButton *notificationsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 44, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 20 : 0), 44, 44)];
    [notificationsButton setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [self.view addSubview:notificationsButton];
    
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 88, ([UIDevice systemVersionIsMoreThanOrEqual7] ? 20 : 0), 44, 44)];
    [settingsButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(showSettingsViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsButton];
    
    // header
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -280, self.view.bounds.size.width, 280)];
    headerImageView.image = [UIImage imageNamed:@"bg2"];
   
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 105, 80, 80)];
    avatarImageView.center = CGPointMake(headerImageView.bounds.size.width / 2.f, avatarImageView.center.y);
    avatarImageView.layer.cornerRadius = avatarImageView.bounds.size.width / 2;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.borderWidth = 2.f;
    avatarImageView.layer.borderColor = [UIColor lightTextColor].CGColor;
    [avatarImageView setImageWithURL:[NSURL URLWithString:@"http://99touxiang.com/public/upload/nvsheng/162/21-060708_630.jpg"] placeholderImage:nil];
    
    nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, avatarImageView.frame.origin.y + avatarImageView.bounds.size.height + 5, 240, 30)];
    nickNameLabel.text = @"牛头人Baby";
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = [UIFont systemFontOfSize:16.f];
    
    UIView *expView = [[UIView alloc] initWithFrame:CGRectMake(0, headerImageView.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    expView.backgroundColor = [UIColor blackColor];
    expView.alpha = 0.3f;
    
    [headerImageView addSubview:nickNameLabel];
    [headerImageView addSubview:avatarImageView];
    [headerImageView addSubview:expView];
    [scrollView addSubview:headerImageView];
    
    CGPoint point = [expView convertPoint:CGPointMake(40, 14) toView:headerImageView];
    ProgressView *progressView = [[ProgressView alloc] initWithFrame:CGRectMake(point.x, point.y, 160, 16)];
    progressView.trackView.backgroundColor = [UIColor colorWithRed:34.f / 255.f green:46.f / 255.f blue:58.f / 255.f alpha:1.0f];
    progressView.backgroundView.backgroundColor = [UIColor colorWithRed:49.f / 255.f green:71.f / 255.f blue:87.f / 255.f alpha:1.0f];
    progressView.layer.cornerRadius = 8;
    [headerImageView addSubview:progressView];
    
    point = [progressView convertPoint:CGPointMake(20, 0) toView:headerImageView];
    expLabel = [[UILabel alloc] initWithFrame:CGRectMake(point.x, point.y, 120, 16)];
    expLabel.textAlignment = NSTextAlignmentCenter;
    expLabel.font = [UIFont systemFontOfSize:12.f];
    expLabel.textColor = [UIColor whiteColor];
    expLabel.text = @"1380/2200";
    [headerImageView addSubview:expLabel];
    
    currentLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, headerImageView.bounds.size.height - 37, 30, 30)];
    currentLevelLabel.textAlignment = NSTextAlignmentCenter;
    currentLevelLabel.textColor = [UIColor whiteColor];
    [headerImageView addSubview:currentLevelLabel];
    
    nextLevelLabel = [[UILabel alloc] initWithFrame:CGRectMake(203, headerImageView.bounds.size.height - 37, 30, 30)];
    nextLevelLabel.textAlignment = NSTextAlignmentCenter;
    nextLevelLabel.textColor = [UIColor whiteColor];
    [headerImageView addSubview:nextLevelLabel];
    
    
    point = [expView convertPoint:CGPointMake(260, 10) toView:headerImageView];
    UIButton *getPointsButton = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, 50, 24)];
    [getPointsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getPointsButton setTitle:NSLocalizedString(@"earn_points", @"") forState:UIControlStateNormal];
    getPointsButton.layer.borderWidth = 1.f;
    getPointsButton.layer.borderColor = [UIColor colorWithRed:34.f / 255.f green:46.f / 255.f blue:58.f / 255.f alpha:1.0f].CGColor;
    getPointsButton.layer.cornerRadius = 5;
    getPointsButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
    [headerImageView addSubview:getPointsButton];
    
    // merchandises
    
    leftView = [[MerchandiseView alloc] initWithFrame:CGRectMake(5, 15, 100, 140)];
    centerView = [[MerchandiseView alloc] initWithFrame:CGRectMake(110, 15, 100, 140)];
    rightView = [[MerchandiseView alloc] initWithFrame:CGRectMake(215, 15, 100, 140)];
    
    [scrollView addSubview:leftView];
    [scrollView addSubview:centerView];
    [scrollView addSubview:rightView];
    
    
    // activities
    activitiesView = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, leftView.frame.origin.y + leftView.bounds.size.height + 15, self.view.bounds.size.width, 200)];
    activitiesView.backgroundColor = [UIColor whiteColor];
    activitiesView.delegate = self;
    [scrollView addSubview:activitiesView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, activitiesView.frame.origin.y + activitiesView.bounds.size.height + 5, 320, 20)];
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor appBlue];
    [scrollView addSubview:pageControl];
    
    //
    scrollView.contentInset = UIEdgeInsetsMake(220, 0, 0, 0);
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 15 + 140 + 15 + 200 + 30);
    
    // bottom bar
    CGFloat itemWidth = self.view.bounds.size.width / 4.f;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 54, self.view.bounds.size.width, 54)];
    NSArray *imagesName = @[ @"my_points", @"my_activity", @"my_mall", @"invitation" ];
    for(int i=0; i<imagesName.count; i++) {
        NSString *imageName = [imagesName objectAtIndex:i];
        UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(itemWidth * i + (itemWidth - 23) / 2, 7, 23, 23)];
        imageButton.tag = i;
        [imageButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(bottomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * itemWidth, imageButton.bounds.size.height + imageButton.frame.origin.y, itemWidth, 24)];
        titleLabel.text = NSLocalizedString(imageName, @"");
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:11.f];
        titleLabel.tag = imageButton.tag;
        titleLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [titleLabel addGestureRecognizer:tapGesture];
        
        [bottomView addSubview:imageButton];
        [bottomView addSubview:titleLabel];
    }
    [self.view addSubview:bottomView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    Merchandise *m1 = [[Merchandise alloc] init];
    m1.name = @"不要钱的小包";
    m1.points = 80;
    m1.imageUrls = @[ @"http://www.shang360.com/upload/article/20130506/56753361471367828609.png" ];
    
    Merchandise *m2 = [[Merchandise alloc] init];
    m2.name = @"测试包";
    m2.points = 88888;
    m2.imageUrls = @[ @"http://www.dongjunlv.com/lv/N51108%284%29.jpg" ];
    
    Merchandise *m3 = [[Merchandise alloc] init];
    m3.name = @"Bomb!";
    m3.points = 66666;
    m3.imageUrls = @[ @"http://g.hiphotos.bdimg.com/album/w%3D2048/sign=fb339bc348540923aa69647ea660d009/bba1cd11728b4710cf90982cc2cec3fdfd032396.jpg" ];
    
    [self setMerchandises:[NSArray arrayWithObjects:m1, m2, m3, nil]];
    [self setActivities:nil];
    [self setCurrentLevel:1];
}

- (void)setMerchandises:(NSArray *)merchandises {
    for(int i=0; i<merchandises.count; i++) {
        Merchandise *merchandise = [merchandises objectAtIndex:i];
        if(i == 0) {
            leftView.merchandise = merchandise;
        } else if(i == 1) {
            centerView.merchandise = merchandise;
        } else if(i == 2) {
            rightView.merchandise = merchandise;
        } else {
            break;
        }
    }
}

- (void)setActivities:(NSArray *)activities {
    ImageItem *item1 = [[ImageItem alloc] initWithUrl:@"http://pic16.nipic.com/20110923/8162584_120855741162_2.jpg" title:@"的是解放军的搜房第三方I及"];
    ImageItem *item2 = [[ImageItem alloc] initWithUrl:@"http://pic18.nipic.com/20111224/8664093_130552550000_2.jpg" title:@"每天地覅地覅第三方是等等等"];
    ImageItem *item3 = [[ImageItem alloc] initWithUrl:@"http://pic2.nipic.com/20090331/1022855_223027009_2.jpg" title:@"是地方见第三间覅的时间放就是的"];
    ImageItem *item4 = [[ImageItem alloc] initWithUrl:@"http://pic19.nipic.com/20120216/9330945_114313510105_2.jpg" title:@"快速快速快速飞飞飞飞飞飞飞飞"];
    NSArray *items = @[ item2, item3, item1, item4 ];
    [activitiesView setImageItems:items];
    pageControl.numberOfPages = items.count;
}

- (void)setCurrentLevel:(NSUInteger)currentLevel {
    NSMutableAttributedString *currentLevelString = [[NSMutableAttributedString alloc] init];
    [currentLevelString appendAttributedString:
     [[NSAttributedString alloc] initWithString:@"V" attributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:22.f]}]];
    [currentLevelString appendAttributedString:
     [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", (unsigned long)currentLevel] attributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:14.f]}]];
    currentLevelLabel.attributedText = currentLevelString;
    
    currentLevel++;
    
    NSMutableAttributedString *nextLevelString = [[NSMutableAttributedString alloc] init];
    [nextLevelString appendAttributedString:
     [[NSAttributedString alloc] initWithString:@"V" attributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:15.f]}]];
    [nextLevelString appendAttributedString:
     [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", (unsigned long)currentLevel] attributes: @{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:12.f]}]];
    nextLevelLabel.attributedText = nextLevelString;
}

- (void)bottomButtonPressed:(UIView *)sender {
    if(sender.tag != 3) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if(![app checkLogin]) return;
    }
    
    if(sender.tag == 0) {
    } else if(sender.tag == 1) {
        
    } else if(sender.tag == 2) {
        [self.navigationController pushViewController:[[MerchandiseOrdersViewController alloc] init] animated:YES];
    } else if(sender.tag == 3) {
        
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    [self bottomButtonPressed:tapGesture.view];
}

- (void)imagesScrollView:(ImagesScrollView *)imagesScrollView imagesPageIndexChangedTo:(NSUInteger)pageIndex {
    pageControl.currentPage = pageIndex;
}

- (void)showDrawerView:(id)sender {
    [[ViewControllerAccessor defaultAccessor].drawerViewController showLeftView];
}

- (void)showSettingsViewController:(id)sender {
}

@end
