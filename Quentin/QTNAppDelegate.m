//
//  QTNAppDelegate.m
//  Quentin
//
//  Created by Florian Bürger on 19/02/14.
//  Copyright (c) 2014 keslcod. All rights reserved.
//

#import "QTNAppDelegate.h"
#import "QTNEntryViewController.h"
#import "QTNDebugViewController.h"
#import "QTNURLKeys.h"

@implementation QTNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    QTNEntryViewController *entryViewController = [[QTNEntryViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:entryViewController];
    self.window.rootViewController = navigationController;

    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURL *url = launchOptions[UIApplicationLaunchOptionsURLKey];
    if (![[url scheme] isEqualToString:QTNURLScheme]) {
        return NO;
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (![[url scheme] isEqualToString:QTNURLScheme]) {
        [self showDebugViewWithURL:url];
    }

    NSString *action = [[url baseURL] absoluteString];
    if (![action isEqualToString:QTNNewReminderBaseURL]) {
        [self showDebugViewWithURL:url];
    }

    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    QTNEntryViewController *entryViewController = (QTNEntryViewController *)navigationController.topViewController;
    [entryViewController processURL:url];

    return YES;
}

- (void)showDebugViewWithURL:(NSURL *)url
{
    QTNDebugViewController *debugViewController = [[QTNDebugViewController alloc] init];
    debugViewController.url = url;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:debugViewController];
    [self.window.rootViewController presentViewController:navigationController
                                                 animated:YES
                                               completion:nil];
}

@end
