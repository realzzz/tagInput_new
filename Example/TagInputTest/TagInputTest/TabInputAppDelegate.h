//
//  TabInputAppDelegate.h
//  TagInputTest
//
//  Created by Zhang Peng on 13-9-11.
//  Copyright (c) 2013年 Zhang Peng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"


@interface TabInputAppDelegate : UIResponder <UIApplicationDelegate>
{
    MainViewController * mainVCon;
}
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) MainViewController * mainVCon;

@end
