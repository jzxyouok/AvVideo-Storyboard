//
//  RefreshViewController.m
//  CoreDataFlipPage
//
//  Created by user on 14-8-16.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "RefreshViewController.h"
@interface RefreshViewController ()
@property(nonatomic,strong)IBOutlet UITableView * table;
@property(nonatomic,strong)EGORefreshTableHeaderView * headRefreshView;
@property(nonatomic,strong)EGORefreshTableFooterView * footRefreshView;
@property(nonatomic,assign)int currentPage;
// EGO刷新控件必备属性
@property(nonatomic,assign)BOOL reloading;
@end

@implementation RefreshViewController
#pragma mark - 界面生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentPage=1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"ContentSize:%f",self.table.frame.size.height);
    [self addRefreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义方法


/// 添加刷新控件
-(void)addRefreshView
{
    switch (self.refreshState) {
        // 如果只有下拉刷新控件
        case haveHeadRefreshView:
        {
            [self addHeadRefreshView];
        }
            break;
        // 如果只有上拉刷新控件
        case haveRootRefreshView:
        {
            [self addFootRefreshView];
        }
            break;
        // 如果二者都有
        case haveBothRefreshView:
        {
            [self addHeadRefreshView];
            [self addFootRefreshView];
        }
            break;
        default:
            break;
    }
}

/// 强制刷新
-(void)refresh
{
    [UIView animateWithDuration:0.3 animations:^{
        self.table.contentOffset=CGPointMake(0, -80);
        [self.headRefreshView egoRefreshScrollViewDidEndDragging:self.table];
    }];
}

/// 添加下拉刷新
-(void)addHeadRefreshView
{
    CGRect rect=CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,ScreenWidth,self.view.bounds.size.height);
    self.headRefreshView=[[EGORefreshTableHeaderView alloc]initWithFrame:rect];
    self.headRefreshView.delegate=self;
    [self.table addSubview:self.headRefreshView];
}

/// 添加上拉加载更多
-(void)addFootRefreshView
{
    CGFloat height = MAX(self.table.contentSize.height, self.table.frame.size.height);
    // 如果上拉加载控件已存在 则将它放置在界面底部
    if (self.footRefreshView && [self.footRefreshView superview]) {
        // reset position
        self.footRefreshView.frame = CGRectMake(0.0f,
                                                height,
                                                self.table.frame.size.width,
                                                self.view.bounds.size.height);
    }else {
        // 否则添加上拉加载控件
        self.footRefreshView = [[EGORefreshTableFooterView alloc] initWithFrame:
                                CGRectMake(0.0f, height,
                                           self.table.frame.size.width, self.view.bounds.size.height)];
        self.footRefreshView.delegate = self;
        [self.table addSubview:self.footRefreshView];
    }
    
    if (self.footRefreshView) {
        [self.footRefreshView refreshLastUpdatedDate];
    }
}

/// 开始数据刷新
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos
{
    
	self.reloading = YES;
    
    // 如果是下拉刷新则只刷新当前数据
    if (aRefreshPos == EGORefreshHeader)
    {
        self.currentPage=1;
    }
    // 否则加载更多数据
    else
    {
        self.currentPage+=1;
    }
    
    [self refreshData:aRefreshPos];
    
}

/// 刷新数据
-(void)refreshData:(EGORefreshPos) pos
{
    if(self.refreshDataBlock)
    {
        self.refreshDataBlock(self.currentPage);
    }
    
    // 需要等待几秒 否则等待界面不会回复
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        [self.table reloadData];
        [self finishReloadingData:pos];
        
    });
    
  
}

// 结束刷新
- (void)finishReloadingData:(EGORefreshPos)aRefreshPos{
	
	self.reloading = NO;
	if (aRefreshPos==EGORefreshHeader)
    {
        [self.headRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
    }
    else if (aRefreshPos==EGORefreshFooter)
    {
        [self.footRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
        // 重定上拉控件位置
        [self addFootRefreshView];
    }
}

/// 把scroll与刷新控件关联
-(void)relateScroll
{
  	if (self.headRefreshView) {
        [self.headRefreshView egoRefreshScrollViewDidScroll:self.table];
    }
    
    if(self.footRefreshView)
    {
        [self.footRefreshView egoRefreshScrollViewDidScroll:self.table];
    }
}


/// 把scrollEnd与刷新控件关联
-(void)relateScrollEnd
{
    if (self.headRefreshView) {
        
        [self.headRefreshView egoRefreshScrollViewDidEndDragging:self.table];
    }
    
    if (self.footRefreshView) {
        [self.footRefreshView egoRefreshScrollViewDidEndDragging:self.table];
    }
}

#pragma mark UIScrollViewDelegate Methods 委托
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self relateScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"ScrollEnd");
    [self relateScrollEnd];
}


#pragma mark EGORefreshTableDelegate Methods 刷新委托
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	NSLog(@"BeginRefresh");
    //开始刷新
    [self beginToReloadData:aRefreshPos];
	
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	
	return self.reloading; // should return if data source model is reloading
	
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
