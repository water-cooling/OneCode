//
//  LaunchIntroductionView.m
//  ZYGLaunchIntroductionDemo
//
//  Created by ZhangYunguang on 16/4/7.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "LaunchIntroductionViewController.h"

static NSString *const kAppVersion = @"appVersion";

@interface LaunchIntroductionViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)  UIScrollView  *launchScrollView;
@property(nonatomic,strong)  UIPageControl  *control;
@property(nonatomic,strong)  UIButton  *skipBtn;
@property(nonatomic,strong)  UIButton  *enterBtn;

@end

@implementation LaunchIntroductionViewController
NSArray *images;
CGRect enterBtnFrame;
NSString *enterBtnImage;
static LaunchIntroductionViewController *launch = nil;
NSString *storyboard;


#pragma mark - 用storyboard创建的项目时调用，带button
+ (instancetype)sharedWithStoryboard:(NSString *)storyboardName images:(NSArray *)imageNames {
    images = imageNames;
    storyboard = storyboardName;
    launch = [[LaunchIntroductionViewController alloc] init];
    launch.view.backgroundColor = [UIColor whiteColor];
    return launch;
}

- (void)viewDidLoad{
    [super viewDidLoad];
        [self addObserver:self forKeyPath:@"currentColor" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"nomalColor" options:NSKeyValueObservingOptionNew context:nil];
        if ([self isFirstLauch]) {
            UIStoryboard *story;
            if (storyboard) {
                story = [UIStoryboard storyboardWithName:storyboard bundle:nil];
            }
            _window = [[UIWindow alloc] init];
            _window.frame = [UIScreen mainScreen].bounds;
            _window.backgroundColor = [UIColor clearColor];
            _window.windowLevel = UIWindowLevelStatusBar;
            [_window makeKeyAndVisible];
            _window.rootViewController = self;
                [self addImages];
        }else{
            [self enterBtnClick];
        }
}




#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch{
//    //获取当前版本号
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
    self.launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
    self.launchScrollView.showsHorizontalScrollIndicator = NO;
    self.launchScrollView.bounces = NO;
    self.launchScrollView.pagingEnabled = YES;
    self.launchScrollView.delegate = self;
    self.launchScrollView.contentSize = CGSizeMake(UISCREENWIDTH * images.count, UISCREENHEIGHT);
    [self.view addSubview: self.launchScrollView];
    for (int i = 0; i < images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        imageView.image = [UIImage imageNamed:images[i]];
        [ self.launchScrollView addSubview:imageView];
        
    }
    self.control = [[UIPageControl alloc]init];
    self.control.numberOfPages = images.count;
    self.control.currentPage = 0;
    self.control.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#F2A960"];
    self.control.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:self.control];
    CGSize size = [self.control sizeForNumberOfPages:self.control.numberOfPages];
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(168);
        make.size.mas_equalTo(size);
    }];
    [self.view addSubview:self.skipBtn];
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                           make.right.equalTo(self.view).offset(-20);
                           make.top.equalTo(self.view).offset(SafeAreaTopHeight-30);
                           make.size.mas_equalTo(CGSizeMake(40, 20));
               }];
}
#pragma mark - 进入按钮
-(void)enterBtnClick{
    _window.hidden = YES;
    _window = nil;
    images = nil;
}

#pragma mark - scrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + UISCREENWIDTH/2)/UISCREENWIDTH;
        self.control.currentPage = cuttentIndex;
        if (images.count == cuttentIndex+1){
            self.control.hidden = YES;
             self.enterBtn.hidden = NO;
        }else{
            self.control.hidden = NO;
            self.enterBtn.hidden = YES;
        }
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
        _skipBtn.layer.cornerRadius = 10;
        _skipBtn.titleLabel.font = [UIFont  systemFontOfSize:11];
        _skipBtn.layer.masksToBounds = YES;
        _skipBtn.layer.borderWidth = 1;
        _skipBtn.layer.borderColor = [UIColor colorWithHexString:@"#EFF3FC"].CGColor;
        [_skipBtn setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
        [_skipBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _skipBtn;
    
}
-(UIButton *)enterBtn{
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        _enterBtn.hidden = YES;
        _enterBtn.backgroundColor = [UIColor colorWithHexString:@"#3A87F7"];
        _enterBtn.layer.cornerRadius = 12.5;
        _enterBtn.layer.masksToBounds = YES;
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _enterBtn.titleLabel.font = [UIFont  systemFontOfSize:13];
        [self.view addSubview:_enterBtn];
        [_enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(168);
            make.size.mas_equalTo(CGSizeMake(75, 25));
        }];
    }
    return _enterBtn;
    
}
@end
