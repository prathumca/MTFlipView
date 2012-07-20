//
//  FZDetailFlipView.m
//  Photocus
//
//  Created by zrz on 12-5-8.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import "MTFlipAnimationView.h"

static NSMutableDictionary *__queueCache;

@implementation MTFlipAnimationView
{
    MTBlockOperation *_operation;
}

@synthesize indentify = _indentify, imageView = _imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _indentify = @"defaulte";
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _imageView.frame = self.bounds;
}

- (void)clean{
    [_operation cancel];
    _operation.completeBlock = nil;
    _operation.block = nil;
    _operation = nil;
}


- (NSOperationQueue*)mainQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __queueCache = [[NSMutableDictionary alloc] init];
    });
    NSOperationQueue *queue = [__queueCache objectForKey:NSStringFromClass([self class])];
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 4;
        [queue setSuspended:NO];
        [__queueCache setObject:queue forKey:NSStringFromClass([self class])];
    }
    return queue;
}

- (void)startRender:(MTBlockOperationBlock)block
{
    MTBlockOperation *operation = [[MTBlockOperation alloc] init];
    operation.block = block;
    [operation setCompleteBlock:^(UIImage *image) {
        [self renderedImage:image];
    }];
    operation.size = self.bounds.size;
    [self.mainQueue addOperation:operation];
    _operation = operation;
}

- (void)renderedImage:(UIImage*)image
{
    _imageView.image = image;
}


- (void)setPercent:(CGFloat)percent isUp:(BOOL)up isBorder:(BOOL)border{}
- (void)setAnimationPercent:(CGFloat)percent
                    preview:(MTFlipAnimationView *)preview
                   nextview:(MTFlipAnimationView *)nextview{}

- (void)turnNextPreview:(MTFlipAnimationView *)preview 
               nextview:(MTFlipAnimationView *)nextview
              overblock:(MTFlipAnimationOverBlock)overblock{}

- (void)turnPreviousPreview:(MTFlipAnimationView *)preview 
                   nextview:(MTFlipAnimationView *)nextview 
                  overblock:(MTFlipAnimationOverBlock)overblock{}

- (void)restorePreview:(MTFlipAnimationView *)preview
              nextview:(MTFlipAnimationView *)nextview 
             overblock:(MTFlipAnimationOverBlock)overblock{}

- (void)restoreAndShake:(MTFlipAnimationOverBlock)block{}

@end
