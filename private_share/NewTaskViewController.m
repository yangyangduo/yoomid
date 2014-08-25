//
//  NewTaskViewController.m
//  private_share
//
//  Created by Zhao yang on 8/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "NewTaskViewController.h"
#import "PullScrollZoomImagesView.h"
#import "ViewQRCodeViewController.h"
#import "ActivityCollectionViewCell.h"
#import "MallViewController.h"

#import "ButtonUtil.h"

@implementation NewTaskViewController {
    UICollectionView *activitiesCollectionView;
    
    PullScrollZoomImagesView *pullImagesView;
    NSString *cellIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"hello world";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    activitiesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64) collectionViewLayout:flowLayout];
    activitiesCollectionView.backgroundColor = [UIColor clearColor];
    activitiesCollectionView.alwaysBounceVertical = YES;
    activitiesCollectionView.delegate = self;
    activitiesCollectionView.dataSource = self;
    cellIdentifier=@"cellIdentifier";
    [activitiesCollectionView registerClass:[ActivityCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:activitiesCollectionView];
    
    pullImagesView = [[PullScrollZoomImagesView alloc] initAndEmbeddedInScrollView:activitiesCollectionView];
    pullImagesView.delegate = self;
    
    ImageItem *i1 = [[ImageItem alloc] initWithUrl:@"http://pic.aigou.com/upload/shopping/2010/11/06/33304537.snap.jpg" title:nil];
    ImageItem *i2 = [[ImageItem alloc] initWithUrl:@"http://imgtest-dl.meiliworks.com/pic/_o/b1/15/5b7abb16a7861ebe0770211b69c3_1772_1485.jpg?refer_type=&expr_alt=b&frm=out_pic" title:nil];
    pullImagesView.imageItems = [NSArray arrayWithObjects:i1, i2, nil];
    

    self.animationController.leftPanAnimationType = PanAnimationControllerTypePresentation;
    self.navigationController.delegate = self;
    
//    self.navigationController.delegate = self;
    
//    panAnimation.dismissalStyle = PanAnimationControllerDismissalStyleToRight;
    
    //
    UIButton *btn = [ButtonUtil newTestButtonForTarget:self action:@selector(test)];
    [self.view addSubview:btn];
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)test {
    ViewQRCodeViewController *v = [[ViewQRCodeViewController alloc] init];
    v.modalPresentationStyle = UIModalPresentationCustom;
    self.animationController.animationType = PanAnimationControllerTypePresentation;
    [self.navigationController pushViewController:v animated:YES];
}


- (UIViewController *)rightPresentationViewController {
    ViewQRCodeViewController *v = [[ViewQRCodeViewController alloc] init];
    v.view.backgroundColor = [UIColor purpleColor];
    return v;
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if(operation == UINavigationControllerOperationPop) {
        NSLog(@"to vc : %@", [toVC description]);
        TransitionViewController *tvc = (TransitionViewController *)fromVC;
        tvc.animationController.animationType = PanAnimationControllerTypeDismissal;
        return tvc.animationController;
    } else {
        return nil;
        self.animationController.animationType = PanAnimationControllerTypePresentation;
    }
    
    NSLog(@"先  %@ .%@..  %@",[fromVC description], [toVC description] , (self.animationController.animationType == PanAnimationControllerTypeDismissal ? @"dismiss" : @"present"));
    return self.animationController;
}



- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if([animationController isKindOfClass:[PanAnimationController class]]) {
        PanAnimationController *pc = (PanAnimationController *)animationController;
        if(pc.animationType == PanAnimationControllerTypePresentation) return nil;
        return pc;
    }
    
    /*
     
     问题出在这里:
     
     
     这里不要return self.animationController,
     因为要return 第二个页面的animationController, 不能用 self.   ,  解决 !!! ~~~
     
     */
    
    
    return nil;
}













#pragma mark -
#pragma mark Table view data source and delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, 200);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ActivityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}

- (void)pullScrollZoomImagesView:(PullScrollZoomImagesView *)pullScrollZoomImagesView imagesPageIndexChangedTo:(NSUInteger)newPageIndex {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //pullImagesView.scrollViewLocked = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [pullImagesView pullScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        pullImagesView.scrollViewLocked = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pullImagesView.scrollViewLocked = NO;
}

@end
