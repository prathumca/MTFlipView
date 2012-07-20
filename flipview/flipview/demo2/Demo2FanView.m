//
//  Demo2FanView.m
//  flipview
//
//  Created by 仁治 赵 on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Demo2FanView.h"

@implementation Demo2FanView

@synthesize coverLayer = _coverLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _coverLayer = [CALayer layer];
        _coverLayer.frame = self.bounds;
        //_coverLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _coverLayer.contents = (id)[UIImage imageNamed:@"demo2_cover"].CGImage;
        _coverLayer.opacity = 0;
        [self.layer addSublayer:_coverLayer];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _coverLayer.frame = self.bounds;
}

- (void)setCoverOpacity:(float)opacity;
{
    _coverLayer.opacity = 0.8*opacity;
}


- (void)coverOpacityAnimation:(float)toOpacity 
                     duration:(float)duration;
{
    static NSString *aniamtionIndentifier = @"coverAnimation";
    [_coverLayer removeAnimationForKey:aniamtionIndentifier];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:_coverLayer.opacity];
    animation.toValue = [NSNumber numberWithFloat:0.8*toOpacity];
    animation.duration = duration;
    _coverLayer.opacity = 0.8*toOpacity;
    [_coverLayer addAnimation:animation
                       forKey:aniamtionIndentifier];
}

@end
