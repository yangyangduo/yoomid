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
#import "DiskCacheManager.h"
#import "Task.h"
#import "TaskDetailViewController.h"
#import "MyPointsRecordViewController.h"
#import "YoomidRectModalView1.h"

@implementation TaskListViewController {
    UICollectionView *_collection_view_;
    NSArray *_completed_task_ids_;
    
    NSMutableArray *_tasks_;
    NSString *_cell_identifier_;
    BOOL needReloading;
}

@synthesize taskCategory = _taskCategory_;

- (instancetype)initWithTaskCategory:(TaskCategory *)taskCategory {
    self = [super init];
    if(self) {
        _cell_identifier_ = @"cellIdentifier";
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
    [_collection_view_ registerClass:[TaskItemCell class] forCellWithReuseIdentifier:_cell_identifier_];
    _collection_view_.alwaysBounceVertical = YES;
    _collection_view_.delegate = self;
    _collection_view_.dataSource = self;
    [self.view addSubview:_collection_view_];
    
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(needReloading) {
        needReloading = NO;
        if(_tasks_ != nil && _tasks_.count > 0) {
            _completed_task_ids_ = [DiskCacheManager manager].completedTaskIds;
            NSMutableArray *removeableTasks = [NSMutableArray array];
            for(Task *task in _tasks_) {
                if([self isCompletedTask:task]) {
                    [removeableTasks addObject:task];
                }
            }
            if(removeableTasks.count > 0) {
                [_tasks_ removeObjectsInArray:removeableTasks];
                [_collection_view_ reloadData];
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    needReloading = YES;
}

- (void)refresh {
    _completed_task_ids_ = [DiskCacheManager manager].completedTaskIds;
    
    [self showLoadingViewIfNeed];
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
                task.categoryId = self.taskCategory.identifier;
                if(![self isCompletedTask:task]) {
                    [_tasks_ addObject:task];
                }
            }
        }
        [_collection_view_ reloadData];
        [self hideLoadingViewIfNeed];
        
        if (_tasks_.count == 0) {
            YoomidRectModalView1 *modalView = [[YoomidRectModalView1 alloc] initWithSize:CGSizeMake(300, 360) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sad@2x" ofType:@"png"]] message:@"抱歉,暂时没有任务!" buttonTitles:@[ @"好  的" ] cancelButtonIndex:0];
            [modalView setCloseButtonHidden:YES];
            modalView.taskListVC = self;
            [modalView showInView1:self.navigationController.view completion:nil];
        }
        return;
    }
    [self showRetryView];
}

- (BOOL)isCompletedTask:(Task *)task {
    if(task == nil || task.identifier == nil) return YES;
    if(_completed_task_ids_ == nil) return NO;
    for(NSString *taskId in _completed_task_ids_) {
        if([taskId isEqualToString:task.identifier]) {
            return YES;
        }
    }
    return NO;
}

- (void)getTasksFailure:(HttpResponse *)resp {
    [self handleFailureHttpResponse:resp];
    [self showRetryView];
}

#pragma mark -

- (void)retryLoading {
    [self refresh];
}

- (CGFloat)contentViewCenterY {
    return (self.view.bounds.size.height - 64) / 2;
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
    TaskItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cell_identifier_ forIndexPath:indexPath];
    cell.task = [_tasks_ objectAtIndex:indexPath.row];
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
    if(task.locked) {
        NSMutableString *message = [NSMutableString stringWithFormat:@"哈尼\r\n要到LV%d才能解锁\r\n%@哦!", task.requiredUserLevel, task.name];
        NSString *imageName = task.isGuessPictureTask ? @"guess_pic_locked@2x" : @"survey_locked@2x";
        YoomidRectModalView *modalView = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(300, 360) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]] message:message buttonTitles:@[ @"好  的" ] cancelButtonIndex:0];
        [modalView setCloseButtonHidden:YES];
        [modalView showInView:self.navigationController.view completion:nil];
        return;
    }
    if ([task.categoryId isEqualToString:@"y:i:sc"]) {
        ShareTaskModalView *shareTaskMV = [[ShareTaskModalView alloc]initWithSize:CGSizeMake(300, 300) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guess_pic_locked@2x" ofType:@"png"]] message:[NSString stringWithFormat:@"分享给朋友立得%d米米",task.points]];
        shareTaskMV.shareDeletage = self;
        [shareTaskMV setCloseButtonHidden:YES];
        [shareTaskMV showInView1:self.navigationController.view completion:nil];
        return;
    }
    TaskDetailViewController *taskDetailViewController = [[TaskDetailViewController alloc] initWithTask:task];
    taskDetailViewController.title = self.title;
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

#pragma mrak- share delegate
- (void)showShare
{
    [self showShareTitle:@"分享" text:@"分享一下就能得米米呢，哈尼快抓紧哦~" imageName:@"icon80"];
//    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"didFinishGetUMSocialDataInViewController with response is %@",response);
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        //        response.viewControllerType
        YoomidRectModalView *modalView = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(300, 360) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guess_pic_locked@2x" ofType:@"png"]] message:@"就是爱哈尼这种爱分享的人!" buttonTitles:@[ @"确  认" ] cancelButtonIndex:0];
        [modalView setCloseButtonHidden:YES];
        [modalView showInView:self.navigationController.view completion:nil];

        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

@end
