//
//  AppDelegate.m
//  DHToolkit
//
//  Created by Tim Shi on 12/21/11.
//  Copyright (c) 2011 www.timshi.com. All rights reserved.
//

#import "AppDelegate.h"
#import "TestFlight.h"
#import "DHStreamTVC.h"
#import "Parse/Parse.h"
#import "DH_PFStreamTVC.h"
#import "UIBarButtonItem+CustomImage.h"
#import "Parse/PFPush.h"

@interface AppDelegate()
{
  int mNetworkActivityCounter;  
}
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

#define kTestFlightTeamID @"bd3d87cddcb2bc398c93be36bbbf4307_MjQ3MzAyMDExLTA4LTIyIDEzOjMzOjA5LjQ4MDY3OA"

- (void)autosave:(id)context
{
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Error in autosave from Photo_PF: %@ %@", [error localizedDescription], [error userInfo]);
    }
}

- (void)callAutoSave
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autosave:) object:self.managedObjectContext];
    // request a new autosave in a few tenths of a second
    [self performSelector:@selector(autosave:) withObject:self.managedObjectContext afterDelay:0.2];
}

- (void)configureAppearance
{
//    UIImage *backButton = [UIImage imageNamed:@"backArrow.png"];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"black.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 10)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"navbarblack.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forBarMetrics:UIBarMetricsDefault];
    [[[UINavigationBar appearance] layer] setShadowColor:[UIColor blackColor].CGColor];
    [[[UINavigationBar appearance] layer] setShadowOffset:CGSizeMake(0, 3)];
    [[[UINavigationBar appearance] layer] setMasksToBounds:NO];
//    [[UINavigationBar appearance] setBackBarButtonItem:[UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"backarrow.png"] target:nil action:nil]];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor, 
      [UIFont fontWithName:@"LubalinGraphLT-Demi" size:0.0], UITextAttributeFont, nil]];
}

- (void)setupDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id obj = [defaults objectForKey:DH_SORT_BY_TIME_DEFAULT_KEY];
    if (!obj) {
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], DH_SORT_BY_TIME_DEFAULT_KEY, [NSNumber numberWithBool:YES], DH_PUBLIC_VIEW_KEY, nil]];
        [defaults synchronize];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureAppearance];
    [self setupDefaults];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(incrementNetworkActivity:) name:kDHIncrementNetworkActivityNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(decrementNetworkActivity:) name:kDHDecrementNetworkActivityNotification object:nil];
    id rootVC = self.window.rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *rootNav = (UINavigationController *)rootVC;
        id navVisibleVC = rootNav.visibleViewController;
        if ([navVisibleVC isKindOfClass:[DHStreamTVC class]]) {
            DHStreamTVC *streamTVC = (DHStreamTVC *)navVisibleVC;
            streamTVC.managedObjectContext = self.managedObjectContext;
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callAutoSave) name:@"AutoSaveRequested" object:nil];
    BOOL isDir;
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths lastObject];
    cachePath = [cachePath stringByAppendingPathComponent:PHOTO_CACHE_NAME];
    if (!([manager fileExistsAtPath:cachePath isDirectory:&isDir] && isDir)) {
        [manager createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    DH_PFStreamTVC *stream = [[DH_PFStreamTVC alloc] initInManagedObjectContext:self.managedObjectContext];
    stream.context = self.managedObjectContext;
    UINavigationController *streamNav = [[UINavigationController alloc] initWithRootViewController:stream];
    self.window.rootViewController = streamNav;
//    [TestFlight takeOff:kTestFlightTeamID];
    [Parse setFacebookApplicationId:kDH_FACEBOOK_ID];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Tell Parse about the device token.
    [PFPush storeDeviceToken:newDeviceToken];
    // Subscribe to the global broadcast channel.
    [PFPush subscribeToChannelInBackground:@""];
}

- (void)application:(UIApplication *)application 
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

#pragma mark - URL Open Handling

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[PFUser facebook] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[PFUser facebook] handleOpenURL:url]; 
}

#pragma mark - NetworkActivityIndicator

- (void)incrementNetworkActivity:(NSNotification *)notify {
    ++mNetworkActivityCounter;
    if (1 == mNetworkActivityCounter) {
        UIApplication *app = [UIApplication sharedApplication];
        [app setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)decrementNetworkActivity:(NSNotification *)notify {
    --mNetworkActivityCounter;
    if (0 == mNetworkActivityCounter) {
        UIApplication *app = [UIApplication sharedApplication];
        [app setNetworkActivityIndicatorVisible:NO];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DHToolkit" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DHToolkit.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
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
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
