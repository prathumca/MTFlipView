//
//  Demo2AnimationView.m
//  flipview
//
//  Created by zrz on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Demo2AnimationView.h"
#import <QuartzCore/QuartzCore.h>

@interface Demo2AnimationView()

@property (nonatomic, readonly) UIImageView *upImageView,
                                            *downImageView;

@end

@implementation Demo2AnimationView {
    UIImageView *_upImageView,
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
        
        _upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height / 4, 
                                                                     frame.size.width,
                                                                     frame.size.height / 2)];
        _downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height / 4, 
                                                                       frame.size.width, 
                                                                       frame.size.height / 2)];
        [self addSubview:_upImageView];
        [self addSubview:_downImageView];
        
        _upImageView.backgroundColor = [UIColor blueColor];
        _upImageView.contentMode = UIViewContentModeTop;
        _upImageView.layer.anchorPoint = CGPointMake(0.5, 1);
        _upImageView.clipsToBounds = YES;
        _downImageView.backgroundColor = [UIColor redColor];
        _downImageView.contentMode = UIViewContentModeBottom;
        _downImageView.layer.anchorPoint = CGPointMake(0.5, 0);
        _downImageView.clipsToBounds = YES;
        
        self->_imageView = nil;
        
        self.backgroundColor = [UIColor blueColor];
        
        if (!__label) {
            __label = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 220, 300)];
            __label.backgroundColor = [UIColor clearColor];
            __label.numberOfLines = 0;
            __label.textColor = [UIColor whiteColor];
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
              isUp:(BOOL)up 
          isBorder:(BOOL)border
{
    _percent = percent;
    if (border) {
        percent = percent / 2;
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 0.001;
        transform = CATransform3DRotate(transform,-M_PI * percent, 1, 0, 0);
        if (percent < 0) {
            _upImageView.layer.transform = transform;
            _downImageView.layer.transform = CATransform3DIdentity;
        }else {
            _upImageView.layer.transform = CATransform3DIdentity;
            _downImageView.layer.transform = transform;
        }
    }else {
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = 0.001;
        CATransform3D transform2 = CATransform3DRotate(transform,-M_PI * percent, 1, 0, 0);
        if (percent < 0) {
            _upImageView.layer.transform = CATransform3DIdentity;
            if (percent > -0.5) 
                _downImageView.layer.transform = transform2;
            else _downImageView.hidden = YES;
        }else {
            _downImageView.layer.transform = CATransform3DIdentity;
            if (percent < 0.5) {
                _upImageView.layer.transform = transform2;
            }else _upImageView.hidden = YES;
        }
    }
}

- (void)setAnimationPercent:(CGFloat)percent 
                 coverdView:(Demo2AnimationView*)coverdView
{
    _percent = percent;
    if (percent > 0) {
        if (percent < 0.5) {
            _upImageView.hidden = YES;
            _downImageView.hidden = NO;
            coverdView.upImageView.hidden = NO;
            coverdView.downImageView.hidden = NO;
            
            _downImageView.layer.transform = CATransform3DIdentity;
            coverdView.upImageView.layer.transform = CATransform3DIdentity;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 0.001;
            coverdView.downImageView.layer.transform = CATransform3DRotate(transform,-M_PI * percent, 1, 0, 0);
            [self.superview insertSubview:self
                             belowSubview:coverdView];
        }else {
            _upImageView.hidden = NO;
            _downImageView.hidden = NO;
            coverdView.upImageView.hidden = NO;
            coverdView.downImageView.hidden = YES;
            
            _downImageView.layer.transform = CATransform3DIdentity;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 0.001;
            _upImageView.layer.transform = CATransform3DRotate(transform,M_PI * (1-percent), 1, 0, 0);
            coverdView.upImageView.layer.transform = CATransform3DIdentity;
            [self.superview insertSubview:self
                             aboveSubview:coverdView];
        }
    }else {
        if (percent > -0.5) {
            _upImageView.hidden = NO;
            _downImageView.hidden = YES;
            coverdView.upImageView.hidden = NO;
            coverdView.downImageView.hidden = NO;
            
            _upImageView.layer.transform = CATransform3DIdentity;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 0.001;
            coverdView.upImageView.layer.transform = CATransform3DRotate(transform,-M_PI * percent, 1, 0, 0);
            coverdView.downImageView.layer.transform = CATransform3DIdentity;
            [self.superview insertSubview:self
                             belowSubview:coverdView];
        }else {
            _upImageView.hidden = NO;
            _downImageView.hidden = NO;
            coverdView.upImageView.hidden = YES;
            coverdView.downImageView.hidden = NO;
            
            _upImageView.layer.transform = CATransform3DIdentity;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 0.001;
            _downImageView.layer.transform = CATransform3DRotate(transform,M_PI * (-1-percent), 1, 0, 0);
            coverdView.upImageView.layer.transform = CATransform3DIdentity;
            [self.superview insertSubview:self
                             aboveSubview:coverdView];
        }
    }
}

- (void)moveUpOut:(MTFlipAnimationOverBlock)block 
       coverdView:(Demo2AnimationView*)coverdView
{
    if (coverdView->_percent < 0.5) {
        [UIView animateWithDuration:0.2
                              delay:0 
                            options:UIViewAnimationCurveLinear
                         animations:^
         {
             CATransform3D transform = CATransform3DIdentity;
             transform.m34 = 0.001;
             _downImageView.layer.transform = CATransform3DRotate(transform, -M_PI / 2, 1, 0, 0);
         } completion:^(BOOL finished) 
         {
             [self.superview insertSubview:self belowSubview:coverdView];
             _downImageView.hidden = YES;
             CATransform3D transform = CATransform3DIdentity;
             transform.m34 = 0.001;
             coverdView.upImageView.hidden = NO;
             coverdView.upImageView.layer.transform = CATransform3DRotate(transform, M_PI / 2, 1, 0, 0);
             if (finished) {
                 [UIView animateWithDuration:0.4
                                       delay:0
                                     options:UIViewAnimationCurveEaseOut
                                  animations:^
                  {
                      coverdView.upImageView.layer.transform = CATransform3DIdentity;
                  } completion:^(BOOL finished) 
                  {
                      if (block) {
                          block(finished);
                      }
                  }];
             }else {
                 if (block) {
                     block(finished);
                 }
             }
         }];
    }else {
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationCurveEaseOut
                         animations:^
         {
             coverdView.upImageView.layer.transform = CATransform3DIdentity;
         } completion:^(BOOL finished) 
         {
             if (block) {
                 block(finished);
             }
         }];
    }
}

- (void)moveDownIn:(MTFlipAnimationOverBlock)block 
        coverdView:(Demo2AnimationView*)coverdView
{
    if (_percent > -0.5) {
        [UIView animateWithDuration:0.2
                              delay:0 
                            options:UIViewAnimationCurveLinear
                         animations:^
         {
             CATransform3D transform = CATransform3DIdentity;
             transform.m34 = 0.001;
             coverdView.upImageView.layer.transform = CATransform3DRotate(transform, M_PI / 2, 1, 0, 0);
         } completion:^(BOOL finished) 
         {
             [self.superview insertSubview:self aboveSubview:coverdView];
             coverdView.upImageView.hidden = YES;
             CATransform3D transform = CATransform3DIdentity;
             transform.m34 = 0.001;
             _downImageView.hidden = NO;
             _downImageView.layer.transform = CATransform3DRotate(transform, -M_PI / 2, 1, 0, 0);
             if (finished) {
                 [UIView animateWithDuration:0.4
                                       delay:0
                                     options:UIViewAnimationCurveEaseOut
                                  animations:^
                  {
                      _downImageView.layer.transform = CATransform3DIdentity;
                  } completion:^(BOOL finished) 
                  {
                      if (block) {
                          block(finished);
                      }
                  }];
             }else {
                 if (block) {
                     block(finished);
                 }
             }
         }];
    }else {
        [UIView animateWithDuration:0.4
                              delay:0
                            options:UIViewAnimationCurveEaseOut
                         animations:^
         {
             _downImageView.layer.transform = CATransform3DIdentity;
         } completion:^(BOOL finished) 
         {
             if (block) {
                 block(finished);
             }
         }];
    }
}
- (void)restoreUp:(MTFlipAnimationView*)up
             down:(MTFlipAnimationView*)down
            block:(MTFlipAnimationOverBlock)block
{
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [up setPercent:0
                                   isUp:NO
                               isBorder:NO];
                         [down setPercent:0
                                     isUp:NO
                                 isBorder:NO];
                         [self setPercent:0
                                     isUp:NO
                                 isBorder:NO];
                     } completion:^(BOOL finished) {
                         if (block) {
                             block(finished);
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
                                     isUp:NO
                                 isBorder:NO];
                     } completion:^(BOOL finished) {
                         if (block) {
                             block(finished);
                         }
                     }];
}

@end
