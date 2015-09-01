//
//  AppDelegate.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/14.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)showMask;

- (UITabBarItem *)taBarItemWithTitle:(NSString *)title Image:(NSString *)image SelectedImage:(NSString *)selectedImage;
@end

