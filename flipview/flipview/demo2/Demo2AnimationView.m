//
//  Demo2AnimationView.m
//  flipview
//
//  Created by zrz on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Demo2AnimationView.h"
#import <QuartzCore/QuartzCore.h>
#import "Demo2FanView.h"

@interface Demo2AnimationView()

@property (nonatomic, readonly) Demo2FanView    *upImageView,
                                                *downImageView;

@end

@implementation Demo2AnimationView {
    Demo2FanView    *_upImageView,
                    *_downImageView;
    CGFloat     _percent;
}

@synthesize text = _text, upImageView = _upImageView;
@synthesize downImageView = _downImageView;

static UILabel  *__label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (!__label) {
            __label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 220, 300)];
            __label.backgroundColor = [UIColor clearColor];
            __label.numberOfLines = 0;
            __label.textColor = [UIColor whiteColor];
        }
        
        //because of using global variables so it just suport one thread.
        self.mainQueue.maxConcurrentOperationCount = 1;
        
        _upImageView = [[Demo2FanView alloc] initWithFrame:CGRectMake(0, frame.size.height / 4, 
                                                                     frame.size.width,
                                                                     frame.size.height / 2)];
        _downImageView = [[Demo2FanView alloc] initWithFrame:CGRectMake(0, frame.size.height / 4, 
                                                                       frame.size.width, 
                                                                       frame.size.height / 2)];
    
        [self addSubview:_upImageView];
        [self addSubview:_downImageView];
        
        _upImageView.backgroundColor = [UIColor blueColor];
        _upImageView.contentMode = UIViewContentModeTop;
        _upImageView.layer.anchorPoint = CGPointMake(0.5, 1);
        _upImageView.clipsToBounds = YES;
        _downImageView.backgroundColor = [UIColor blueColor];
        _downImageView.contentMode = UIViewContentModeBottom;
        _downImageView.layer.anchorPoint = CGPointMake(0.5, 0);
        _downImageView.clipsToBounds = YES;
        _downImageView.coverLayer.transform = CATransform3DMakeScale(1, -1, 1);
        
        self->_imageView = nil;
        
        self.backgroundColor = [UIColor clearColor];
        
        if (!__label) {
            __label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 220, 300)];
            __label.backgroundColor = [UIColor clearColor];
            __label.numberOfLines = 0;
            __label.textColor = [UIColor clearColor];
        }
        self.backgroundColor = [UIColor clearColor];
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
    _upImageView.frame = CGRectMake(0, 0, frame.size.width,
                                    frame.size.height / 2);
    _downImageView.frame = CGRectMake(0, frame.size.height / 2, 
                                      frame.size.width, frame.size.height/2);
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self startRender:^(CGContextRef context) {
        CGContextTranslateCTM(context, __label.frame.origin.x, __label.frame.origin.y);
        __label.text = text;
        [__label.layer renderInContext:context];
    }];
}

- (void)renderedImage:(UIImage *)image
{
    _upImageView.image = image;
    _downImageView.image = image;
}


- (void)setPercent:(CGFloat)percent 
          isBorder:(BOOL)border
{
    _percent = percent;
    if (border) {
        percent = -percent / 2;
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 0.001;
        transform = CATransform3DRotate(transform,M_PI * percent, 1, 0, 0);
        _upImageView.hidden = NO;
        _downImageView.hidden = NO;
        if (percent < 0) {
            _upImageView.layer.transform = CATransform3DIdentity;
            [_upImageView setCoverOpacity:0];
            _downImageView.layer.transform = transform;
            [_downImageView setCoverOpacity:-percent * 2];
        }else {
            _upImageView.layer.transform = transform;
            [_upImageView setCoverOpacity:percent * 2];
            _downImageView.layer.transform = CATransform3DIdentity;
            [_downImageView setCoverOpacity:0];
        }
        _percent = 0;
    }else {
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 0.001;
        CATransform3D transform2 = CATransform3DRotate(transform,M_PI * percent, 1, 0, 0);
        if (percent < 0) {
            _downImageView.layer.transform = CATransform3DIdentity;
            [_downImageView setCoverOpacity:0];
            _downImageView.hidden = NO;
            if (percent > 0.5) {
                _upImageView.layer.transform = transform2;
                [_upImageView setCoverOpacity:percent * 2];
            }else _upImageView.hidden = YES;
        }else if (percent < 0){
            _upImageView.hidden = NO;
            _upImageView.layer.transform = CATransform3DIdentity;
            [_upImageView setCoverOpacity:0];
            if (percent < -0.5) {
                _downImageView.layer.transform = transform2;
                [_downImageView setCoverOpacity:-percent * 2];
            }else _downImageView.hidden = YES;
        }else {
            _downImageView.hidden = NO;
            _upImageView.hidden = NO;
            _downImageView.layer.transform = CATransform3DIdentity;
            _upImageView.layer.transform = CATransform3DIdentity;
            [_downImageView setCoverOpacity:0];
            [_upImageView setCoverOpacity:0];
        }
    }
}

- (void)setAnimationPercent:(CGFloat)percent 
                    preview:(Demo2AnimationView *)preview
                   nextview:(Demo2AnimationView *)nextview
{
    _percent = percent;
    if (percent > 0) {
        if (percent < 0.5) {
            _upImageView.hidden = NO;
            _downImageView.hidden = NO;
            nextview.upImageView.hidden = YES;
            nextview.downImageView.hidden = NO;
            
            nextview.downImageView.layer.transform = CATransform3DIdentity;
            [nextview.downImageView setCoverOpacity:0];
            _upImageView.layer.transform = CATransform3DIdentity;
            [_upImageView setCoverOpacity:0];
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 0.001;
            _downImageView.layer.transform = CATransform3DRotate(transform,-M_PI * percent, 1, 0, 0);
            [_downImageView setCoverOpacity:percent * 2];
            [self.superview insertSubview:nextview
                             belowSubview:self];
        }else {
            nextview.upImageView.hidden = NO;
            nextview.downImageView.hidden = NO;
            _upImageView.hidden = NO;
            _downImageView.hidden = YES;
            
            _downImageView.layer.transform = CATransform3DIdentity;
            [_downImageView setCoverOpacity:0];
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 0.001;
            _upImageView.layer.transform = CATransform3DIdentity;
            [_upImageView setCoverOpacity:0];
            nextview.upImageView.layer.transform = CATransform3DRotate(transform,M_PI * (1-percent), 1, 0, 0);
            [nextview.upImageView setCoverOpacity:(1-percent) * 2];
            [self.superview insertSubview:self
                             belowSubview:nextview];
        }
    }else {
        if (percent > -0.5) {
            _upImageView.hidden = NO;
            _downImageView.hidden = NO;
            preview.upImageView.hidden = NO;
            preview.downImageView.hidden = YES;
            
            _downImageView.layer.transform = CATransform3DIdentity;
            [_downImageView setCoverOpacity:0];
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 0.001;
            _upImageView.layer.transform = CATransform3DRotate(transform,-M_PI * percent, 1, 0, 0);
            [_upImageView setCoverOpacity:-percent*2];
            preview.upImageView.layer.transform = CATransform3DIdentity;
            [preview.upImageView setCoverOpacity:0];
            [self.superview insertSubview:preview
                             belowSubview:self];
        }else {
            _upImageView.hidden = YES;
            _downImageView.hidden = NO;
            preview.upImageView.hidden = NO;
            preview.downImageView.hidden = NO;
            
            _upImageView.layer.transform = CATransform3DIdentity;
            [_upImageView setCoverOpacity:0];
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 0.001;
            preview.downImageView.layer.transform = CATransform3DRotate(transform,M_PI * (-1-percent), 1, 0, 0);
            [preview.downImageView setCoverOpacity:(-1-percent)*2];
            preview.upImageView.layer.transform = CATransform3DIdentity;
            [preview.upImageView setCoverOpacity:0];
            [self.superview insertSubview:self
                             belowSubview:preview];
        }
    }
}

- (void)turnNextPreview:(Demo2AnimationView *)preview 
               nextview:(Demo2AnimationView *)nextview
              overblock:(MTFlipAnimationOverBlock)overblock
{
    if (_percent < 0.5) {
        [UIView animateWithDuration:0.3
                              delay:0 
                            options:UIViewAnimationCurveLinear
                         animations:^
         {
             CATransform3D transform = CATransform3DIdentity;
             transform.m34 = 0.001;
             _downImageView.layer.transform = CATransform3DRotate(transform, -M_PI / 2, 1, 0, 0);
             [_downImageView setCoverOpacity:1];
         } completion:^(BOOL finished) 
         {
             [self.superview insertSubview:nextview aboveSubview:self];
             _downImageView.hidden = YES;
             CATransform3D transform = CATransform3DIdentity;
             transform.m34 = 0.001;
             nextview.upImageView.hidden = NO;
             nextview.upImageView.layer.transform = CATransform3DRotate(transform, M_PI / 2, 1, 0, 0);
             [nextview.upImageView setCoverOpacity:1];
             if (finished) {
                 [nextview.upImageView coverOpacityAnimation:0
                                                    duration:0.6];
                 [UIView animateWithDuration:0.6
                                       delay:0
                                     options:UIViewAnimationCurveEaseOut
                                  animations:^
                  {
                      nextview.upImageView.layer.transform = CATransform3DIdentity;
                  } completion:^(BOOL finished) 
                  {
                      if (overblock) {
                          overblock(finished);
                      }
                  }];
             }else {
                 if (overblock) {
                     overblock(finished);
                 }
             }
         }];
    }else {
        [nextview.upImageView coverOpacityAnimation:0
                                           duration:0.6];
        [UIView animateWithDuration:0.6
                              delay:0
                            options:UIViewAnimationCurveEaseOut
                         animations:^
         {
             nextview.upImageView.layer.transform = CATransform3DIdentity;
         } completion:^(BOOL finished) 
         {
             if (overblock) {
                 overblock(finished);
             }
         }];
    }
}

- (void)turnPreviousPreview:(Demo2AnimationView *)preview 
                   nextview:(Demo2AnimationView *)nextview
                  overblock:(MTFlipAnimationOverBlock)overblock
{
    if (_percent > -0.5) {
        [UIView animateWithDuration:0.3
                              delay:0 
                            options:UIViewAnimationCurveLinear
                         animations:^
         {
             CATransform3D transform = CATransform3DIdentity;
             transform.m34 = 0.001;
             _upImageView.layer.transform = CATransform3DRotate(transform, M_PI / 2, 1, 0, 0);
             [_upImageView setCoverOpacity:1];
         } completion:^(BOOL finished) 
         {
             [self.superview insertSubview:preview aboveSubview:self];
             _upImageView.hidden = YES;
             CATransform3D transform = CATransform3DIdentity;
             transform.m34 = 0.001;
             preview.downImageView.hidden = NO;
             preview.downImageView.layer.transform = CATransform3DRotate(transform, -M_PI / 2, 1, 0, 0);
             [preview.downImageView setCoverOpacity:1];
             if (finished) {
                 [preview.downImageView coverOpacityAnimation:0
                                                    duration:0.6];
                 [UIView animateWithDuration:0.6
                                       delay:0
                                     options:UIViewAnimationCurveEaseOut
                                  animations:^
                  {
                      preview.downImageView.layer.transform = CATransform3DIdentity;
                  } completion:^(BOOL finished) 
                  {
                      if (overblock) {
                          overblock(finished);
                      }
                  }];
             }else {
                 if (overblock) {
                     overblock(finished);
                 }
             }
         }];
    }else {
        [nextview.upImageView coverOpacityAnimation:0
                                           duration:0.6];
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationCurveEaseOut
                         animations:^
         {
             preview.downImageView.layer.transform = CATransform3DIdentity;
         } completion:^(BOOL finished) 
         {
             if (overblock) {
                 overblock(finished);
             }
         }];
    }
}
- (void)restorePreview:(Demo2AnimationView *)preview
              nextview:(Demo2AnimationView *)nextview 
             overblock:(MTFlipAnimationOverBlock)overblock
{
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [preview setPercent:0
                               isBorder:NO];
                         [nextview setPercent:0
                                 isBorder:NO];
                         [self setPercent:0
                                 isBorder:NO];
                     } completion:^(BOOL finished) {
                         if (overblock) {
                             overblock(finished);
                         }
                     }];
}

- (void)restoreAndShake:(MTFlipAnimationOverBlock)block
{
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [self setPercent:0
                                 isBorder:NO];
                     } completion:^(BOOL finished) {
                         if (block) {
                             block(finished);
                         }
                     }];
}

@end
