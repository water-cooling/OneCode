//
//  LaunchIntroductionView.m
//  ZYGLaunchIntroductionDemo
//
//  Created by ZhangYunguang on 16/4/7.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "LaunchIntroductionView.h"

static NSString *const kAppVersion = @"appVersion";

@interface LaunchIntroductionView ()<UIScrollViewDelegate>
@property(nonatomic,strong)  UIScrollView  *launchScrollView;
@property(nonatomic,strong)  UIPageControl  *control;
@property(nonatomic,strong)  UIButton  *skipBtn;
@property(nonatomic,strong)  UIButton  *enterBtn;
@property(nonatomic,strong)NSTimer * timer;

@end

@implementation LaunchIntroductionView
NSArray *images;
CGRect enterBtnFrame;
NSString *enterBtnImage;
static LaunchIntroductionView *launch = nil;
NSString *storyboard;


#pragma mark - 用storyboard创建的项目时调用，带button
+ (instancetype)sharedWithStoryboard:(NSString *)storyboardName images:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame{
    images = imageNames;
    enterBtnFrame = frame;
    storyboard = storyboardName;
    enterBtnImage = buttonImageName;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    launch.backgroundColor = [UIColor whiteColor];
    
    return launch;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"currentColor" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"nomalColor" options:NSKeyValueObservingOptionNew context:nil];
        if ([self isFirstLauch]) {
            UIStoryboard *story;
            if (storyboard) {
                story = [UIStoryboard storyboardWithName:storyboard bundle:nil];
            }
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            if (story) {
                UIViewController * vc = story.instantiateInitialViewController;
                window.rootViewController = vc;
                [vc.view addSubview:self];
            }else {
                [window addSubview:self];
            }
            [self addImages];
        }else{
            [self removeFromSuperview];
        }
        
        self.skipBtn.frame = enterBtnFrame;
        
    }
    return self;
}
#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
    
}
#pragma mark - 添加引导页图片
-(void)addImages{
    
    [self createScrollView];
}

#pragma mark - 创建滚动视图
-(void)createScrollView{
    self.launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    self.launchScrollView.showsHorizontalScrollIndicator = NO;
    self.launchScrollView.bounces = NO;
    self.launchScrollView.pagingEnabled = YES;
    self.launchScrollView.delegate = self;
    self.launchScrollView.contentSize = CGSizeMake(kScreen_width * images.count, kScreen_height);
    [self addSubview: self.launchScrollView];
    for (int i = 0; i < images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreen_width, 0, kScreen_width, kScreen_height)];
        imageView.image = [UIImage imageNamed:images[i]];
        [ self.launchScrollView addSubview:imageView];
        
    }
    self.control = [[UIPageControl alloc]initWithFrame:CGRectMake((UISCREENWIDTH-43)/2, 168*iPhonescale, 43, 10)];
    self.control.numberOfPages = 3;
    self.control.currentPage = 0;
    self.control.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#3A87F7"];
    self.control.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:self.control];
    self.enterBtn.frame = CGRectMake((UISCREENWIDTH-43)/2, 168*iPhonescale, 75, 25);
    self.enterBtn.hidden = YES;
}
#pragma mark - 进入按钮
-(void)enterBtnClick{
    [self hideGuidView];
}
#pragma mark - 隐藏引导页
-(void)hideGuidView{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
        
    }];
}



#pragma mark - scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
        self.control.currentPage = cuttentIndex;
        if (cuttentIndex>2) {
            self.control.hidden = YES;
            self.enterBtn.hidden = NO;
        }else{
            self.control.hidden = NO;
            self.enterBtn.hidden = YES;
        }
    }
}
#pragma mark - 判断滚动方向
-(BOOL )isScrolltoLeft:(UIScrollView *) scrollView{
    //返回YES为向左反动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - KVO监测值的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentColor"]) {
        self.control.currentPageIndicatorTintColor = self.currentColor;
    }
    if ([keyPath isEqualToString:@"nomalColor"]) {
        self.control.pageIndicatorTintColor = self.nomalColor;
    }
}

-(UIButton *)skipBtn{
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        _skipBtn.layer.cornerRadius = 12.5;
        _skipBtn.layer.masksToBounds = YES;
        _skipBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
        [_skipBtn setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _skipBtn.titleLabel.font = [UIFont  systemFontOfSize:13];
        [self addSubview:_skipBtn];
    }
    return _skipBtn;
    
}
-(UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        _enterBtn.backgroundColor = [UIColor colorWithHexString:@"#3A87F7"];
        _enterBtn.layer.cornerRadius = 12.5;
        _enterBtn.layer.masksToBounds = YES;
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _enterBtn.titleLabel.font = [UIFont  systemFontOfSize:13];
        [self addSubview:_enterBtn];
    }
    return _enterBtn;
    
}

@end
