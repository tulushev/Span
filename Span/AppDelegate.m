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

@interface AppDelegate ()

@property (nonnull, strong) ImageViewController *imageViewController;

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.imageViewController = [[ImageViewController alloc] init];
    self.window.rootViewController = self.imageViewController;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL skipIntro = [(NSNumber *)[defaults valueForKey:SkipIntro] boolValue];
    
    if (!skipIntro) {
        self.imageViewController.withIntro = YES;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.imageViewController checkAndGlitchIfNeeded];
}

@end
