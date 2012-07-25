//
//  FZDragFlipView.h
//  Photocus
//
//  Created by zrz on 12-4-18.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTFlipAnimationView.h"

typedef struct _FZSRange {
    NSInteger location;
    NSInteger length;
} FZRange;

typedef enum {
    MTFlipViewTypeUpAbove,
    MTFlipViewTypeDownAbove,
    MTFlipViewTypeShowAbove
} MTFlipViewType;

@protocol MTDragFlipViewDelegate;
@class CAAnimationGroup;

@interface MTDragFlipView : UIView 
<UIScrollViewDelegate>{
    int             _state;         //0any ,1updown,2leftright
    UIView          *_backRightView,
                    *_backLeftView,
                    *_transationView;
    NSMutableArray  *_cachedImageViews;
    FZRange         _cacheRange;
    UIColor         *_blackColor;       //消失颜色
    NSInteger       _count,
                    _animationCount,
                    _state2;    //1,up , 2,down , 3,upBut cnt prev , 4 down but cnt next
    CGPoint         _tempPoint;
    BOOL            _animation,
                    _stop,
                    _change,
                    _willBackToTop,
                    _willToReload;
    // using to receive the top tap event.
    UIScrollView    *_scrollView;
    UIPanGestureRecognizer  *_backPanGesture,
                            *_mainPanGesture,
                            *_transationViewPanGesture;
    UITapGestureRecognizer  *_transationViewTapGesture;
    NSMutableDictionary     *_unuseViews;
}

- (id)initWithType:(MTFlipViewType)type;

@property (nonatomic, readonly) MTFlipViewType  type;

@property (nonatomic, assign)   id<MTDragFlipViewDelegate>  delegate;
@property (nonatomic, assign)   NSInteger   pageIndex;
@property (nonatomic, readonly) NSInteger   count;
//背景颜色
@property (nonatomic, strong)   UIColor     *backgroundColor;

@property (nonatomic, assign)   BOOL        dragEnable;

// is opened background view or not.
@property (nonatomic, readonly) BOOL        open;
@property (nonatomic, assign)   NSTimeInterval  animationInterval;

//到顶部
// back to top
- (void)backToTop:(BOOL)aniamted;
// 
- (void)openBackView:(BOOL)isLeft;
- (void)closeBackView;

- (void)pushViewToCache:(MTFlipAnimationView*)view;

//  缓存的MTFlipAnimationView, using for reusing MTFlipAnimationView.
- (MTFlipAnimationView*)imageViewWithIndex:(NSInteger)index;
- (MTFlipAnimationView*)dequeueReusableViewWithIdentifier:(NSString*)indentifier;

//重载所有页面
- (void)reloadData;

//  只读取总数，加载更多时调用。
//  only reload the count, when the totle number changed but the view 
//  content unchanged. ex: Load more.
- (void)reloadCount;

// using to manage memory
- (void)clean;
- (void)load;
//if use this methord you must implementation - flipViewPrePushDragingView:
- (void)preload:(NSInteger)count;

// turn the next page
- (void)nextPage:(BOOL)animation;

@end

@protocol MTDragFlipViewDelegate <NSObject>

@required
//  返回在index的子页面, 可重用
//  return the subview at index, can reuse.
- (UIView*)flipView:(MTDragFlipView*)flipView subViewAtIndex:(NSInteger)index;

//  返回一共有多少个页面
//  return number of subviews.
- (NSInteger)numberOfFlipViewPage:(MTDragFlipView*)flipView;

//  返回在index的动画页面，可使用-dequeueReusableViewWithIdentifier:
//  来重用页面
//  return the animation view at index, could reuse by using 
//  -dequeueReusableViewWithIdentifier:
- (MTFlipAnimationView*)flipView:(MTDragFlipView*)flipView dragingView:(NSInteger)index;


@optional

//  invoked when close the back view at index.
- (void)flipView:(MTDragFlipView*)flipView backViewClosed:(NSInteger)index;

//  返回再index的后台页面
//  return the back view at index. could reuse
- (UIView*)flipView:(MTDragFlipView*)flipView 
      backgroudView:(NSInteger)index 
               left:(BOOL)isLeft;

- (void)flipView:(MTDragFlipView *)flipView 
 didDragToBorder:(BOOL)isUp 
          offset:(CGFloat)offset;

//  As named, invoked when start draging.
- (void)flipView:(MTDragFlipView *)flipView startDraging:(NSInteger)index;

//  used when the show view changed ,at this time we can reset
//  the animation view with out -reloadCount
- (void)flipView:(MTDragFlipView*)flipView 
      reloadView:(MTFlipAnimationView*)view
         atIndex:(NSInteger)index;

- (MTFlipAnimationView*)flipViewPrePushDragingView:(MTDragFlipView *)flipView;

@end