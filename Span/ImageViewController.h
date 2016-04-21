//
//  ImageViewController.h
//  Span
//
//  Created by Eugene Tulushev on 11/04/16.
//  Copyright © 2016 Eugene Tulushev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic) BOOL withIntro;

- (void)checkAndGlitchIfNeeded;

@end
