//
//  Demo2ViewController.m
//  flipview
//
//  Created by zrz on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Demo2ViewController.h"
#import "MTDragFlipView.h"

@interface Demo2ViewController ()

@end

@implementation Demo2ViewController {
    MTDragFlipView  *_flipView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Demo2";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _flipView = [[MTDragFlipView alloc] initWithType:MTFlipViewTypeShowAbove];
    _flipView.frame = CGRectMake(0, 0, 320, 460);
    [self.view addSubview:_flipView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    _flipView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
