//
//  CNTheme+CoreDataProperties.h
//  CrispyNews
//
//  Created by xuewu.long on 16/8/3.
//  Copyright © 2016年 letv. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CNTheme.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNTheme (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *themeName;
@property (nullable, nonatomic, retain) NSNumber *themeId;

@end

NS_ASSUME_NONNULL_END
