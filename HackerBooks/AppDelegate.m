//
//  AppDelegate.m
//  HackerBooks
//
//  Created by Joan on 28/03/15.
//  Copyright (c) 2015 Biscarri. All rights reserved.
//

#import "AppDelegate.h"
#import "Settings.h"
#import "AGTLibrary.h"
#import "AGTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    AGTLibrary *library = [self setupApp];
    AGTableViewController *tableViewController = [[AGTableViewController alloc] initWithLibrary:library style:UITableViewStylePlain];
    
    self.window.rootViewController = tableViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (AGTLibrary*)setupApp
{
    //Getting file URL
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *fileUrl = [[fileManager URLsForDirectory:NSDocumentDirectory
                                          inDomains:NSUserDomainMask] lastObject];
    fileUrl = [fileUrl URLByAppendingPathComponent:JSON_FILE_NAME];
    
    //If I haven't download JSON yet, I'll do now and I'll save It
    NSData * jsonData;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:USER_DEFAULTS_JSON_DONWLOADED]) {
        NSURL *jsonUrl = [NSURL URLWithString:URL_JSON];
        jsonData = [NSData dataWithContentsOfURL:jsonUrl];
        if (jsonData)
        {
            BOOL writeResult = [jsonData writeToURL:fileUrl atomically:YES];
            if (writeResult)
            {
                //Mark json as downloaded
                [userDefaults setObject:@(1) forKey:USER_DEFAULTS_JSON_DONWLOADED];
                //Store a NSDictionary to manage favorites
                [userDefaults setObject:[NSDictionary dictionary] forKey:USER_DEFAULTS_FAVORITES];
                [userDefaults synchronize];
            }
        }       
    }else{
        jsonData = [NSData dataWithContentsOfURL:fileUrl];
    }
    AGTLibrary *library = [[AGTLibrary alloc] initWithJSONData:jsonData];
    return library;
    
    
}

@end
