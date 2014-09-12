
#import "TransitionViewController.h"
#import "AdPlatformPickerView.h"
#import "CategoryButtonItem.h"
#import "ImagesScrollView.h"


//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG


@interface HomeViewController : TransitionViewController<UIScrollViewDelegate, UICollectionViewDelegate, ImagesScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CategoryButtonItemDelegate, ModalViewDelegate>

@property (nonatomic, strong) NSMutableArray *allCategories;
@property (nonatomic, strong) NSMutableArray *rootCategories;

@end
