//
//  LeftDrawerViewController.m
//  private_share
//
//  Created by Zhao yang on 5/30/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "LeftDrawerViewController.h"
#import "DrawerItemView.h"
#import "MallViewController.h"
#import "UINavigationViewInitializer.h"
#import "ActivitiesViewController.h"
#import "ViewControllerAccessor.h"
#import "TaskViewController.h"
#import "PortalViewController.h"
#import "UIDevice+ScreenSize.h"
#import "ShoppingCartViewController2.h"
#import "DeliveryPointViewController.h"

@interface LeftDrawerViewController ()

@end

@implementation LeftDrawerViewController {
    NSString *cellIdentifier;
    UICollectionView *itemsCollectionView;
    NSArray *items;
}

@synthesize accountLabel;
@synthesize selectedItem = _selectedItem_;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    items = @[ @"portal", @"task", @"activity", @"mall", @"mi_repo2", @"delivery_point" ];
    _selectedItem_ = [items objectAtIndex:0];
    
    self.view.backgroundColor = [UIColor appColor];
    
    CGFloat logoImageViewX = ([DrawerViewControllerConfig defaultConfig].leftDrawerViewVisibleWidth - 141.f / 2) / 2;
    CGFloat logoImageViewY = [UIDevice systemVersionIsMoreThanOrEqual7] ? 51 : 31;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(logoImageViewX, logoImageViewY, 127.f / 2, 141.f / 2)];
    logoImageView.image = [UIImage imageNamed:@"logo2"];
    [self.view addSubview:logoImageView];
    
    cellIdentifier = @"cellIdentifer";
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemsCollectionViewY = logoImageView.frame.origin.y + logoImageView.bounds.size.height + ([UIDevice is4InchDevice] ? 75 : 46);
    itemsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, itemsCollectionViewY, [DrawerViewControllerConfig defaultConfig].leftDrawerViewVisibleWidth, self.view.bounds.size.height - itemsCollectionViewY) collectionViewLayout:flowLayout];
    itemsCollectionView.backgroundColor = [UIColor clearColor];
    itemsCollectionView.delegate = self;
    itemsCollectionView.dataSource = self;
    [itemsCollectionView registerClass:[DrawerItemView class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:itemsCollectionView];
    
    [self setSelectedIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

#pragma mark -
#pragma mark collection view delegate && data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return items == nil ? 0 : items.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([DrawerViewControllerConfig defaultConfig].leftDrawerViewVisibleWidth, 44);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DrawerItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setImage:[UIImage imageNamed:[items objectAtIndex:indexPath.row]] title:NSLocalizedString([items objectAtIndex:indexPath.row], @"")];
    
    if(indexPath.row == items.count - 1) {
        [[cell viewWithTag:900] removeFromSuperview];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedItem = [items objectAtIndex:indexPath.row];
}

- (void)setSelectedItem:(NSString *)selectedItem {
    if(selectedItem == nil) return;
    if([selectedItem isEqualToString:_selectedItem_]) return;
    
    UIViewController *rootViewController;
    if([@"portal" isEqualToString:selectedItem]) {
        rootViewController = [[PortalViewController alloc] init];
    } else if([@"activity" isEqualToString:selectedItem]) {
        rootViewController = [[ActivitiesViewController alloc] init];
    } else if([@"task" isEqualToString:selectedItem]) {
        rootViewController = [[TaskViewController alloc] init];
    } else if([@"mall" isEqualToString:selectedItem]) {
        rootViewController = [[MallViewController alloc] init];
    } else if([@"mi_repo2" isEqualToString:selectedItem]) {
        rootViewController = [[ShoppingCartViewController2 alloc] init];
    } else if([@"delivery_point" isEqualToString:selectedItem]) {
        rootViewController = [[DeliveryPointViewController alloc] init];
    }
    if(rootViewController != nil) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        [UINavigationViewInitializer initialWithDefaultStyle:navigationController];
        
        if([@"portal" isEqualToString:selectedItem]) {
            [navigationController setNavigationBarHidden:YES animated:NO];
        }
        
        [ViewControllerAccessor defaultAccessor].drawerViewController.centerViewController = navigationController;
        
        NSInteger _selected_index_ = -1;
        for(int i=0; i<items.count; i++) {
            NSString *_item_ = [items objectAtIndex:i];
            if([_item_ isEqualToString:selectedItem]) {
                _selected_index_ = i;
                break;
            }
        }
        if(_selected_index_ != - 1) {
            [self setSelectedIndexPath:[NSIndexPath indexPathForItem:_selected_index_ inSection:0]];
        }
        
        _selectedItem_ = selectedItem;
    }
}

- (void)setSelectedIndexPath:(NSIndexPath *)indexPath {
    [itemsCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

@end
