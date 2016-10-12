//
//  AppDelegate.m
//  Simple Calorie For iPad
//
//  Created by Yaxin Yuan on 16/9/8.
//  Copyright © 2016年 Yaxin Yuan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-9661807512900472~1632235945"];
    return YES;
}


@end
