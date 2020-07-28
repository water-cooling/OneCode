//
//  FGScrollSegmentView.m
//  FungusProject
//
//  Created by humengfan on 2018/6/8.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "FGScrollSegmentView.h"
#import "NSString+getWidth.h"
@interface FGScrollSegmentView()
@property(nonatomic,strong)UIScrollView * scrollview;
@property(nonatomic,strong)UIView * scrollLine;
@property(nonatomic,strong)NSArray * titleArr;
@property(nonatomic,strong)NSMutableArray * itemsWidth;
@property(nonatomic,strong)NSMutableArray * titleViews;
@property (copy, nonatomic) TitleBtnOnClickBlock titleBtnOnClick;
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,assign)NSInteger  oldIndex;


@end
@implementation FGScrollSegmentView


-(instancetype)initWithFrame:(CGRect)frame WithTitleArr:(NSArray *)Arr delegate:(id<FGScrollviewDelegate>)delegate titleDidClick:(TitleBtnOnClickBlock)titleDidClick
{
    
    if ( self = [super initWithFrame:frame]) {
        
        [self configUI];
        self.currentIndex = 0;
        self.oldIndex = 0;
        self.titleBtnOnClick = titleDidClick;
        self.titleArr = Arr;
        [self configUI];
    }
    
    return self;
    
}

-(void)configUI{
    self.backgroundColor = [UIColor whiteColor];
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UISCREENWIDTH , 40)];
    self.scrollview.backgroundColor = [UIColor clearColor];
    self.scrollview.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollview];
    [self getButtonsWidthWithTitles];
}



-(void)getButtonsWidthWithTitles{
    
    if (self.titleArr.count == 0) return;
    
    NSInteger index = 0;
    UILabel *lastlabel;
    for (NSString * str  in self.titleArr) {
        
        UIFont * titleFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
        
        CGFloat Width = [str getLabel:titleFont LabHeight:14] +2;
        NSLog(@"%@",str);
        [self.itemsWidth addObject:@(Width)];

        CGFloat LabelX =  lastlabel ? CGRectGetMaxX(lastlabel.frame) + 33: 16 ;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LabelX, 13, Width, 14)];
        label.userInteractionEnabled = YES;
        label.tag = index;
        label.font = titleFont;
        label.text = str;
        label.textColor = [UIColor colorWithHexString:@"#666666"];

        if (index == 0) {
            
            label.textColor = titleColor;
            
            self.scrollLine.frame = CGRectMake(label.x, self.height -2, label.width, 2);
            [self.scrollview addSubview:self.scrollLine];
            
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(setUpTitleView:forIndex:)]) {
            
            [self.delegate setUpTitleView:label forIndex:index];
        }
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelOnClick:)];
        
        [label addGestureRecognizer:tapGes];
        
        [self.titleViews addObject:label];
        
        [self.scrollview addSubview:label];
        
    
        index++;
        lastlabel = label;
        
    }
    
    self.scrollview.contentSize = CGSizeMake(CGRectGetMaxX(lastlabel.frame)+ 15, 0);

    
}

-(void)titleLabelOnClick:(UITapGestureRecognizer *)sender{
    
    
    UILabel *currentLabel = (UILabel *)sender.view;
    
    if (!currentLabel) {
        return;
    }
    _currentIndex = currentLabel.tag;
    
    [self adjustUIWhenBtnOnClickWithAnimate:true taped:YES];
    
}

-(void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex {
    if (oldIndex < 0 ||
        oldIndex >= self.titleArr.count ||
        currentIndex < 0 ||
        currentIndex >= self.titleArr.count
        ) {
        return;
    }
    

    _oldIndex = currentIndex;
    UILabel *oldTitleView = (UILabel *)self.titleViews[oldIndex];
    UILabel *currentTitleView = (UILabel *)self.titleViews[currentIndex];
    
    
    CGFloat xDistance = currentTitleView.x - oldTitleView.x;
    CGFloat wDistance = currentTitleView.width - oldTitleView.width;
    
    if (self.scrollLine) {
            self.scrollLine.x = oldTitleView.x + xDistance * progress;
        self.scrollLine.width = oldTitleView.width + wDistance * progress;

    }
   
    
}

- (void)adjustUIWhenBtnOnClickWithAnimate:(BOOL)animated taped:(BOOL)taped {

    if (_currentIndex == _oldIndex && taped) { return; }

    UILabel *oldlabel = (UILabel *)self.titleViews[_oldIndex];
    
    UILabel *currentlaebl = (UILabel *)self.titleViews[_currentIndex];
    
    CGFloat animatedTime = animated ? 0.30 : 0.0;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:animatedTime animations:^{
        oldlabel.textColor = titleColor;
        currentlaebl.textColor = [UIColor colorWithHexString:@"#666666"];
    
        weakSelf.scrollLine.x = currentlaebl.x;
        weakSelf.scrollLine.width = currentlaebl.width;
          
        
    } completion:^(BOOL finished) {
        
        [self adjustTitleOffSetToCurrentIndex:self.currentIndex];
    }];

    
    _oldIndex = _currentIndex;
    
    if (self.titleBtnOnClick) {
        self.titleBtnOnClick(self.titleArr[_currentIndex], self.currentIndex);
    }

}

- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex {
    
    _oldIndex = currentIndex;
    // 重置渐变/缩放效果附近其他item的缩放和颜色
    int index = 0;
    for (UILabel *titleView in self.titleViews) {
        if (index != currentIndex) {
            titleView.textColor = [UIColor colorWithHexString:@"#666666"];
            
        }
        else {
            titleView.textColor = titleColor;
        
        }
        index++;
    }
    UILabel *currentlaebl = (UILabel *)self.titleViews[currentIndex];

    CGFloat offSetx = currentlaebl.center.x - self.width * 0.5;
    NSLog(@"offSetx%f",offSetx);
    if (offSetx < 0) {
        offSetx = 0;
        
    }
    CGFloat maxOffSetX = self.scrollview.contentSize.width - self.width;
    
    if (maxOffSetX < 0) {
        maxOffSetX = 0;
    }
    
    if (offSetx > maxOffSetX) {
        offSetx = maxOffSetX;
    }
    
    [self.scrollview setContentOffset:CGPointMake(offSetx, 0.0) animated:YES];

}

-(NSMutableArray *)itemsWidth{
    if (!_itemsWidth) {
        _itemsWidth = [NSMutableArray array];
    }
    return _itemsWidth;
}

-(NSMutableArray *)titleViews{
    if (!_titleViews) {
        _titleViews = [NSMutableArray array];
    }
    return _titleViews;
}

-(UIView *)scrollLine{
    if (!_scrollLine) {
        _scrollLine = [UIView new];
        _scrollLine.backgroundColor = themeColor;
    }
    return _scrollLine;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
