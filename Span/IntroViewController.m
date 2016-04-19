//
//  IntroViewController.m
//  Span
//
//  Created by Eugene Tulushev on 11/04/16.
//  Copyright © 2016 Eugene Tulushev. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;

@end


@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.scrollView];
}

@end
