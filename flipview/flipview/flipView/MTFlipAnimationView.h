//
//  FZDetailFlipView.h
//  Photocus
//
//  Created by zrz on 12-5-8.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MTBlockOperation.h"

typedef void(^MTFlipAnimationOverBlock)(BOOL finish);

@interface MTFlipAnimationView : UIView

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, strong)   NSString    *indentify;

//this method will be called when this view be sent to cache.
- (void)clean;

/**
 * 
 *
 */
- (NSOperationQueue*)mainQueue;

- (void)startRender:(MTBlockOperationBlock)block;

// override to get the rendered image.
- (void)renderedImage:(UIImage*)image;

//aniamtion method should must be override.
- (void)setPercent:(CGFloat)percent 
              isUp:(BOOL)up 
          isBorder:(BOOL)border;
- (void)setAnimationPercent:(CGFloat)percent 
                 coverdView:(MTFlipAnimationView*)coverdView;
- (void)moveUpOut:(MTFlipAnimationOverBlock)block 
       coverdView:(MTFlipAnimationView*)coverdView;
- (void)moveDownIn:(MTFlipAnimationOverBlock)block 
        coverdView:(MTFlipAnimationView*)coverdView;
- (void)restoreUp:(MTFlipAnimationView*)up
             down:(MTFlipAnimationView*)down
            block:(MTFlipAnimationOverBlock)block;
- (void)restoreAndShake:(MTFlipAnimationOverBlock)block;

@end
