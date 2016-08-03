//
//  CNDataManager.m
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//

#import "CNDataManager.h"

@implementation CNDataManager

+ (instancetype)shareDataController
{
    static CNDataManager *shareOBJ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareOBJ = [[CNDataManager alloc] init];
    });
    return shareOBJ;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// do some suffix
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
        
        NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSAssert(mom != nil, @"Error initializing Managed Object Model");
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [moc setPersistentStoreCoordinator:psc];
        [self setManagedObjectContext:moc];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
        NSLog(@"storeURL %@",storeURL);
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSError *error = nil;
            NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
            NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
            NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
        });
    }
    return _managedObjectContext;
}


- (NSArray *)arrOfThemeModel
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CNTheme"];
    NSError *error = nil;
    NSArray *arr = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    /// 进行一下排序
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(CNTheme *obj1, CNTheme *obj2) {
        return  obj1.themeId > obj2.themeId;
    }];
    
    if (error) {
        NSAssert(arr != nil, @"Error fetch OCArray: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    return arr;
}


@end





