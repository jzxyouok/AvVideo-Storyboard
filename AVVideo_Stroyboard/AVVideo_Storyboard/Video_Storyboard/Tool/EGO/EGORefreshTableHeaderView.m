//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    NSString *imageName;
    {
        if (frame.origin.y < 0) {
            _pullDirection = EGOPullingDown;
            imageName = @"blueArrow.png";
        } else {
            _pullDirection = EGOPullingUp;
            imageName = @"blueArrow.png";
        }
    }
    [self initWithFrame:frame arrowImageName:imageName];
    return self;
}


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrowImage {
    if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
		UILabel *label;
        if (_pullDirection == EGOPullingDown) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        } else {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 28.0f, self.frame.size.width, 20.0f)];
        }
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];
		
        if (_pullDirection == EGOPullingDown) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        } else {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.frame.size.width, 20.0f)];
        }
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		CALayer *layer = [CALayer layer];
        if (_pullDirection == EGOPullingDown) {
            layer.frame = CGRectMake(25.0f, frame.size.height - REFRESH_REGION_HEIGHT, 30.0f, 55.0f);
        } else {
            layer.frame = CGRectMake(25.0f, 5.0f, 30.0f, 55.0f);
        }
		layer.contentsGravity = kCAGravityResizeAspect;
        UIImage * img=[UIImage imageNamed:arrowImage];
		layer.contents = (id)img.CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        if (_pullDirection == EGOPullingDown) {
            view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        } else {
            view.frame = CGRectMake(25.0f, 20.0f, 20.0f, 20.0f);
        }
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		[self setState:EGOOPullRefreshNormal];
    }
	
    return self;
	
}


#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
	if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableDataSourceLastUpdated:self];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setAMSymbol:@"AM"];
		[formatter setPMSymbol:@"PM"];
		[formatter setDateFormat:@"MM/dd/yyyy hh:mm:a"];
		_lastUpdatedLabel.text = [NSString stringWithFormat:@"　最后一次更新: %@", [formatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		[formatter release];
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)refresh
{
    [self setState:EGOOPullRefreshPulling];
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = NSLocalizedString(@"释放手指开始加载...", @"Release to refresh status");
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
            
			if (_pullDirection == EGOPullingDown) {
                _statusLabel.text = NSLocalizedString(@"下拉刷新", @"Pull down to refresh status");
            }
            
            [_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
            if (_pullDirection == EGOPullingDown) {
                [self refreshLastUpdatedDate];
            }
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = NSLocalizedString(@"加载中...", @"Loading Status");
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        UIEdgeInsets edge=scrollView.contentInset;
		offset = MIN(offset, REFRESH_REGION_HEIGHT);
        if (_pullDirection == EGOPullingDown) {
            // 控制下拉刷新
            scrollView.contentInset = UIEdgeInsetsMake(offset,
                                                       edge.left,
                                                       edge.bottom,
                                                       edge.right);
        }
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
		}
		
        // 控制下拉刷新
        if (_pullDirection == EGOPullingDown) {
            // 如下拉没有达到刷新位置 则状态设为普通
            if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -REFRESH_REGION_HEIGHT && scrollView.contentOffset.y < 0.0f && !_loading) {
                [self setState:EGOOPullRefreshNormal];
            }
            // 如下拉达到刷新位置 则状态设为准备刷新
            else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -REFRESH_REGION_HEIGHT && !_loading) {
                [self setState:EGOOPullRefreshPulling];
            }
        }

	}
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableDataSourceIsLoading:self];
	}
	if (_pullDirection == EGOPullingDown) {
        // 下拉放开手指 并达到刷新条件 设置状态为开始刷新 并添加边距
        if (scrollView.contentOffset.y <= - REFRESH_REGION_HEIGHT && !_loading) {
            
            if ([_delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
                [_delegate egoRefreshTableDidTriggerRefresh:EGORefreshHeader];
            }
            
            [self setState:EGOOPullRefreshLoading];
            UIEdgeInsets edge=scrollView.contentInset;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scrollView.contentInset = UIEdgeInsetsMake(edge.top+REFRESH_REGION_HEIGHT,
                                                       edge.left,
                                                       edge.bottom,
                                                       edge.right);
            [UIView commitAnimations];
            
        }
    }
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {	

    //下拉刷新完毕 恢复边距
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
    UIEdgeInsets edge=scrollView.contentInset;
    if (_pullDirection == EGOPullingDown) {
        [scrollView setContentInset:UIEdgeInsetsMake(edge.top-REFRESH_REGION_HEIGHT,
                                                     edge.left,
                                                     edge.bottom,
                                                     edge.right)];
    }
  	[UIView commitAnimations];
	
    [self setState:EGOOPullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
    [super dealloc];
}


@end