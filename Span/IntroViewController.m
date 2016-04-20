//
//  IntroViewController.m
//  Span
//
//  Created by Eugene Tulushev on 11/04/16.
//  Copyright © 2016 Eugene Tulushev. All rights reserved.
//

#import "Constants.h"
#import "IntroViewController.h"


NSString * const LogoImageName = @"Logo-walkthrough";
NSString * const ShapeFirstImageName = @"Illustration-Walkthrough2";
NSString * const ShapeSecondImageName = @"Illustration-Walkthrough3";
NSString * const ButtonImageName = @"Button-Agree";

NSString * const FontNameAkkurat = @"Akkurat";
NSString * const FontNameWorkSansBold = @"WorkSans-Bold";
NSString * const FontNameWorkSansRegular = @"WorkSans-Regular";

NSString * const FirstText = @"Life is a series of natural and\nspontaneous changes. Don't\nresist them; that only creates\nsorrow. Let reality be a reality.\nLet things flow naturally forward\nin whatever way they like.";
NSString * const SecondText = @"But, what if you could make just\none picture of something of your\nchoice. And then watch it\nchange.";
NSString * const ThirdText = @"What is the final state of a change?\nWhen to stop the process?\nWhat if there is no universal end?\nWhat if there is no universal truth?";


@interface IntroViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UIImageView *shapesFirst;
@property (nonatomic, strong) UIImageView *shapesSecond;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *labelFirst;
@property (nonatomic, strong) UILabel *labelSecond;
@property (nonatomic, strong) UILabel *labelThird;

@end


@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGSize viewSize = self.view.bounds.size;
    
    UIColor *backgroundColor = [UIColor colorWithRed:RedComponent
                                               green:GreenComponent
                                                blue:BlueComponent
                                               alpha:1.0];
    self.view.backgroundColor = backgroundColor;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(viewSize.width * 3.0, viewSize.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    CGFloat logoFactorHeight = 1.0 / 5.8;
    self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:LogoImageName]];
    self.logo.center = CGPointMake(self.view.center.x, (CGFloat)round(viewSize.height * logoFactorHeight));
    [self.scrollView addSubview:self.logo];
    
    UIImage *shapesFirstImage = [UIImage imageNamed:ShapeFirstImageName];
    UIImage *shapesSecondImage = [UIImage imageNamed:ShapeSecondImageName];
    CGFloat shapesFactorHeight = 0.2;
    self.shapesFirst = [[UIImageView alloc] initWithImage:shapesFirstImage];
    CGFloat shapesHorizontalCenter = (CGFloat)round(viewSize.height * shapesFactorHeight);
    self.shapesFirst.center = CGPointMake(self.view.center.x + viewSize.width, shapesHorizontalCenter);
    [self.scrollView addSubview:self.shapesFirst];
    self.shapesSecond = [[UIImageView alloc] initWithImage:shapesSecondImage];
    self.shapesSecond.center = CGPointMake(self.view.center.x + viewSize.width * 2.0, shapesHorizontalCenter);
    [self.scrollView addSubview:self.shapesSecond];
    
    CGFloat buttonFactorHeight = 0.89;
    UIImage *buttonImage = [UIImage imageNamed:ButtonImageName];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    self.button.center = CGPointMake(self.view.center.x + viewSize.width * 2.0, (CGFloat)round(viewSize.height * buttonFactorHeight));
    [self.button setImage:buttonImage
                 forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(agreed) forControlEvents:UIControlEventTouchDown];
    [self.scrollView addSubview:self.button];
    
    CGFloat pageControlFactorHeight = 0.74;
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.currentPage = 0;
    NSUInteger numberOfPages = 3;
    self.pageControl.numberOfPages = numberOfPages;
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:numberOfPages];
    self.pageControl.frame = CGRectMake(0.0, 0.0, pageControlSize.width, pageControlSize.height);
    self.pageControl.center = CGPointMake(self.view.center.x, (CGFloat)round(viewSize.height * pageControlFactorHeight));
    [self.view addSubview:self.pageControl];
    
    UIFont *akkurat = [UIFont fontWithName:FontNameAkkurat size:20.0];
    self.labelFirst = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.labelFirst.text = FirstText;
    self.labelFirst.textColor = [UIColor whiteColor];
    self.labelFirst.numberOfLines = 0;
    self.labelFirst.font = akkurat;
    CGSize labelFirstSize = [self.labelFirst.text sizeWithAttributes:@{NSFontAttributeName:akkurat}];
    self.labelFirst.frame = CGRectMake(0.0, 0.0, labelFirstSize.width, labelFirstSize.height);
    CGFloat logoBottom = CGRectGetMaxY(self.logo.frame);
    CGFloat pageTop = CGRectGetMinY(self.pageControl.frame);
    CGFloat firstCenterHeight = (CGFloat)round(logoBottom + (pageTop - logoBottom) / 2.0);
    self.labelFirst.center = CGPointMake(self.view.center.x, firstCenterHeight);
    [self.scrollView addSubview:self.labelFirst];
    
    self.labelSecond = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.labelSecond.text = SecondText;
    self.labelSecond.textColor = [UIColor whiteColor];
    self.labelSecond.numberOfLines = 0;
    self.labelSecond.font = akkurat;
    CGSize labelSecondSize = [self.labelSecond.text sizeWithAttributes:@{NSFontAttributeName:akkurat}];
    self.labelSecond.frame = CGRectMake(0.0, 0.0, labelSecondSize.width, labelSecondSize.height);
    CGFloat shapeBottom = CGRectGetMaxY(self.shapesFirst.frame);
    CGFloat secondCenterHeight = (CGFloat)round(shapeBottom + (pageTop - shapeBottom) / 2.0);
    self.labelSecond.center = CGPointMake(self.view.center.x + viewSize.width, secondCenterHeight);
    [self.scrollView addSubview:self.labelSecond];
    
    self.labelThird = [[UILabel alloc] initWithFrame:self.view.bounds];
    self.labelThird.text = ThirdText;
    self.labelThird.textColor = [UIColor whiteColor];
    self.labelThird.numberOfLines = 0;
    self.labelThird.font = akkurat;
    CGSize labelThirdSize = [self.labelThird.text sizeWithAttributes:@{NSFontAttributeName:akkurat}];
    self.labelThird.frame = CGRectMake(0.0, 0.0, labelThirdSize.width, labelThirdSize.height);
    self.labelThird.center = CGPointMake(self.view.center.x + viewSize.width * 2.0, secondCenterHeight);
    [self.scrollView addSubview:self.labelThird];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    CGFloat fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

- (void)agreed {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:SkipIntro];
    }];
}

@end
