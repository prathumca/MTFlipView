//
//  Demo2FanView.h
//  flipview
//
//  Created by 仁治 赵 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface Demo2FanView : UIImageView {
    CALayer     *_coverLayer;
}

@property (nonatomic, strong)  CALayer *coverLayer;
- (void)setCoverOpacity:(float)opacity;
- (void)coverOpacityAnimation:(float)toOpacity duration:(float)duration;

@end
