//
//  VideoProcessViewController.m
//  AVVideoExample
//
//  Created by user on 14-9-4.
//  Copyright (c) 2014年 ios. All rights reserved.
//
#import "VideoDefine.h"
#import "VideoPlayer.h"
#import "VideoProcessViewController.h"
#import "VideoProcessOperationView.h"
#import "VideoProcessItem.h"
#import "UtilitySDK.h"
#import "PhotosAlbumOption.h"
#import "UINavigationBar+CustomBar.h"
#import <AVFoundation/AVFoundation.h>
@interface VideoProcessViewController ()
@property(nonatomic,strong)IBOutlet VideoProcessOperationView * operationView;
@property(nonatomic,strong)IBOutlet CustomToolBar * toolBar;
@property(nonatomic,strong)NSArray * toolTitles;
@property(nonatomic,strong)NSArray * toolImgs;
@property(nonatomic,assign)int selectedIndex;
@property(nonatomic,strong)IBOutlet VideoPlayer * videoPlayer;
@end

@implementation VideoProcessViewController
#pragma mark - 界面生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.selectedIndex=0;
//        self.toolTitles=[NSArray arrayWithObjects:@"音乐",@"滤镜",@"水印",nil];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.selectedIndex=0;
        self.toolTitles=[NSArray arrayWithObjects:@"音乐",@"滤镜",@"水印",nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*开始导航栏基本配置*/
    //改变导航栏背景
    UIImage * navBackGround;
    navBackGround=[[UtilitySDK Instance]getImageFromColor:[UIColor blackColor]
                                                     rect:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.navigationController.navigationBar changeBackGround:navBackGround];
    [self.navigationController.navigationBar changeNavFont:[UIColor whiteColor]];
    /*结束导航栏基本配置*/

    
    // 添加预览视图
    NSString * outputFilePath=[[UtilitySDK Instance]creatDirectiory:MixVideoPath];
    outputFilePath=[outputFilePath stringByAppendingPathComponent:MixVideoFile];
    [self.videoPlayer addSubviews:outputFilePath];
    
    //设置操作栏
    __weak VideoProcessViewController * tempView=self;
    self.operationView.selectedBlock=^(NSString * url){
        [tempView.videoPlayer changePlayerItem:url];
    };
    
    // 设置工具栏
    [self.toolBar reloadData];
    [self.toolBar selectedItem:0];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.videoPlayer startPlayer];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self reset];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"VideoProcessViewController已经释放");
}
#pragma mark - 导航栏相关
/// 左导航按钮方法
-(IBAction)leftNavButCall:(id)sender
{
    [self.videoPlayer stopPlayer];
    [self.navigationController popViewControllerAnimated:YES];
}

/// 还原按钮方法
-(IBAction)renewButCall:(id)sender
{
    [[UISDK Instance]showWait:@"请稍候" view:self.view.window];
    // 获取原文件
    NSString * sourceFilePath=[[UtilitySDK Instance]creatDirectiory:VideoRecordPath];
    sourceFilePath=[sourceFilePath  stringByAppendingPathComponent:VideoRecordFile];
    // 获取混合文件
    NSString * mixFilePath=[[UtilitySDK Instance]creatDirectiory:MixVideoPath];
    NSArray * files=[[UtilitySDK Instance]getFilesInDirectory:mixFilePath];
    for(NSString * file in files)
    {
        NSString * filePath=[mixFilePath stringByAppendingPathComponent:file];
        [[UtilitySDK Instance]deleteFile:filePath];
    }
    // 删除已存在的混合文件
    
    // 将原文件拷贝到混合文件中
    mixFilePath=[mixFilePath stringByAppendingPathComponent:MixVideoFile];
    [[UtilitySDK Instance]saveFile:sourceFilePath toSavePath:mixFilePath];
    
    [self.videoPlayer changePlayerItem:mixFilePath];
    [[UISDK Instance]hideWait:self.view.window];
}

/// 发布按钮方法
-(IBAction)publishButCall:(id)sender
{
    [[UISDK Instance]showWait:@"请稍候" view:self.view.window];
    NSString * filePath=[[UtilitySDK Instance]creatDirectiory:MixVideoPath];
    NSArray * files=[[UtilitySDK Instance]getFilesInDirectory:filePath];
    for(NSString * file in files)
    {
        filePath = [filePath stringByAppendingPathComponent:file];
    }
    [PhotosAlbumOption Instance].saveFinishBlock=^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UISDK Instance]hideWait:self.view.window];
            [[UISDK Instance]showTextHud:@"视频已输出到相册" view:self.view.window];
        });
    };
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         [[PhotosAlbumOption Instance]saveVideoToPhotosAlbum:filePath];
    });
}


#pragma mark - 主视图UI配置相关
/// 添加子视图
-(void)addSubviews
{
    // 通用参数
    CGRect rect=CGRectZero;
    rect=CGRectMake(0, 0, ScreenWidth, ScreenHeight-220);
    __weak VideoProcessViewController * tempView=self;
    
    /*开始添加操作栏*/
    rect=CGRectMake(0, rect.origin.y+rect.size.height+20, ScreenWidth, 80);
    self.operationView=[[VideoProcessOperationView alloc]initWithFrame:rect];
    self.operationView.selectedBlock=^(NSString * url){
        [tempView.videoPlayer changePlayerItem:url];
    };
    [self.view addSubview:self.operationView];
    /*结束添加操作栏*/
    
    /*开始添加工具栏*/
    rect=CGRectMake(0, rect.origin.y+rect.size.height, ScreenWidth, 70);
    self.toolBar=[[CustomToolBar alloc]initWithFrame:rect];
    self.toolBar.delegate=self;
    [self.view addSubview:self.toolBar];
    [self.toolBar reloadData];
    [self.toolBar selectedItem:0];
    /*结束添加工具栏*/
    
    /* 开始添加播放器 */
    rect=CGRectMake(0, 0, ScreenWidth, ScreenHeight-220);
    NSString * outputFilePath=[[UtilitySDK Instance]creatDirectiory:MixVideoPath];
    outputFilePath=[outputFilePath stringByAppendingPathComponent:MixVideoFile];
    
    self.videoPlayer=[[VideoPlayer alloc]initWithFrame:rect url:outputFilePath];
    [self.view addSubview:self.videoPlayer];
    /* 结束添加播放器 */
}

#pragma mark - 功能方法
// 重置
-(void)reset
{
    [self.videoPlayer stopPlayer];
    [self.toolBar selectedItem:0];
    [self hideOperationView:0];
}

#pragma mark - 工具栏相关方法

/// 显示操作视图
-(void)showOperationView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.operationView.frame=CGRectMake(0,
                                            self.operationView.frame.origin.y-100,
                                            self.operationView.frame.size.width,
                                            self.operationView.frame.size.height);
    }];

}
/// 隐藏操作视图
-(void)hideOperationView:(int)index
{
    if(self.selectedIndex==index)
    {
        [self.operationView configureData:index];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.operationView.frame=CGRectMake(0,
                                            self.operationView.frame.origin.y+100,
                                            self.operationView.frame.size.width,
                                            self.operationView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.operationView configureData:index];
        [self showOperationView];
    }];
}

#pragma mark - 自定义工具栏相关委托 CustomToolBarDelegate

/// 工具栏项总数
-(int)itemCount
{
    return 3;
}

/// 工具栏视图
-(UIView *)itemView:(int)index
{
    NSString * title=[self.toolTitles objectAtIndex:index];
    VideoProcessItem * item=[[VideoProcessItem alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    item.label.text=title;
    return item;
}

/// 选中工具栏项
-(void)selectedItem:(UIView *)selectedView index:(int)selectedIndex
{
    VideoProcessItem * item=(VideoProcessItem *)selectedView;
    [item.label setTextColor:[UIColor redColor]];
    [self hideOperationView:selectedIndex];
    self.selectedIndex=selectedIndex;
}

/// 取消选中工具栏项
-(void)unselectedItem:(UIView *)unselectedView index:(int)unselectedIndex
{
    VideoProcessItem * item=(VideoProcessItem *)unselectedView;
    [item.label setTextColor:[UIColor whiteColor]];
}

@end
