//
//  AppDelegate.m
//  TiCheck
//
//  Created by Boyi on 3/17/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "APIResourceHelper.h"
#import "ServerCommunicator.h"
#import "BookListViewController.h"
#import "PersonalCenterViewController.h"
#import "AccountEditDetailViewController.h"
#import "AccountEditViewController.h"
#import "PersonalOrderViewController.h"
#import "PassengerEditViewController.h"
#import "PassengerListViewController.h"
#import "CoreData+MagicalRecord.h"

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    //[APIResourceHelper sharedResourceHelper];
    
    /*!
     通知字典不为空之后，接下来所有的view controller中的view will appear 函数都会检查通知字典，不为空则自动导向订阅列表。
     这样的实现可以保证按照storyboard路径寻找，用户可以正常返回个人中心，搜索界面。
     */
    if (launchOptions != nil) {
        notificationOption = launchOptions;
    }
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"tac.sbhhbs.com"];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    if (netStatus == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"服务器维护中" message:@"服务器正在例行维护，请稍后再试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"TiCheck.sqlite"];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"receive push notification during running");
    
    /*!
     检查当前view controller是否为个人中心，如果是，直接push到订阅列表
     */
    UIViewController *visibleViewController = nil;
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        NSLog(@"root view controller is a navigation controller");
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        visibleViewController = navigationController.visibleViewController;
        NSLog(@"%@", visibleViewController);
    }
    else {
        NSLog(@"now %@ is presented", self.window.rootViewController.class);
    }
    
    if (visibleViewController != nil) {
        if ([visibleViewController isKindOfClass:[PersonalCenterViewController class]]) {
            NSLog(@"now is personal center view controller presented");
            PersonalCenterViewController *personalViewController = (PersonalCenterViewController*)visibleViewController;
            [personalViewController receivePushNotification:userInfo];
            return;
        }
        else if ([visibleViewController isKindOfClass:[BookListViewController class]])
        {
            NSLog(@"now is book list view controller presented");
            return;
        }
        else if ([visibleViewController isKindOfClass:[AccountEditDetailViewController class]] ||
                 [visibleViewController isKindOfClass:[AccountEditViewController class]] ||
                 [visibleViewController isKindOfClass:[PersonalOrderViewController class]] ||
                 [visibleViewController isKindOfClass:[PassengerEditViewController class]] ||
                 [visibleViewController isKindOfClass:[PassengerListViewController class]])
        {
            [visibleViewController.navigationController popToRootViewControllerAnimated:NO];
            
            /**
             *  此处确定当前现实的root controller为Personal Center
             */
            PersonalCenterViewController * personalViewController = (PersonalCenterViewController*)visibleViewController.navigationController.visibleViewController;
            [personalViewController receivePushNotification:userInfo];
            return;
        }
    }
    
    
    /**
     *  如果不是个人中心，则modal一个新的个人中心，并发送notification
     */
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    PersonalCenterViewController *personalViewController = [storyboard instantiateViewControllerWithIdentifier:@"PersonalCenterViewController"];
    UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:personalViewController];
    viewController.navigationBar.barTintColor = [UIColor colorWithRed:0.05 green:0.64 blue:0.87 alpha:1.0];
    viewController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.window.rootViewController presentViewController:viewController animated:YES completion:^(void){
        [personalViewController receivePushNotification:userInfo];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Token

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //NSLog(@"Token is: %@", deviceToken);
    const unsigned *tokenBytes = [deviceToken bytes];
    mDeviceToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"Token is: %@", mDeviceToken);
    if (mDeviceToken != NULL) {
        [[ServerCommunicator sharedCommunicator] addTokenForCurrentUser:mDeviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed getting token, error: %@", error);
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TiCheck" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TiCheck.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    exit(0);
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
