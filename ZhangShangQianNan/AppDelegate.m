//
//  AppDelegate.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/14.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsListViewController.h"
#import "ForumDisplayViewController.h"
#import "ForumViewController.h"
#import "ForumPicViewController.h"
#import "MyTableViewController.h"
#import "Config.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [NSThread sleepForTimeInterval:2];
    //ShareSDK注册
    [ShareSDK registerApp:ShareAppKey];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"];
//    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
//                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                              redirectUri:@"http://www.sharesdk.cn"
//                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
    
    //添加Facebook应用  注册网址 https://developers.facebook.com
//    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
//                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
//    
//    //添加Twitter应用  注册网址  https://dev.twitter.com
//    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
//                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
//                                redirectUri:@"http://www.sharesdk.cn"];
    [ShareSDK connectSMS];
    [ShareSDK connectMail];
    
    //新闻视图
    NewsListViewController *newsController = [[NewsListViewController alloc] init];
    UINavigationController *newsNavigation = [[UINavigationController alloc] initWithRootViewController:newsController];
    [newsNavigation setTabBarItem:[self taBarItemWithTitle:@"新闻" Image:@"icon-home.png" SelectedImage:@"icon-homefill.png"]];
    
    //新帖
    ForumDisplayViewController *displayController = [[ForumDisplayViewController alloc] init];
    UINavigationController *displayNavigation = [[UINavigationController alloc] initWithRootViewController:displayController];
    [displayNavigation setTabBarItem:[self taBarItemWithTitle:@"帖子" Image:@"icon-time.png" SelectedImage:@"icon-timefill.png"]];
    
    //板块
    ForumViewController *forumController = [[ForumViewController alloc] init];
    UINavigationController *forumNavigation = [[UINavigationController alloc] initWithRootViewController:forumController];
    UITabBarItem *formTabBarItem = [self taBarItemWithTitle:nil Image:@"icon-roundaddfillbig.png" SelectedImage:@"icon-roundadd-blue.png"];
    [formTabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
    [forumNavigation setTabBarItem:formTabBarItem];
    
    //图片
    ForumPicViewController *picController = [[ForumPicViewController alloc] init];
    UINavigationController *picNavigation = [[UINavigationController alloc] initWithRootViewController:picController];
    [picNavigation setTabBarItem:[self taBarItemWithTitle:@"图片" Image:@"icon-pic.png" SelectedImage:@"icon-picfill.png"]];
    
    //个人中心
    MyTableViewController *myController = [[MyTableViewController alloc] init];
    UINavigationController *myNavigation = [[UINavigationController alloc] initWithRootViewController:myController];
    [myNavigation setTabBarItem:[self taBarItemWithTitle:@"我的" Image:@"icon-my.png" SelectedImage:@"icon-myfill.png"]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:@[newsNavigation,displayNavigation,forumNavigation,picNavigation,myNavigation]];
    [tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"barbg.png"]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"barbg.png"] forBarMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"barbg.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
     
    return YES;
}

- (UITabBarItem *)taBarItemWithTitle:(NSString *)title Image:(NSString *)image SelectedImage:(NSString *)selectedImage;{
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    if (title) {
        [tabBarItem setTitle:title];
    }
    if (image) {
        UIImage *newImage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabBarItem setImage:newImage];
    }
    if (selectedImage) {
        UIImage *newSelectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [tabBarItem setSelectedImage:newSelectedImage];
    }
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.34 green:0.67 blue:0.89 alpha:1.00]} forState:UIControlStateSelected];
    return tabBarItem;
}

- (void)showMask{
    CALayer *maskLayer = [[CALayer alloc] init];
    [maskLayer setFrame:[UIScreen mainScreen].bounds];
    [maskLayer setBackgroundColor:[UIColor blackColor].CGColor];
    [maskLayer setOpacity:0.5];
    [self.window.layer addSublayer:maskLayer];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.dsxcms.dsxcmsForIPhone" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"dsxcmsForIPhone" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"dsxcmsForIPhone.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
