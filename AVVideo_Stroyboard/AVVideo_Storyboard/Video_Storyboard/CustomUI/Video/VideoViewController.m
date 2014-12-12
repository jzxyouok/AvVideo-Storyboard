//
//  VideoViewController.m
//  GeneralSDK
//
//  Created by user on 14-12-7.
//  Copyright (c) 2014年 ios. All rights reserved.
//

/// 视频最大记录时间

#import "VideoDefine.h"
#import "VideoViewController.h"
#import "UINavigationBar+CustomBar.h"
#import "UtilitySDK.h"
#import "VideoPreview.h"
#import "VideoRecordProgress.h"
@interface VideoViewController ()
/// 已经打开闪光灯
@property(nonatomic,assign)BOOL haveLight;
/// 摄像头已经转向
@property(nonatomic,assign)BOOL haveSwitch;
/// 记录视频已停止
@property(nonatomic,assign)BOOL haveStartRecord;
/*各种视图控件*/
/// 录制进度条
@property(nonatomic,strong)IBOutlet VideoRecordProgress * videoProgress;
/// 录制预览
@property(nonatomic,strong)IBOutlet VideoPreview * videoPreview;
/// 录制按钮
@property(nonatomic,strong)UIButton * recordBut;
/// 储存按钮
@property(nonatomic,strong)IBOutlet UIButton * saveBut;

/*计时器相关*/
/// 当前记录时间
@property(nonatomic,assign)float currentTime;
/// 当前记录计时器
@property(nonatomic,strong)NSTimer * recordTime;

@end

#pragma mark - 界面生命周期
@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    /*开始导航栏基本配置*/
    //改变导航栏背景
    UIImage * navBackGround;
    navBackGround=[[UtilitySDK Instance]getImageFromColor:[UIColor blackColor]
                                                     rect:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.navigationController.navigationBar changeBackGround:navBackGround];
    /*结束导航栏基本配置*/
    
    //添加导航栏按钮
    [self addNavBut];
    
    // 配置计时器
    [self configTime];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 预览开始
    [self.videoPreview startRun];
    self.videoPreview.hidden=NO;
    
    // 启动进度条闪烁
    [self.videoProgress startTime];
    self.saveBut.enabled=NO;
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.currentTime=0;
    // 预览停止
    [self.videoPreview stopRun];
    // 停止进度条闪烁
    [self.videoProgress stopTime];
    // 重设进度条进度
    [self.videoProgress reset];
    // 隐藏预览视图
    self.videoPreview.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"Dealloc");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 导航栏相关
/// 添加导航栏按钮
-(void)addNavBut
{
    /*开始配置右导航*/
    UIImage * img=nil;
    UIImage * selImg=nil;
    __weak VideoViewController * tempView=self;
    img=[[UISDK Instance]getImg:@"MainView_LightBut.png"];
    selImg=[[UISDK Instance]getImg:@"MainView_LightBut.png"];
    UIBarButtonItem * lightBut=[[UISDK Instance]imgBarButton:img
                                                      selImg:selImg
                                                        text:nil
                                                       block:^(UIButton *but) {
                                                           [tempView lightButCall];
                                                       }
                                                 leftOrRight:0];
    
    img=[[UISDK Instance]getImg:@"MainView_Switch.png"];
    selImg=[[UISDK Instance]getImg:@"MainView_Switch.png"];
    UIBarButtonItem * switchBut=[[UISDK Instance]imgBarButton:img
                                                       selImg:selImg
                                                         text:nil
                                                        block:^(UIButton *but) {
                                                            [tempView switchCameraButCall];
                                                        }
                                                  leftOrRight:0];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:switchBut,lightBut,nil];
    /*结束配置左右导航*/
}

/// 左导航按钮方法
-(IBAction)leftNavButCall:(id)sender
{
    // 停止计时器
    [self stopTime];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/// 闪光灯按钮方法
-(void)lightButCall
{
    // 取反闪光灯状态,然后重新配置导航栏样式
    self.haveLight=!self.haveLight;
    [self configNavBut];
   // [self.videoPreview switchLight];
    
}

/// 镜头转化按钮方法
-(void)switchCameraButCall
{
    // 取反摄像头位置状态,然后重新配置导航栏样式
    self.haveSwitch=!self.haveSwitch;
    [self configNavBut];
   // [self.videoPreview switchCamera];
}

/// 设置导航按钮样式
-(void)configNavBut
{
    UIImage * lightimg;
    UIImage * switchImg;
    UIBarButtonItem * lightBut;
    UIBarButtonItem * switchBut;
    __weak VideoViewController * tempView=self;
    if(self.haveLight)
    {
        
        lightimg=[[UISDK Instance]getImg:@"MainView_LightBut_.png"];
    }
    else
    {
        
        lightimg=[[UISDK Instance]getImg:@"MainView_LightBut.png"];
    }
    
    
    if(self.haveSwitch)
    {
        lightimg=[[UISDK Instance]getImg:@"MainView_LightBut.png"];
        switchImg=[[UISDK Instance]getImg:@"MainView_Switch_.png"];
    }
    else
    {
        switchImg=[[UISDK Instance]getImg:@"MainView_Switch.png"];
        
    }
    
    lightBut=[[UISDK Instance]imgBarButton:lightimg
                                    selImg:lightimg
                                      text:nil
                                     block:^(UIButton *but) {
                                         [tempView lightButCall];
                                     }
              
                               leftOrRight:0];
    
    switchBut=[[UISDK Instance]imgBarButton:switchImg
                                     selImg:switchImg
                                       text:nil
                                      block:^(UIButton *but) {
                                          [tempView switchCameraButCall];
                                      }
                                leftOrRight:0];
    
    
    if(self.haveSwitch)
    {
        lightBut.enabled=NO;
        self.haveLight=NO;
        
    }
    else
    {
        lightBut.enabled=YES;
        
    }
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:switchBut,lightBut,nil];
}

// 左导航栏点击事件
-(IBAction)leftNavAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 计时器相关
/// 配置计时器
-(void)configTime
{
    if (!self.recordTime) {
        self.recordTime=[NSTimer scheduledTimerWithTimeInterval:0.01
                                                         target:self
                                                       selector:@selector(addTime)
                                                       userInfo:nil
                                                        repeats:YES];
        
        [self.recordTime setFireDate:[NSDate distantFuture]];
    }
}

/// 计时器方法
-(void)addTime
{
    self.currentTime+=CoundTime;
    float percent=self.currentTime/MaxTime;
    [self.videoProgress changeProgressview:percent];
    
    if(self.currentTime>=RequireTime)
    {
        UIImage * img=[[UISDK Instance]getImg:@"MainView_SaveBut_.png"];
        [self.saveBut setBackgroundImage:img forState:UIControlStateNormal];
        self.saveBut.enabled=YES;
    }
}

/// 停止计时器
-(void)stopTime
{
    [self.recordTime invalidate];
    self.recordTime=nil;
}

#pragma mark - 按钮事件回调

/// 录制按钮按下回调
-(IBAction)recordButPressedCall
{
    //开始记录状态取反 调用记录或停止方法
    self.haveStartRecord=!self.haveStartRecord;
    self.recordBut.enabled=NO;
    [self startOrPauselRecord];
}

/// 录制按钮按下弹起
-(IBAction)recordButCancelCall
{
    //开始记录状态取反 调用记录或停止方法
    self.haveStartRecord=!self.haveStartRecord;
    [self startOrPauselRecord];
    [self.videoProgress addSuspendAccessory];
    self.recordBut.enabled=YES;
}

#pragma mark - 功能方法
/// 开始录制或暂停录制
-(void)startOrPauselRecord
{    // 开始记录
    if(self.haveStartRecord)
    {
        //视频保存到文件
        [self.videoPreview startRecord];
        //进度条递增
        [self.recordTime setFireDate:[NSDate distantPast]];
    }
    // 停止记录
    else
    {
        [self.videoPreview stopRecord];
        //进度条停止
        [self.recordTime setFireDate:[NSDate distantFuture]];
    }
}

/// 储存按钮回调
-(IBAction)saveButCall:(id)sender
{
    self.saveBut.enabled=NO;
    [self.videoPreview saveToDisk:^{
        // 将源视频文件保存到混合文件夹中
        NSString * sourceFile=[[UtilitySDK Instance]creatDirectiory:VideoRecordPath];
        sourceFile=[sourceFile stringByAppendingPathComponent:VideoRecordFile];
        NSString * savePath=[[UtilitySDK Instance]creatDirectiory:MixVideoPath];
        savePath=[savePath stringByAppendingPathComponent:MixVideoFile];
        [[UtilitySDK Instance]saveFile:sourceFile toSavePath:savePath];
        
        [self performSegueWithIdentifier:@"ShowVideoProcess" sender:self];
    }];
}

#pragma mark - Segue委托
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
