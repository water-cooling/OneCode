//
//  OwnViewController.m
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "OwnViewController.h"
#import "AppDelegate.h"
#import "UIImage+DrawImage.h"
#import "UpImgUntility.h"
#import "SignUntility.h"
#import "UserUtility.h"
#import <TZImagePickerController.h>
#import "MySweetTableViewController.h"
#import "SignViewController.h"
#import "OwnShareViewController.h"

@interface OwnViewController ()<UITableViewDelegate,TZImagePickerControllerDelegate,shareLinkResultDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *HeadImg;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLab;
@property (weak, nonatomic) IBOutlet UILabel *CellIphone;
@property(nonatomic,strong)NSMutableArray * stateArr;
@property (weak, nonatomic) IBOutlet UILabel *todayLab;
@property (weak, nonatomic) IBOutlet UIView *MySweetView;
@property (weak, nonatomic) IBOutlet UIView *TodaySweetView;
@property (weak, nonatomic) IBOutlet UILabel *allcountLab;
@end

@implementation OwnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * view = [UIView new];
    
    view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    UIButton * outBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    outBtn.frame  =  CGRectMake(15, 15, UISCREENWIDTH-30, 40);
    
    [outBtn setTitle:@"退出" forState:UIControlStateNormal];
    
    [outBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];

    [outBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    outBtn.backgroundColor = [UIColor colorWithHexString:@"#FFC41A"];
    
    outBtn.layer.cornerRadius = 20;
    
    outBtn.layer.masksToBounds = YES;
    
    UIView  * backView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 55)];
    
    [backView addSubview:outBtn];
    
//    [self.tableView addSubview:outBtn];
    
    self.tableView.tableFooterView = backView;
    
  NSString * iphone =    [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    self.iphoneLab.text = iphone;
    self.CellIphone.text = iphone;
    self.tableView.delegate = self;
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }

    UITapGestureRecognizer  *alltap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpAllSweet)];
        [self.MySweetView addGestureRecognizer:alltap];
    
    UITapGestureRecognizer  *totap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumptodaySweet)];
    [self.TodaySweetView addGestureRecognizer:totap];
    
//    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HeadImageBtn:)];
//    [self.HeadImg addGestureRecognizer:tap];
//    self.HeadImg.userInteractionEnabled = YES;
    
}



-(void)jumpAllSweet{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MySweetTableViewController *vc = [story instantiateViewControllerWithIdentifier:@"MySweetTableViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.istoday = NO;
    [self.navigationController pushViewController:vc animated:YES ];
    

}

-(void)jumptodaySweet{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MySweetTableViewController *vc = [story instantiateViewControllerWithIdentifier:@"MySweetTableViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.istoday = YES;

    [self.navigationController pushViewController:vc animated:YES ];
    
    
}



-(void)loadingOwncount{
    
    
    [SignUntility getowncountcallBack:^(OwnCountModel *response, FGError *error) {
       
        if (!error) {
            
            self.todayLab.text = response.todayTotal;
            
            self.allcountLab.text = response.total;
            
        }
        
        
    }];
    
    
    
}



-(void)loginOut{
    
    UIAlertController * alervc = [UIAlertController alertControllerWithTitle:@"" message:@"确定要退出登录吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"确定要退出登录吗?"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0,9)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 9)];
    [alervc setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    
    UIAlertAction * surebtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [UserUtility usernameSignOutcallback:^(SucceedModel *cancel, FGError *error) {
            
            
            if (!error) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:LoginOut object:nil];
                
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }else
            {
                [MBManager showBriefAlert:error.descriptionStr];
            }
            
        }];
        
    }];
    
    UIAlertAction * cancelbtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alervc addAction:surebtn];
    
    [alervc addAction:cancelbtn];
    
    
    [self.navigationController presentViewController:alervc animated:YES completion:nil];
    
    
}

//我的页面分享好友按钮

- (IBAction)recommand:(UIButton *)sender {
    
    
    [SignUntility GetRecommandLinkcallback:^(SucceedModel *success, FGError *error) {
        
        if (!error) {
            
            OwnShareViewController * shareVC = [[OwnShareViewController alloc]initWithNibName:@"OwnShareViewController" bundle:nil];
            
            self.tabBarController.tabBar.hidden = YES;
            
            shareVC.delegate = self;
            
            shareVC.shareLink = success.invateUrl;
            
            shareVC.definesPresentationContext = YES;
            
            shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            
            [self.navigationController  presentViewController:shareVC animated:YES completion:nil];
        }
        
        
        
    }];
 
    
    
}



-(void)shareLinkResult:(BOOL)result AndCancel:(BOOL)cancel
{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
- (IBAction)NowShare:(UIButton *)sender {
    
    [self.tabBarController  setSelectedIndex:0];
  
}

    
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 
    segue.destinationViewController.hidesBottomBarWhenPushed = YES;

   
}

-(void)HeadImageBtn:(UIGestureRecognizer *)sender{
    
    [self pushTZImagePickerController];

}

-(void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    
    // 1.设置目前已经选中的图片数组
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.width - 2 * left;
    NSInteger top = (self.view.height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = NO;
    
    
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}




-(void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [photos.firstObject circleImage:CGRectMake(0, 0, 70, 70)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.HeadImg.image = image;
            
            
            [self UpdateImg:image];
            
        });
    });
    
    
    
}

-(void)UpdateImg:(UIImage *)Img{
    
    
    [UpImgUntility UpdataImg:Img callback:^(PicUpModel *picup, FGError *error) {
        
        if (!error) {
            
  
        }
        
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self loadingOwncount];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 变高行数
    if (indexPath.section == 0) {
        
    NSInteger rowstate = [self.stateArr[indexPath.row]integerValue];
                          
        if (!rowstate) {
            // 假设改行原来高度为200
            return 52;
            
        } else {
            
            return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }else
    {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
        
    }
}
- (IBAction)SignMoreClick:(UIButton *)sender {
    
    
    [SignUntility GetSignListcallback:^(SignListdataModel *data, FGError *error) {
        
        if (!error) {
            
            [self LoadingSignDay:data];
            
            NSDate *now = [NSDate date];

            [[NSUserDefaults standardUserDefaults] setObject:now forKey:@"nowDate"];
            
           [[NSUserDefaults standardUserDefaults] synchronize];
            
            
        }else{
            
            [MBManager showBriefAlert:error.descriptionStr];
            
        }
        
    }];
    
    
    
}

-(void)LoadingSignDay:(SignListdataModel * )model{
    
    
    [SignUntility GetSignTimescallback:^(SignResponseModel *response, FGError *error) {
        
        if (!error) {
            
            SignViewController * sign = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:nil];
            
            sign.ListModel = model;
            
            sign.stateModel = response;
            
            sign.definesPresentationContext = YES;
            
            sign.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            
            [self.navigationController  presentViewController:sign animated:NO completion:nil];
        }else
        {
            
            [MBManager showBriefAlert:error.descriptionStr];
            
        }
        
        
    }];
    
    
}


- (IBAction)changeHeightClick:(UIButton *)sender {
   
    sender.selected = !sender.selected;
    
    self.stateArr[sender.tag -100] =  sender.selected ? @(1) : @(0);
    
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag -100 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

    [self.tableView reloadData];

}

-(NSMutableArray *)stateArr
{
    
    if (!_stateArr) {
        
        _stateArr = @[@(0),@(0),@(0),@(0)].mutableCopy;
    }
    
    return _stateArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
