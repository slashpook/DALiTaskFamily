//
//  Trophy.h
//  DALiTaskFamily
//
//  Created by Damien DELES on 07/05/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Trophy : NSManagedObject

@property (nonatomic, retain) NSNumber * iteration;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) Task *task;

@end
