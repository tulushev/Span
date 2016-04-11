//
//  AppDelegate.m
//  Span
//
//  Created by Eugene Tulushev on 11/04/16.
//  Copyright © 2016 Eugene Tulushev. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageViewController.h"
#import "IntroViewController.h"


NSString * const SkipIntro = @"SkipIntro";


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{SkipIntro : @NO}];
    BOOL skipIntro = [(NSNumber *)[defaults valueForKey:SkipIntro] boolValue];
    
    if (skipIntro) {
        ImageViewController *imageViewController = [[ImageViewController alloc] init];
        self.window.rootViewController = imageViewController;
    } else {
        IntroViewController *introViewController = [[IntroViewController alloc] init];
        self.window.rootViewController = introViewController;
    }
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


@end
