//
//  Category.h
//  DALiTaskFamily
//
//  Created by Damien DELES on 26/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * libelle;
@property (nonatomic, retain) NSSet *tasks;
@property (nonatomic, retain) NSSet *categoryTrophies;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

- (void)addCategoryTrophiesObject:(NSManagedObject *)value;
- (void)removeCategoryTrophiesObject:(NSManagedObject *)value;
- (void)addCategoryTrophies:(NSSet *)values;
- (void)removeCategoryTrophies:(NSSet *)values;

@end
