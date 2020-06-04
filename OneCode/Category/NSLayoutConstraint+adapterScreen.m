//
//  NSLayoutConstraint+adapterScreen.m
//  FungusProject
//
//  Created by humengfan on 2018/5/9.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "NSLayoutConstraint+adapterScreen.h"
@implementation NSLayoutConstraint (adapterScreen)

- (void)setAdapterScreen:(BOOL)adapterScreen{
    
    if (adapterScreen){
        
        self.constant = self.constant * iPhonescale;
    }
}

- (BOOL)adapterScreen{
    
    return YES;
}

@end
