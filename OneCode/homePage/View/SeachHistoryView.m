//
//  dada.m
//  BCNCj
//
//  Created by humengfan on 2019/8/22.
//  Copyright © 2019 humengfan. All rights reserved.
///

#import "SeachHistoryView.h"
#import "SKTagView.h"
@interface SeachHistoryView ()

@property(nonatomic,strong)SKTagView *sktag;

@property(nonatomic,strong)UILabel *label;

@property(nonatomic,strong)UIButton *deleteBtn;


@end
@implementation SeachHistoryView

-(instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self configTagView];
    }
    
    return self;
    
}

-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    
    [self.sktag removeAllTags];
    
    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 初始化标签
        SKTag *tag = [[SKTag alloc] initWithText:self.dataSource[idx]];
        // 标签相对于自己容器的上左下右的距离
        tag.padding =  UIEdgeInsetsMake(2, 2, 2, 2);
        // 弧度
        tag.cornerRadius = 5;
        // 字体
        tag.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        // 边框宽度
        tag.borderWidth = 0;
        // 背景
        tag.bgColor = [UIColor colorWithHexString:@"#F5F5F5"];
        // 字体颜色
        tag.textColor = [UIColor colorWithHexString:@"#333333"];
        // 是否可点击
        tag.enable = YES;
        // 加入到tagView
        [self.sktag addTag:tag];
    }];
    
    CGFloat tagHeight = self.sktag.intrinsicContentSize.height;
    
    self.sktag.frame = CGRectMake(15, 44, UISCREENWIDTH-30, tagHeight);
    
    NSLog(@"高度%lf",tagHeight);
    [self.sktag layoutSubviews];
    [self addSubview:self.sktag];
}

-(void)removeHistory{
    
    [self.delegate DeleteHistoryData];
    
    
}

-(void)configTagView
{
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 13)];
    self.label.textColor = [UIColor colorWithHexString:@"#333333"];
    self.label.font = [UIFont systemFontOfSize:13];
    self.label.text = @"历史搜索";
    [self addSubview:self.label];
    
    self.deleteBtn.frame = CGRectMake(UISCREENWIDTH-15-14, 15, 13, 14);
    
    [self addSubview:self.deleteBtn];
    
    
    self.sktag = [[SKTagView alloc]init];
    
    // 整个tagView对应其SuperView的上左下右距离
    
    // 上下行之间的距离
    self.sktag.lineSpacing = 10;
    // item之间的距离
    self.sktag.interitemSpacing = 15;
    // 最大宽度
    self.sktag.preferredMaxLayoutWidth = 375-30;
    //    @property (assign, nonatomic) CGFloat regularWidth; //!< 固定宽度
    //    @property (nonatomic,assign ) CGFloat regularHeight; //!< 固定高度
    // 原作者没有能加固定宽度的，自己修改源码加上了固定宽度和高度,默认是0，就是标签式布局，如果实现了，那么就是固定宽度高度
    //    self.tagView.regularWidth = 100;
    //    self.tagView.regularHeight = 30;
    // 开始加载
    
    // 点击事件回调
    __weak typeof(self)weakself = self;
    self.sktag.didTapTagAtIndex = ^(NSUInteger index, SKTagView *tagView) {
        
        
        [weakself.delegate didSelectIndexStr:weakself.dataSource[index]];
        
    };
    
    // 获取刚才加入所有tag之后的内在高度
    
    
}


- (UIButton *)deleteBtn
{
    
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        
        [_deleteBtn addTarget:self action:@selector(removeHistory) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteBtn;
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
