//
//  AppDelegate.m
//  SmbFileExplorer
//
//  Created by wgl on 15/3/5.
//  Copyright (c) 2015年 wgl. All rights reserved.
//

#import "AppDelegate.h"
#import "BackgroundTask.h"

@interface AppDelegate ()
@property (nonatomic,strong) BackgroundTask * bgTask;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSArray * array1 = [PersistenceManager retrievalWithKey:UserDefaultKeyForUploadModal];
    if (array1) {
        [[FileTransmissionViewController shareUploadVC]reAddAllTasks:array1];
    }
    NSArray * array2 = [PersistenceManager retrievalWithKey:UserDefaultKeyForDownloadModal];
    if (array2) {
        [[FileTransmissionViewController shareDownloadVC]reAddAllTasks:array2];
    }
    self.bgTask = [[BackgroundTask alloc]init];
    [self.bgTask startBackgroundTasks:1 target:self selector:@selector(backgroundCallback:)];
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

-(void) backgroundCallback:(id)info
{
    //NSLog(@"########");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //[[FileTransmissionViewController shareFileTransmissionVC]suspendAllTasks];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[FileTransmissionViewController shareUploadVC].tableView reloadData];
    [[FileTransmissionViewController shareDownloadVC].tableView reloadData];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveTransmissionModal];
    [self.bgTask stopBackgroundTask];
}

- (void)saveTransmissionModal
{
    NSArray * array1 = ((SmbFileTransmissionDataSource *)[FileTransmissionViewController shareDownloadVC].tableView.dataSource).items;
    [PersistenceManager saveData:array1 forKey:UserDefaultKeyForDownloadModal];
    NSArray * array2 = ((SmbFileTransmissionDataSource *)[FileTransmissionViewController shareUploadVC].tableView.dataSource).items;
    [PersistenceManager saveData:array2 forKey:UserDefaultKeyForUploadModal];
}

@end
