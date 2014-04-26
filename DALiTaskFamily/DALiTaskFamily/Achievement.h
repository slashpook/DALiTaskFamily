//
//  Achievement.h
//  DALiTaskFamily
//
//  Created by Damien DELES on 26/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Task;

@interface Achievement : NSManagedObject

@property (nonatomic, retain) NSNumber * week;
@property (nonatomic, retain) NSManagedObject *player;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) Task *task;
@end

@interface Achievement (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
