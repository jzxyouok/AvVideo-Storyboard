//
//  CustomTabBarController.m
//  GeneralSDK
//
//  Created by user on 14-12-7.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "CustomTabBarController.h"
#import "UISDK.h"
@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

#pragma mark - 界面生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addCenterBut];
    [self addViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 自定义方法
/// 添加中间的按钮
-(void)addCenterBut
{
    // 设置视频页面
    UIImage * img=[[UISDK Instance]getImg:@"camera_button_take.png"];
    UIImage * slImg=[[UISDK Instance]getImg:@"tabBar_cameraButton_ready_matte.png"];
    CGRect rect=CGRectMake(0, 0, img.size.width, img.size.height);
    UIButton * centerBut=[[UISDK Instance]addButton:rect
                                              title:nil
                                              color:nil
                                             hcolor:nil
                                               font:nil
                                              bgImg:img
                                             selImg:slImg
                                              block:^(UIButton *but) {
                                                  UIStoryboard * videoSotryBoard=[UIStoryboard storyboardWithName:@"VideoStoryboard" bundle:nil];
                                                  UIViewController * videoView=[videoSotryBoard instantiateViewControllerWithIdentifier:@"Launch"];
                                                 
                                                  [self presentViewController:videoView
                                                                     animated:YES
                                                                   completion:nil];
                                              }
                                               view:self.view];
    centerBut.center=CGPointMake(ScreenWidth/2, ScreenHeight-33);
}

/// 构造ViewControllers
-(void)addViewControllers
{
    // 添加Main
    UIStoryboard * mainStoryBoard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController * mainView=[mainStoryBoard instantiateViewControllerWithIdentifier:@"Launch"];
    UIImage * mainImg=[[UISDK Instance]getImg:@"tab_feed.png"];
    UITabBarItem * mainItem=[[UITabBarItem alloc]initWithTitle:@"首页" image:mainImg tag:1];
    mainView.tabBarItem=mainItem;
    
    //添加Hot
    UIStoryboard * hotStoryBoard=[UIStoryboard storyboardWithName:@"HotStoryboard" bundle:nil];
    UIViewController * hotView=[hotStoryBoard instantiateViewControllerWithIdentifier:@"Launch"];
    UIImage * hotImg=[[UISDK Instance]getImg:@"tab_live.png"];
    UITabBarItem * hotItem=[[UITabBarItem alloc]initWithTitle:@"Hot" image:hotImg tag:2];
    hotView.tabBarItem=hotItem;
    
    //添加Emypt
    UIViewController * empytView=[[UIViewController alloc]init];
    UITabBarItem * emptyItem=[[UITabBarItem alloc]initWithTitle:@"Empty" image:nil tag:3];
    empytView.tabBarItem=emptyItem;
    
    //添加Message
    UIStoryboard * messageSotryBoard=[UIStoryboard storyboardWithName:@"MessageStoryboard" bundle:nil];
    UIViewController * messageView=[messageSotryBoard instantiateViewControllerWithIdentifier:@"Launch"];
    UIImage * messageImg=[[UISDK Instance]getImg:@"tab_messages.png"];
    UITabBarItem * messageItem=[[UITabBarItem alloc]initWithTitle:@"消息" image:messageImg tag:4];
    messageView.tabBarItem=messageItem;

    //添加Account
    UIStoryboard * accountSotryBoard=[UIStoryboard storyboardWithName:@"AccountStoryBoard" bundle:nil];
    UIViewController * accountView=[accountSotryBoard instantiateViewControllerWithIdentifier:@"Launch"];
    UIImage * accountImg=[[UISDK Instance]getImg:@"tab_feed_profile.png"];
    UITabBarItem * accountItem=[[UITabBarItem alloc]initWithTitle:@"账户" image:accountImg tag:5];
    accountView.tabBarItem=accountItem;
    
    self.viewControllers=[NSArray arrayWithObjects:
                                mainView,
                                hotView,
                                empytView,
                                messageView,
                                accountView,
                                   nil];
}
@end
