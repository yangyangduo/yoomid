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
#import "UpgradeTask.h"
#import "AnswerOptions.h"
#import "UIDevice+Identifier.h"
#import "Account.h"

@implementation TaskListViewController {
    UICollectionView *_collection_view_;
    NSArray *_completed_task_ids_;
    
    NSMutableArray *_tasks_;
    NSString *_cell_identifier_;
    BOOL needReloading;
    
    NSString *taskIds;
    NSMutableArray *_shareTasks_;
    NSString *shareTitle;
    NSString *shareMessage;
    NSString *shareImageUrl;
    NSString *shareContentUrl;
    UpgradeTask *_upgrade;
}

@synthesize taskCategory = _taskCategory_;

- (instancetype)initWithTaskCategory:(TaskCategory *)taskCategory {
    self = [super init];
    if(self) {
        _cell_identifier_ = @"cellIdentifier";
        _taskCategory_ = taskCategory;
        _tasks_ = [NSMutableArray array];
        _shareTasks_ = [NSMutableArray array];
        shareMessage = [NSString string];
        shareTitle = [NSString string];
        shareContentUrl = [NSString string];
        shareImageUrl = [NSString string];

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
                if ([task.categoryId isEqualToString:@"y:i:gu"] || [task.categoryId isEqualToString:@"y:i:sv"]) {
                    if([self isCompletedTask:task]) {
                        [removeableTasks addObject:task];
                    }
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
    if (self.taskCategory.requiredUserLevel > [Account currentAccount].level+1) {
        NSMutableString *message = [NSMutableString stringWithFormat:@"哈尼\r\n要到LV%d才能解锁\r\n哦!", self.taskCategory.requiredUserLevel];
        NSString *imagename = nil;
        if ([self.taskCategory.identifier isEqualToString:@"y:i:gp"]) {
            imagename = @"guess_pic_locked@2x";
        }
        else if ([self.taskCategory.identifier isEqualToString:@"y:i:sv"])
        {
            imagename = @"survey_locked@2x";

        }
        else
        {
            imagename = @"game_locked@2x";
        }
        YoomidRectModalView1 *modalView = [[YoomidRectModalView1 alloc] initWithSize:CGSizeMake(300, 360) image:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imagename ofType:@"png"]] message:message buttonTitles:@[ @"好  的" ] cancelButtonIndex:0];
        [modalView setCloseButtonHidden:YES];
        modalView.taskListVC = self;
        [modalView showInView1:self.navigationController.view completion:nil];
        return;
    }

    _completed_task_ids_ = [DiskCacheManager manager].completedTaskIds;
    
    [self showLoadingViewIfNeed];
    TaskService *service = [[TaskService alloc] init];
    [service getTasksWithCategoryId:self.taskCategory.identifier target:self success:@selector(getTasksSuccess:) failure:@selector(getTasksFailure:)];
}

- (void)getTasksSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200 && resp.body) {
        [_tasks_ removeAllObjects];
        if (_shareTasks_.count > 0 && _shareTasks_ != nil) {
            [_shareTasks_ removeAllObjects];
        }
        NSArray *jsonArray = [JsonUtil createDictionaryOrArrayFromJsonData:resp.body];
        if(jsonArray != nil) {
            for(int i=0; i<jsonArray.count; i++) {
                Task *task = [[Task alloc] initWithJson:[jsonArray objectAtIndex:i]];
                task.categoryId = self.taskCategory.identifier;
                if ([task.categoryId isEqualToString:@"y:i:gu"] || [task.categoryId isEqualToString:@"y:i:sv"]) {
                    if(![self isCompletedTask:task])//做过的任务不显示到列表中去。  看图猜图、市场调研做过了，就不显示了，
                    {
                        [_tasks_ addObject:task];
                    }
                }
                else{
                    [_tasks_ addObject:task];
                }
                
                if ([task.categoryId isEqualToString:@"y:i:sc"]) {
                    UpgradeTask *shareTask_ = [[UpgradeTask alloc]initWithJson:[jsonArray objectAtIndex:i]];
                    [_shareTasks_ addObject:shareTask_];
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

- (BOOL)shareTashIsDone:(NSString *)ids
{
    BOOL isDone = YES;
    NSMutableArray *completedTaskIds = nil;
    NSArray *cacheData = [DiskCacheManager manager].completedTaskIds;
    if (cacheData == nil) {
        completedTaskIds = [NSMutableArray array];
    }
    else{
        completedTaskIds = [NSMutableArray arrayWithArray:cacheData];
    }
    
    if (completedTaskIds.count != 0) {
        for (int i = 0; i<completedTaskIds.count; i++) {
            NSString *completedTaskIdsStr = [completedTaskIds objectAtIndex:i];
            if ([taskIds isEqualToString:completedTaskIdsStr]) {
                isDone = YES;
                //分享的内容,第二次分享，没有米米
                break;
            }else
            {
                isDone = NO;
            }
        }
    }
    else
    {
        isDone = NO;
    }

    return isDone;
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
        taskIds = task.identifier;
        NSString *message = nil;
        
        _upgrade = [_shareTasks_ objectAtIndex:indexPath.row];
        shareTitle = _upgrade.question;//分享标题
        shareImageUrl = task.taskDescriptionUrl;//分享图标
        shareContentUrl = _upgrade.contentUrl;//连接
        
        AnswerOptions *answerOptions = [_upgrade.options objectAtIndex:0];  //第一次分享的内容
        AnswerOptions *answerOptions1 = [_upgrade.options objectAtIndex:1]; //第二次以后分享的内容

        if ([self shareTashIsDone:taskIds]) {//该分享任务已经做过了
            message = @"分享是种美德,立即分享!";
            shareMessage = answerOptions1.instruction;  //分享的内容,第二次分享，没有米米
        }
        else{
            message =[NSString stringWithFormat:@"分享给朋友立得%d米米",task.points];
            shareMessage = answerOptions.instruction;
        }
        
        ShareTaskModalView *shareTaskMV = [[ShareTaskModalView alloc]initWithSize:CGSizeMake(300, 300) image:[UIImage imageNamed:@"fengxiang2"] message:message];
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
    if (shareTitle != nil && shareMessage != nil) {
        [self showShareTitle:shareTitle text:shareMessage imageName:@"icon80" imageUrl:shareImageUrl contentUrl:shareContentUrl];
    }
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
        if (![self shareTashIsDone:taskIds]) {//没做过才写入缓存
            NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
            [content setMayBlankString:[SecurityConfig defaultConfig].userName forKey:@"userId"];
            [content setMayBlankString:[UIDevice idfaString] forKey:@"deviceId"];
            [content setMayBlankString:_upgrade.categoryId forKey:@"categoryId"];
            [content setInteger:_upgrade.points forKey:@"points"];
            [content setMayBlankString:_upgrade.name forKey:@"name"];
            [content setMayBlankString:_upgrade.identifier forKey:@"taskId"];
            [content setMayBlankString:_upgrade.provider forKey:@"providerId"];
            
            TaskService *service = [[TaskService alloc] init];
            [service postAnswers:content target:self success:@selector(postAnswersSuccess:) failure:@selector(handleFailureHttpResponse:) taskResult:1];
            
            NSMutableArray *completedTaskIds = nil;
            NSArray *cacheData = [DiskCacheManager manager].completedTaskIds;
            if (cacheData == nil) {
                completedTaskIds = [NSMutableArray array];
            }
            else{
                completedTaskIds = [NSMutableArray arrayWithArray:cacheData];
            }
            [completedTaskIds addObject:taskIds];
            [[DiskCacheManager manager] setCompletedTaskIds:completedTaskIds];
        }
        
        YoomidRectModalView *modalView = [[YoomidRectModalView alloc] initWithSize:CGSizeMake(300, 360) image:[UIImage imageNamed:@"images4"] message:@"就是爱哈尼这种爱分享的人!" buttonTitles:@[ @"确  认" ] cancelButtonIndex:0];
        [modalView setCloseButtonHidden:YES];
        [modalView showInView:self.navigationController.view completion:nil];

        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (void)postAnswersSuccess:(HttpResponse *)resp {
    if(resp.statusCode == 200) {
        //        NSInteger stat = resp.statusCode;
    }
}

@end
