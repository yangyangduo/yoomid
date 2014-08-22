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
    
    PanAnimationController *panAnimation;
    PullScrollZoomImagesView *pullImagesView;
    NSString *cellIdentifier;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    ImageItem *i1 = [[ImageItem alloc] initWithUrl:@"http://b.hiphotos.baidu.com/image/pic/item/adaf2edda3cc7cd9b44d3f7c3b01213fb80e9136.jpg" title:nil];
    ImageItem *i2 = [[ImageItem alloc] initWithUrl:@"http://g.hiphotos.baidu.com/image/pic/item/a50f4bfbfbedab64e5a67473f536afc378311ea8.jpg" title:nil];
    pullImagesView.imageItems = [NSArray arrayWithObjects:i2, i1, nil];
    
    panAnimation = [[PanAnimationController alloc] initWithContainerController:self];
    panAnimation.leftPanAnimationType = PanAnimationControllerTypePresentation;
    panAnimation.rightPanAnimationType = PanAnimationControllerTypePresentation;
    panAnimation.delegate = self;
    
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
    
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:v animated:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    panAnimation.animationType = PanAnimationControllerTypePresentation;
    return panAnimation;
}



- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    if([animator isKindOfClass:[PanAnimationController class]]) {
        PanAnimationController *animation = (PanAnimationController *)animator;
        if(animation.isInteractive) return animation;
    }
    return nil;
}


- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if([animationController isKindOfClass:[PanAnimationController class]]) {
        PanAnimationController *animation = (PanAnimationController *)animationController;
        return animation;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    NSLog(@"jsoifjsoidfjiosdjfosjfosidjfosifj");
    if(UINavigationControllerOperationPop == operation) {
        panAnimation.animationType = PanAnimationControllerTypeDismissal;
        return panAnimation;
    }
    return nil;
}



/*



*/













- (UIViewController *)leftPresentationViewController {
    ViewQRCodeViewController *v = [[ViewQRCodeViewController alloc] init];
    v.view.backgroundColor = [UIColor purpleColor];
    return v;
}

- (CGFloat)leftPresentViewControllerOffset {
    return 150.f;
}

- (CGFloat)rightPresentViewControllerOffset {
    return 88.f;
}

- (UIViewController *)rightPresentationViewController {
    ViewQRCodeViewController *v = [[ViewQRCodeViewController alloc] init];
    v.view.backgroundColor = [UIColor purpleColor];
    return v;
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
