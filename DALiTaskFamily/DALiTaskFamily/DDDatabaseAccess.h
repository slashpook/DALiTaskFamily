//
//  DDDatabaseAccess.h
//  DALiTaskFamily
//
//  Created by Damien DELES on 27/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDDatabaseManager.h"

@interface DDDatabaseAccess : NSObject

#pragma mark - Variables

//Instance de la base de donnée
@property (strong, nonatomic) DDDatabaseManager *dataBaseManager;


#pragma mark - Base Methods / save methods

//Initialisation du singleton
+ (DDDatabaseAccess *)instance;

//Sauvegare
- (BOOL)saveContext:(NSError *)error;

//Annulation de l'action
- (void)rollback;


#pragma mark - CRUD Achievement

//On supprime l'achievement donné
-(void)deleteAchievement:(Achievement *)achievement;


#pragma mark - CRUD CategoryTask

//On supprime la categoryTask donnée
-(void)deleteCategoryTask:(CategoryTask *)categoryTask;


#pragma mark - CRUD CategoryTrophy

//On supprime le categoryTrophy donné
-(void)deleteCategoryTrophy:(CategoryTrophy *)categoryTrophy;


#pragma mark - CRUD Event

//On supprime l'event donné
-(void)deleteEvent:(Event *)event;


#pragma mark - CRUD Player

//On supprime le player donné
-(void)deletePlayer:(Player *)player;


#pragma mark - CRUD Task

//On supprime la task donnée
-(void)deleteTask:(Task *)task;


#pragma mark - CRUD Trophy

//On supprime le trophy donné
-(void)deleteTrophy:(Trophy *)trophy;

@end
