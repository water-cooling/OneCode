//
//  ViewControllerUtility.m
//  FungusProject
//
//  Created by humengfan on 2018/5/11.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "ViewControllerUtility.h"
#import "AppDelegate.h"
@implementation ViewControllerUtility

+(UIViewController *) getRootViewController{
    
    UIViewController      * topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    NSLog(@"1111%@",topController);
    
    
    while ( topController.presentedViewController ){
        
        topController = topController.presentedViewController;
        
    }
    if (topController !=nil ) {
        
        NSLog(@"222%@",topController);

        return topController;
        
    }

    
    // topController should now be your topmost view controller
    
    AppDelegate * appDelegate  =  (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"3333%@",appDelegate.window.rootViewController);
    
    
    return appDelegate.window.rootViewController;
    
}

@end
