//
//  AppDelegate.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/5.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSArray * array = [PersistenceManager retrievalWithKey:UserDefaultKeyForTransmissionModal];
    if (array) {
        [[FileTransmissionViewController shareFileTransmissionVC]reAddAllTasks:array];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //[[FileTransmissionViewController shareFileTransmissionVC]suspendAllTasks];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[FileTransmissionViewController shareFileTransmissionVC].tableView reloadData];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveTransmissionModal];
}

- (void)saveTransmissionModal
{
    NSArray * array = ((SmbFileTransmissionDataSource *)[FileTransmissionViewController shareFileTransmissionVC].tableView.dataSource).items;
    [PersistenceManager saveData:array forKey:UserDefaultKeyForTransmissionModal];
}

@end
