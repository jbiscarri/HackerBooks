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
#import "AGTBookViewController.h"
#import "AGTTableViewController.h"
#import "AGTCoreDataStack.h"
#import "Tag.h"
#import "Book.h"



@interface AppDelegate ()
@property (nonatomic, strong) AGTCoreDataStack *stack;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    self.stack = [AGTCoreDataStack coreDataStackWithModelName:@"Books"];
    
    AGTLibrary *library = [self setupApp];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self configureForPadWithModel:library];
    }else{
        [self configureForPhoneWithModel:library];
    }
    
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
    NSLog(@"%@", fileUrl.path);
    //If I haven't download JSON yet, I'll do now and I'll save It
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:USER_DEFAULTS_JSON_DONWLOADED]) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
            NSURL *jsonUrl = [NSURL URLWithString:URL_JSON];
            NSData * jsonData = [NSData dataWithContentsOfURL:jsonUrl];
            if (jsonData)
            {
                //Parse JSON
                NSError *error;
                id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];
                if (jsonObject && [jsonObject isKindOfClass:[NSArray class]]){
                    NSArray *books = (NSArray*)jsonObject;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Tag TagWithName:@"Favorites"
                               favorites:YES
                                 context:self.stack.context];
                        
                        [Book fillGroupsWithInitialData:books context:self.stack.context];
                        
                        [self.stack saveWithErrorBlock:nil];
                        
                        //Mark json as downloaded
                        [userDefaults setObject:@(1) forKey:USER_DEFAULTS_JSON_DONWLOADED];
                        //Store a NSDictionary to manage favorites
                        [userDefaults setObject:[NSDictionary dictionary] forKey:USER_DEFAULTS_FAVORITES];
                        [userDefaults synchronize];
                    });
                }else{
                    NSLog(@"Error parsing json: %@", error.userInfo);
                }
            }
        });
    }
    return nil;
}

- (void)configureForPadWithModel:(AGTLibrary*)library
{
    
    AGTTableViewController *tableViewController = [[AGTTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self configureFetchersForTableViewController:tableViewController];
    
    //Get first book
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Tag entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:TagAttributes.order
                                                          ascending:YES],
                            [NSSortDescriptor sortDescriptorWithKey:TagAttributes.tag
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    
    //NO books last book stored
    NSArray *tags = [self.stack executeFetchRequest:req errorBlock:^(NSError *error){ }];
    Tag *tag = tags[0];
    
    NSArray *books;
    if (tag.books.count>0){
        books = tag.books.allObjects;
    }else{
       tag = tags[1];
        books = tag.books.allObjects;
    }

    books = [books sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Book *b1 = obj1; Book *b2 = obj2;
        return [b1.title localizedCaseInsensitiveCompare:b2.title];
    }];


    AGTBookViewController *bookViewController = [[AGTBookViewController alloc] initWithBook:books[0]];
    tableViewController.delegate = bookViewController;
    
    UINavigationController *navigationControllerTable = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    
    UINavigationController *navigationControllerDetail = [[UINavigationController alloc] initWithRootViewController:bookViewController];
    
    UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    splitViewController.viewControllers = @[navigationControllerTable, navigationControllerDetail];
    splitViewController.delegate = bookViewController;
    
    self.window.rootViewController = splitViewController;
    
}

- (void)configureForPhoneWithModel:(AGTLibrary*)library
{
    AGTTableViewController *tableViewController = [[AGTTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self configureFetchersForTableViewController:tableViewController];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    
    self.window.rootViewController = navigationController;
}

#pragma mark - 

- (void)configureFetchersForTableViewController:(AGTTableViewController*)tableViewController
{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[Tag entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:TagAttributes.order
                                                          ascending:YES],
                            [NSSortDescriptor sortDescriptorWithKey:TagAttributes.tag
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                         managedObjectContext:self.stack.context
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:nil];
    tableViewController.tagsFetchedResultsController = fc;
    
    req = [NSFetchRequest fetchRequestWithEntityName:[Book entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:BookAttributes.title
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    
    fc = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                             managedObjectContext:self.stack.context
                                               sectionNameKeyPath:nil
                                                        cacheName:nil];
    tableViewController.alphabeticFetchedResultsController = fc;
    
    
    tableViewController.delegate = tableViewController;
}

@end
