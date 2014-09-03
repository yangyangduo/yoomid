//
//  TaskListViewController.m
//  private_share
//
//  Created by Zhao yang on 9/2/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskItemCell.h"
#import "TaskService.h"
#import "Task.h"
#import "TaskDetailViewController.h"
#import "MyPointsRecordViewController.h"

@implementation TaskListViewController {
    UICollectionView *_collection_view_;
    
    NSMutableArray *_tasks_;
}

@synthesize taskCategory = _taskCategory_;

- (instancetype)initWithTaskCategory:(TaskCategory *)taskCategory {
    self = [super init];
    if(self) {
        _taskCategory_ = taskCategory;
        _tasks_ = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animationController.leftPanAnimationType = PanAnimationControllerTypePresentation;
    
    if(self.taskCategory != nil && self.taskCategory.displayName != nil) {
        self.title = self.taskCategory.displayName;
    }
    
    self.animationController.rightPanAnimationType = PanAnimationControllerTypeDismissal;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"new_back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collection_view_ = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - ([UIDevice systemVersionIsMoreThanOrEqual7] ? 64 : 44)) collectionViewLayout:layout];
    _collection_view_.backgroundColor = [UIColor clearColor];
    [_collection_view_ registerClass:[TaskItemCell class] forCellWithReuseIdentifier:@"f"];
    _collection_view_.alwaysBounceVertical = YES;
    _collection_view_.delegate = self;
    _collection_view_.dataSource = self;
    [self.view addSubview:_collection_view_];
    
    [self refresh];
}

- (void)refresh {
    TaskService *service = [[TaskService alloc] init];
    [service getTasksWithCategoryId:self.taskCategory.identifier target:self success:@selector(getTasksSuccess:) failure:@selector(getTasksFailure:)];
}

- (void)getTasksSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200 && resp.body) {
        [_tasks_ removeAllObjects];
        
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                Task *task = [[Task alloc] initWithJson:[jsonArray objectAtIndex:i]];
                [_tasks_ addObject:task];
            }
        }
        
        [_collection_view_ reloadData];
    }
}

- (void)getTasksFailure:(HttpResponse *)resp {
    [self handleFailureHttpResponse:resp];
}

#pragma mark -
#pragma mark Collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tasks_.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"f" forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [_tasks_ objectAtIndex:indexPath.row];
    
    NSString *url = [NSString stringWithFormat:@"%@/yoomid/task?categoryId=%@&taskId=%@&%@", kBaseUrl, self.taskCategory.identifier, task.identifier, [BaseService authString]];
#ifdef DEBUG
    NSLog(@"Task url is [%@]", url);
#endif
    TaskDetailViewController *taskDetailViewController = [[TaskDetailViewController alloc] initWithTaskDetailUrl:url];
    [self.navigationController pushViewController:taskDetailViewController animated:YES];
}

- (void)dismissViewController {
    [self rightDismissViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Pan animation controller delegate

- (UIViewController *)rightPresentationViewController {
    return [[MyPointsRecordViewController alloc] init];
}

- (CGFloat)rightPresentViewControllerOffset {
    return 88.f;
}

@end
