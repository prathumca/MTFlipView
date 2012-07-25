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

@interface MTFlipAnimationView : UIView {
    UIImageView *_imageView;
}

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
          isBorder:(BOOL)border;
- (void)setAnimationPercent:(CGFloat)percent 
                    preview:(MTFlipAnimationView*)preview
                   nextview:(MTFlipAnimationView*)nextview;

- (void)turnPreviousPreview:(MTFlipAnimationView*)preview 
                   nextview:(MTFlipAnimationView*)nextview
                  overblock:(MTFlipAnimationOverBlock)overblock;

- (void)turnNextPreview:(MTFlipAnimationView*)preview 
               nextview:(MTFlipAnimationView*)nextview
              overblock:(MTFlipAnimationOverBlock)overblock;

- (void)restorePreview:(MTFlipAnimationView*)preview
              nextview:(MTFlipAnimationView*)nextview
             overblock:(MTFlipAnimationOverBlock)overblock;

- (void)restoreAndShake:(MTFlipAnimationOverBlock)block;

@end
