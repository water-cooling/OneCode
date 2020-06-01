//
//  FGContentView.m
//  FungusProject
//
//  Created by humengfan on 2018/6/8.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "FGContentView.h"
#import "UIViewController+ZJScrollPageController.h"
@interface FGContentView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
CGFloat   _oldOffSetX;
BOOL _isLoadFirstView;
NSInteger _sysVersion;
}

@property (weak, nonatomic) FGScrollSegmentView *segmentView;

@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;
// 父类 用于处理添加子控制器  使用weak避免循环引用
@property (weak, nonatomic) UIViewController *parentViewController;

// 当这个属性设置为YES的时候 就不用处理 scrollView滚动的计算
@property (assign, nonatomic) BOOL forbidTouchToAdjustPosition;

@property (assign, nonatomic) NSInteger itemsCount;

@property (strong, nonatomic) UICollectionView *collectionView;

// 所有的子控制器
@property (strong, nonatomic) NSMutableDictionary<NSString *, UIViewController<FGScrollPageViewChildVcDelegate> *> *childVcsDic;
// 当前控制器
@property (strong, nonatomic) UIViewController<FGScrollPageViewChildVcDelegate> *currentChildVc;

/// 如果类似cell缓存一样, 虽然创建的控制器少了, 但是每个页面每次都要重新加载数据, 否则显示的内容就会出错, 貌似还不如每个页面创建一个控制器好
//@property (strong, nonatomic) NSCache *cacheChildVcs;

@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger oldIndex;
// 是否需要手动管理生命周期方法的调用
@property (assign, nonatomic) BOOL needManageLifeCycle;
// 滚动超过页面(直接设置contentOffSet导致)
@property (assign, nonatomic) BOOL scrollOverOnePage;

@end


@implementation FGContentView


#define cellID @"cellID"

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame  segmentView:(FGScrollSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController delegate:(id<FGScrollviewDelegate>) delegate{

    if (self = [super initWithFrame:frame]) {
        self.segmentView = segmentView;
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        [self commonInit];
        [self addSubview:self.collectionView];
        [self addNotification];
    }
    return self;
}

- (void)commonInit {
    
    _oldIndex = -1;
    _currentIndex = 0;
    _oldOffSetX = 0.0f;
    _isLoadFirstView = YES;
    self.forbidTouchToAdjustPosition = NO;

    _sysVersion = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    if ([_delegate respondsToSelector:@selector(numberOfChildViewControllers)]) {
        self.itemsCount = [_delegate numberOfChildViewControllers];
    }
    else {
        NSAssert(NO, @"必须实现的代理方法");
    }
}

- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarningHander:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)receiveMemoryWarningHander:(NSNotificationCenter *)noti {
    
    __weak typeof(self) weakSelf = self;
    [_childVcsDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIViewController<FGScrollPageViewChildVcDelegate> * _Nonnull childVc, BOOL * _Nonnull stop) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            if (childVc != strongSelf.currentChildVc) {
                [strongSelf.childVcsDic removeObjectForKey:key];
                [FGContentView removeChildVc:childVc];
            }
        }
        
    }];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.currentChildVc) {
        self.currentChildVc.view.frame = self.bounds;
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if DEBUG
    NSLog(@"ZJContentView---销毁");
#endif
}

// 处理当前子控制器的生命周期 : 已知问题, 当push的时候会被调用两次
- (void)willMoveToWindow:(nullable UIWindow *)newWindow {
    
    [super willMoveToWindow:newWindow];
    if (newWindow == nil) {
        
        [self willDisappearWithIndex:_currentIndex];
    }
    else {
        [self willAppearWithIndex:_currentIndex];
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window == nil) {
        [self didDisappearWithIndex:_currentIndex];
    }
    else {
        [self didAppearWithIndex:_currentIndex];
    }
}

#pragma mark - public helper

- (void)contentViewDidMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    if(self.segmentView) {
        [self.segmentView adjustUIWithProgress:progress oldIndex:fromIndex currentIndex:toIndex];
    }
}
- (void)adjustSegmentTitleOffsetToCurrentIndex:(NSInteger)index {
    if(self.segmentView) {
        [self.segmentView adjustTitleOffSetToCurrentIndex:index];
    }
}

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated {
    
    NSLog(@"%f----%f",offset.x,self.collectionView.width);
    self.forbidTouchToAdjustPosition = YES;

    NSInteger currentIndex = offset.x/self.collectionView.width;

    _oldIndex = _currentIndex;
    self.currentIndex = currentIndex;
    _scrollOverOnePage = NO;
    
    NSInteger page = labs(_currentIndex-_oldIndex);
    if (page>=2) {// 需要滚动两页以上的时候, 跳过中间页的动画
        _scrollOverOnePage = YES;
    }
    
    [self.collectionView setContentOffset:offset animated:animated];
    
}

/** 给外界刷新视图的方法 */
- (void)reload {
    
    [self.childVcsDic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, UIViewController<FGScrollPageViewChildVcDelegate> * _Nonnull childVc, BOOL * _Nonnull stop) {
        [FGContentView removeChildVc:childVc];
        childVc = nil;
        
    }];
    self.childVcsDic = nil;
    [self commonInit];
    [self.collectionView reloadData];
    [self setContentOffSet:CGPointZero animated:NO];
    
}

+ (void)removeChildVc:(UIViewController *)childVc {
    [childVc willMoveToParentViewController:nil];
    [childVc.view removeFromSuperview];
    [childVc removeFromParentViewController];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.forbidTouchToAdjustPosition || // 点击标题滚动
        scrollView.contentOffset.x <= 0 || // first or last
        scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width) {
        return;
    }
    


    CGFloat tempProgress = scrollView.contentOffset.x / self.width;
    NSInteger tempIndex = tempProgress;
    
    CGFloat progress = tempProgress - floor(tempProgress);
    CGFloat deltaX = scrollView.contentOffset.x - _oldOffSetX;
    
    if (deltaX > 0) {// 向左
        if (progress == 0.0) {

            return;
        }
        self.currentIndex = tempIndex+1;
        self.oldIndex = tempIndex;
    }
    else if (deltaX < 0) {
        progress = 1.0 - progress;
        self.oldIndex = tempIndex+1;
        self.currentIndex = tempIndex;
        
    }
    else {
        return;
    }
//  NSLog(@"old ---- %ld current --- %ld", _oldIndex, _currentIndex);
    [self contentViewDidMoveFromIndex:_oldIndex toIndex:_currentIndex progress:progress];

    
    
}

/** 滚动减速完成时再更新title的位置 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 调整title
    CGFloat currentIndex = (scrollView.contentOffset.x / self.width);
    NSLog(@"currentIndex%f",scrollView.contentOffset.x/self.width);
    [self contentViewDidMoveFromIndex:currentIndex toIndex:currentIndex progress:1.0];
    [self adjustSegmentTitleOffsetToCurrentIndex:currentIndex];

    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _oldOffSetX = scrollView.contentOffset.x;
    self.forbidTouchToAdjustPosition = NO;

}

#pragma mark - private helper

- (void)willAppearWithIndex:(NSInteger)index {
    UIViewController<FGScrollPageViewChildVcDelegate> *controller = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", index]];
    if (controller) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllWillAppear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllWillAppear:controller forIndex:index];
        }
        
        if ([controller respondsToSelector:@selector(zj_viewWillAppearForIndex:)]) {
            [controller zj_viewWillAppearForIndex:index];
        }
       
        
    }
    
    
}

- (void)didAppearWithIndex:(NSInteger)index {
    
    UIViewController<FGScrollPageViewChildVcDelegate> *controller = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", index]];
    if (controller) {
        
        if (_delegate) {

            [_delegate scrollPageController:self.parentViewController childViewControllDidAppear:controller forIndex:index];
        }
        
        if ([controller respondsToSelector:@selector(zj_viewDidAppearForIndex:)]) {
            [controller zj_viewDidAppearForIndex:index];
        }
        
    }
    
}

- (void)willDisappearWithIndex:(NSInteger)index {
    UIViewController<FGScrollPageViewChildVcDelegate> *controller = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", index]];
    if (controller) {
        if ([controller respondsToSelector:@selector(zj_viewWillDisappearForIndex:)]) {
            [controller zj_viewWillDisappearForIndex:index];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllWillDisappear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllWillDisappear:controller forIndex:index];
        }
    }
    
}
- (void)didDisappearWithIndex:(NSInteger)index {
    UIViewController<FGScrollPageViewChildVcDelegate> *controller = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", index]];
    
    if (controller) {
        if ([controller respondsToSelector:@selector(zj_viewDidDisappearForIndex:)]) {
            [controller zj_viewDidDisappearForIndex:index];
        }
      
        if (_delegate && [_delegate respondsToSelector:@selector(scrollPageController:childViewControllDidDisappear:forIndex:)]) {
            [_delegate scrollPageController:self.parentViewController childViewControllDidDisappear:controller forIndex:index];
        }
    }
}

#pragma mark - UICollectionViewDelegate --- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    // 移除subviews 避免重用内容显示错误
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (_sysVersion < 8) {
        
        [self setupChildVcForCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}


- (void)setupChildVcForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (_currentIndex != indexPath.row) {
        return; // 跳过中间的多页
    }
    _currentChildVc = [self.childVcsDic valueForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    BOOL isFirstLoaded = _currentChildVc == nil;
    
    if (_delegate && [_delegate respondsToSelector:@selector(childViewController:forIndex:)]) {
        if (_currentChildVc == nil) {
            _currentChildVc = [_delegate childViewController:nil forIndex:indexPath.row];
            
            if (!_currentChildVc || ![_currentChildVc conformsToProtocol:@protocol(FGScrollPageViewChildVcDelegate)]) {
                NSAssert(NO, @"子控制器必须遵守ZJScrollPageViewChildVcDelegate协议");
            }
            // 设置当前下标
            _currentChildVc.zj_currentIndex = indexPath.row;
            [self.childVcsDic setValue:_currentChildVc forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        } else {
            [_delegate childViewController:_currentChildVc forIndex:indexPath.row];
        }
    } else {
        NSAssert(NO, @"必须设置代理和实现代理方法");
    }
    // 这里建立子控制器和父控制器的关系
    if ([_currentChildVc isKindOfClass:[UINavigationController class]]) {
        NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
    }
    if (_currentChildVc.zj_scrollViewController != self.parentViewController) {
        [self.parentViewController addChildViewController:_currentChildVc];
    }
    _currentChildVc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:_currentChildVc.view];
    [_currentChildVc didMoveToParentViewController:self.parentViewController];
    
    //    NSLog(@"当前的index:%ld", indexPath.row);
    
    if (_isLoadFirstView) { // 第一次加载cell? 不会调用endDisplayCell
        [self willAppearWithIndex:indexPath.row];
        if (isFirstLoaded) {
            // viewDidLoad
            if ([_currentChildVc respondsToSelector:@selector(zj_viewDidLoadForIndex:)]) {
                [_currentChildVc zj_viewDidLoadForIndex:indexPath.row];
            }
        }
        [self didAppearWithIndex:indexPath.row];
        
        _isLoadFirstView = NO;
    }
    else {
        
        [self willAppearWithIndex:indexPath.row];
        if (isFirstLoaded) {
            // viewDidLoad
            if ([_currentChildVc respondsToSelector:@selector(zj_viewDidLoadForIndex:)]) {
                [_currentChildVc zj_viewDidLoadForIndex:indexPath.row];
            }
        }
        [self willDisappearWithIndex:_oldIndex];
        
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"出现出现:current:---- %ld   old ----- %ld indexpathRow----%ld ", _currentIndex, _oldIndex, indexPath.row);
    if (_sysVersion >= 8) {
        [self setupChildVcForCell:cell atIndexPath:indexPath];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"消失消失:current:---- %ld   old ----- %ld indexpathRow----%ld ", _currentIndex, _oldIndex,  if (!self.forbidTouchToAdjustPosition) {
   
    if (!self.forbidTouchToAdjustPosition) {
        if (_currentIndex == indexPath.row) {// 没有滚动完成
            
            [self didAppearWithIndex:_oldIndex];
            [self didDisappearWithIndex:indexPath.row];
        }
        else {
            
            if (_oldIndex == indexPath.row) {
                // 滚动完成
                [self didAppearWithIndex:_currentIndex];
                [self didDisappearWithIndex:indexPath.row];
                
            }
            else {
                // 滚动没有完成又快速的反向打开了另一页
              
                [self didAppearWithIndex:_oldIndex];
                [self didDisappearWithIndex:indexPath.row];
            }
            
            
        }
        
    }
    else {
        
        if (_scrollOverOnePage) {
            if (labs(_currentIndex-indexPath.row) == 1) { //滚动完成
                [self didAppearWithIndex:_currentIndex];
                [self didDisappearWithIndex:_oldIndex];
            }
            
        }
        else {
            [self didDisappearWithIndex:_oldIndex];
            [self didAppearWithIndex:_currentIndex];
            
        }
        
    }
}

#pragma mark - getter --- setter

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
    }
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
        
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewLayout {
    if (_collectionViewLayout == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewLayout = layout;
    }
    
    return _collectionViewLayout;
}


- (NSMutableDictionary<NSString *,UIViewController<FGScrollPageViewChildVcDelegate> *> *)childVcsDic {
    if (!_childVcsDic) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        _childVcsDic = dic;
    }
    return _childVcsDic;
}



@end
