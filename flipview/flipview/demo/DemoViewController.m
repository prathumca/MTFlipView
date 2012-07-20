//
//  DemoViewController.m
//  flipview
//
//  Created by zrz on 12-7-16.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import "DemoViewController.h"
#import "MTDragFlipView.h"
#import "DemoShowView.h"
#import "DemoAnimationView.h"
#import "DemoMenuViewController.h"

@interface DemoViewController ()
<MTDragFlipViewDelegate>

@end

@implementation DemoViewController {
    DemoMenuViewController  *_menuController;
    MTDragFlipView  *_flipView;
    DemoShowView    *_showerView;
}

@synthesize model = _model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.model = [[DemoModel alloc] init];
        self.title = @"Demo1";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _flipView = [[MTDragFlipView alloc] initWithType:MTFlipViewTypeUpAbove];
    _flipView.frame = CGRectMake(0, 0, 320, 416);
    _flipView.delegate = self;
    _flipView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_flipView];
    
    
    _showerView = [[DemoShowView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    [_flipView reloadData];
    
    _menuController = [[DemoMenuViewController alloc] initWithStyle:UITableViewStylePlain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    _flipView = nil;
    _showerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UIView*)flipView:(MTDragFlipView*)flipView subViewAtIndex:(NSInteger)index
{
    _showerView.label.text = [_model.data objectAtIndex:index];
    if (index == 0) {
        _showerView.backgroundColor = [UIColor redColor];
    }else _showerView.backgroundColor = [UIColor blueColor];
    return _showerView;
}

- (UIView*)flipView:(MTDragFlipView*)flipView backgroudView:(NSInteger)index left:(BOOL)isLeft
{
    if (isLeft) {
        return _menuController.view;
    }
    return nil;
}

- (NSInteger)numberOfFlipViewPage:(MTDragFlipView*)flipView
{
    return [_model.data count];
}

- (MTFlipAnimationView*)flipView:(MTDragFlipView*)flipView dragingView:(NSInteger)index
{
    static NSString *indentify = @"demoView";
    DemoAnimationView *view = (DemoAnimationView*)[flipView dequeueReusableViewWithIdentifier:indentify];
    if (!view) {
        view = [[DemoAnimationView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        view.indentify = indentify;
    }
    view.text = [_model.data objectAtIndex:index];
    
    if (index == 0) {
        view.backgroundColor = [UIColor redColor];
    }else view.backgroundColor = [UIColor blackColor];
    return view;
}

- (void)flipView:(MTDragFlipView *)flipView reloadView:(DemoAnimationView *)view atIndex:(NSInteger)index
{
    
    view.text = [_model.data objectAtIndex:index];
    
    if (index == 0) {
        view.backgroundColor = [UIColor redColor];
    }else view.backgroundColor = [UIColor blueColor];
}

@end
