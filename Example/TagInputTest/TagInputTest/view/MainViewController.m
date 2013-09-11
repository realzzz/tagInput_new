//
//  MainViewController.m
//  TagInputTest
//
//  Created by Zhang Peng on 13-9-11.
//  Copyright (c) 2013年 Zhang Peng. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor =[UIColor blueColor];
    
    tagInputV = [[TagInputView alloc]initWithFrame:CGRectMake(50, 200, 200, 50)];
    tagInputV.backgroundColor =[UIColor redColor];
    tagInputV.tagInput.font = [UIFont systemFontOfSize:28];
    [self.view addSubview:tagInputV];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
