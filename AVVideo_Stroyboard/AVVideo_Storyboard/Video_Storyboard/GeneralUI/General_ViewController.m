//
//  General_ViewController.m
//  GeneralFrame
//
//  Created by user on 14-4-11.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "General_ViewController.h"
#import "UtilitySDK.h"
#import "UINavigationBar+CustomBar.h"
@interface General_ViewController ()
{
   
}
@property(nonatomic,strong)UIImageView * bgView;
@end

@implementation General_ViewController

#pragma mark - 界面生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self=[super init];
    
    if(self)
    {
        
    }
    
    return self;
};

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setHidden:NO];
    
    /*开始导航栏基本配置*/
    //改变导航栏背景
    UIImage * navBackGround;
    navBackGround=[[UtilitySDK Instance]getImageFromColor:[UIColor whiteColor]
                                                     rect:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.navigationController.navigationBar changeBackGround:navBackGround];
    /*结束导航栏基本配置*/
  
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}


@end
