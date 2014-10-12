//
//  AppDelegate.h
//  TiCheck
//
//  Created by Boyi on 3/17/14.
//  Copyright (c) 2014 tac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

#define SERVER_ADDRESS @"192.168.1.2"

@class Reachability;

NSString *mDeviceToken;
NSDictionary *notificationOption;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Reachability *internetReachability;
@property (strong, nonatomic) Reachability *hostReachability;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
