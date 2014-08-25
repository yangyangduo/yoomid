//
//  NewTaskViewController.h
//  private_share
//
//  Created by Zhao yang on 8/15/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullScrollZoomImagesView.h"
#import "TransitionViewController.h"

@interface NewTaskViewController : TransitionViewController<
                UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PullScrollZoomImagesViewDelegate,
                UINavigationControllerDelegate>


@end
