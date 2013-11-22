//
//  FJViewController.m
//  TrackMenu
//
//  Created by fengjia on 13-11-20.
//  Copyright (c) 2013年 fengjia. All rights reserved.
//

#import "FJViewController.h"
#import "FJTrackMenu.h"
@interface FJViewController ()

@end

@implementation FJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidAppear:(BOOL)animated {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(320 - 80, 450-20, 40, 40);
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)clickBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSArray *titles = [NSArray arrayWithObjects:@"test11hjj", @"test22", @"t3st336", @"tttse4", nil];
    NSArray *images = [NSArray arrayWithObjects:@"track1", @"track2", @"track3", @"track1", nil];
    FJTrackMenu *menu = [[FJTrackMenu alloc] initWithTitles:titles images:images inView:self.view];
    [menu showMenuAtPosition:btn.center trackMenuDirection:1 onSelectMenuItem:^(int menuItemIndex) {
        NSLog(@"press index %d button", menuItemIndex);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:[NSString stringWithFormat:@"press index %d button", menuItemIndex] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
