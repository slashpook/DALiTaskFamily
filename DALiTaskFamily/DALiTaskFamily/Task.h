//
//  Task.h
//  DALiTaskFamily
//
//  Created by Damien DELES on 26/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Trophy;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * libelle;
@property (nonatomic, retain) NSNumber * point;
@property (nonatomic, retain) NSNumber * history;
@property (nonatomic, retain) NSManagedObject *category;
@property (nonatomic, retain) NSSet *achievments;
@property (nonatomic, retain) NSSet *trophies;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addAchievmentsObject:(NSManagedObject *)value;
- (void)removeAchievmentsObject:(NSManagedObject *)value;
- (void)addAchievments:(NSSet *)values;
- (void)removeAchievments:(NSSet *)values;

- (void)addTrophiesObject:(Trophy *)value;
- (void)removeTrophiesObject:(Trophy *)value;
- (void)addTrophies:(NSSet *)values;
- (void)removeTrophies:(NSSet *)values;

@end
