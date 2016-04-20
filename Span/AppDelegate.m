//
//  AppDelegate.m
//  Span
//
//  Created by Eugene Tulushev on 11/04/16.
//  Copyright © 2016 Eugene Tulushev. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "ImageViewController.h"
#import "IntroViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ImageViewController *imageViewController = [[ImageViewController alloc] init];
    self.window.rootViewController = imageViewController;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL skipIntro = [(NSNumber *)[defaults valueForKey:SkipIntro] boolValue];
    
    if (!skipIntro) {
        imageViewController.withIntro = YES;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
