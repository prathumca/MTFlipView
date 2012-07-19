//
//  Demo2ViewController.m
//  flipview
//
//  Created by zrz on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Demo2ViewController.h"
#import "MTDragFlipView.h"
#import "DemoModel.h"
#import "Demo2AnimationView.h"
#import "DemoShowView.h"

@interface Demo2ViewController ()
<MTDragFlipViewDelegate>

@end

@implementation Demo2ViewController {
    MTDragFlipView  *_flipView;
    DemoShowView    *_showView;
}

@synthesize model = _model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Demo2";
        self.model = [[DemoModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _flipView = [[MTDragFlipView alloc] initWithType:MTFlipViewTypeShowAbove];
    _flipView.frame = CGRectMake(0, 0, 320, 416);
    _flipView.delegate = self;
    _flipView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_flipView];
    
    _showView = [[DemoShowView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    
    [_flipView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    _flipView = nil;
    _showView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - flip view delegate

- (UIView*)flipView:(MTDragFlipView*)flipView subViewAtIndex:(NSInteger)index
{
    _showView.label.text = [self.model.data objectAtIndex:index];
    return _showView;
}

- (UIView*)flipView:(MTDragFlipView*)flipView backgroudView:(NSInteger)index left:(BOOL)isLeft
{
    return nil;
}


- (NSInteger)numberOfFlipViewPage:(MTDragFlipView*)flipView
{
    return [self.model.data count];
}

- (MTFlipAnimationView*)flipView:(MTDragFlipView*)flipView dragingView:(NSInteger)index
{
    static NSString *indentify = @"flipView";
    Demo2AnimationView *view = (Demo2AnimationView*)[flipView viewByIndentify:indentify];
    if (!view) {
        view = [[Demo2AnimationView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        view.indentify = indentify;
    }
    view.text = [self.model.data objectAtIndex:index];
    return view;
}

@end
