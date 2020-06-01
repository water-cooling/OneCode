//
//  OneCodeDefine.h
//  OneCode
//
//  Created by humengfan on 2020/6/1.
//  Copyright © 2020 humengfan. All rights reserved.
//

#ifndef OneCodeDefine_h
#define OneCodeDefine_h
#ifdef DEBUG //开发阶段

#define NSLog(format,...) printf("%s\n",[[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])


#else //发布阶段

#define NSLog(...)

#endif



#define UISCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define UISCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define MapOffset [UIScreen mainScreen].bounds.size.width - 50

#define  kNUMBER_OF_LOCATIONS  10//模拟地图的数据

#define kFIRST_LOCATIONS_TO_REMOVE 50

#define kDevice_Is_iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusBigMode ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen]currentMode].size) : NO)

#define APPid @"470898664970125312"
#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Searchhistories.plist"]

#define phoneVersion [[UIDevice currentDevice] systemVersion]

#define HeadDefault [UIImage imageNamed:@"头像"]

#define bihucjUrl @"http://www.aganyun.com/cx.otenda/"
#define bihutest @"http://otenda.project.njagan.org/cx.otenda/"


#define kDevice_iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


//适配参数

#define SafeAreaTopHeight (kDevice_iPhoneX ? 88 : 64)

//适配参数


#define iPhonescale (kDevice_Is_iPhone6Plus ?1.12:(kDevice_Is_iPhone6?1.0:(iPhone6PlusBigMode ?1.01:0.85))) //以6为基准图
#define BackgroundColor [UIColor colorWithHexString:@"#F5F5F5"]

#define userdocPath  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.plist"]


#define titleColor [UIColor colorWithHexString:@"#1A1A1A"]

#define themeColor [UIColor colorWithHexString:@"#3987F7"]

#define LoginOut  @"FungusLoginOut"
#define LoginIn  @"FungusLoginIn"
#define  PriceChange  @"FungusPriceChange"
#define  OrderCountChange  @"FungusOrderCountChange"


#define buttonSelectBackgroundColor [UIColor colorWithHexString:@"#F98040"]
#define buttonSelectTitleColor [UIColor colorWithHexString:@"#FFFFFF"]

#endif /* OneCodeDefine_h */
