//
//  DDDatabaseAccess.m
//  DALiTaskFamily
//
//  Created by Damien DELES on 27/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDDatabaseAccess.h"

@implementation DDDatabaseAccess


#pragma mark - Init

//Instance du singleton
+ (DDDatabaseAccess *)instance
{
	static DDDatabaseAccess *instance;
	
	@synchronized(self) {
		if(!instance) {
			instance = [[DDDatabaseAccess alloc] init];
		}
	}
	
	return instance;
}

-(id) init
{
    self = [super init];
    if (self != nil)
    {
        self.dataBaseManager = [[DDDatabaseManager alloc] init];
    }
    return self;
}


#pragma mark - Base Methods

//On sauvegarde les données
- (BOOL)saveContext
{
    NSError *error = nil;
    return [self.dataBaseManager saveContext:error];
}

//On annule les modifications
- (void)rollback
{
    [self.dataBaseManager.managedObjectContext rollback];
}


#pragma mark - CRUD Achievement

//On supprime l'achievement donné
-(void)deleteAchievement:(Achievement *)achievement
{
    [self.dataBaseManager.managedObjectContext deleteObject:achievement];
    [self saveContext];
}


#pragma mark - CRUD CategoryTask

//On supprime la categoryTask donnée
-(void)deleteCategoryTask:(CategoryTask *)categoryTask
{
    [self.dataBaseManager.managedObjectContext deleteObject:categoryTask];
    [self saveContext];
}


#pragma mark - CRUD CategoryTrophy

//On supprime le categoryTrophy donné
-(void)deleteCategoryTrophy:(CategoryTrophy *)categoryTrophy
{
    [self.dataBaseManager.managedObjectContext deleteObject:categoryTrophy];
    [self saveContext];
}


#pragma mark - CRUD Event

//On supprime l'event donné
-(void)deleteEvent:(Event *)event
{
    [self.dataBaseManager.managedObjectContext deleteObject:event];
    [self saveContext];
}


#pragma mark - CRUD Player

//On supprime le player donné
-(void)deletePlayer:(Player *)player
{
    [self.dataBaseManager.managedObjectContext deleteObject:player];
    [self saveContext];
}


#pragma mark - CRUD Task

//On supprime la task donnée
-(void)deleteTask:(Task *)task
{
    [self.dataBaseManager.managedObjectContext deleteObject:task];
    [self saveContext];
}


#pragma mark - CRUD Trophy

//On supprime le trophy donné
-(void)deleteTrophy:(Trophy *)trophy
{
    [self.dataBaseManager.managedObjectContext deleteObject:trophy];
    [self saveContext];
}

@end
