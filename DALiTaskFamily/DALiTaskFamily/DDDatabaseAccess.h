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
- (BOOL)saveContext;

//Annulation de l'action
- (void)rollback;

//On récupère tous les objets de l'entity donnée
- (NSArray *)getAllObjectForEntity:(NSString *)entityName;


#pragma mark - CRUD Achievement

//On récupère tous les achievements
- (NSArray *)getAchievements;

//On supprime l'achievement donné
- (void)deleteAchievement:(Achievement *)achievement;


#pragma mark - CRUD CategoryTask

//On récupère toutes les categoryTasks
- (NSArray *)getCategoryTasks;

//On supprime la categoryTask donnée
- (void)deleteCategoryTask:(CategoryTask *)categoryTask;


#pragma mark - CRUD CategoryTrophy

//On récupère tous les categoryTrophies
- (NSArray *)getCategoryTrophies;

//On supprime le categoryTrophy donné
- (void)deleteCategoryTrophy:(CategoryTrophy *)categoryTrophy;


#pragma mark - CRUD Event

//On récupère tous les events
- (NSArray *)getEvents;

//On supprime l'event donné
- (void)deleteEvent:(Event *)event;


#pragma mark - CRUD Player

//On récupère tous les players
- (NSArray *)getPlayers;

//On supprime le player donné
- (void)deletePlayer:(Player *)player;


#pragma mark - CRUD Task

//On récupère tous les tasks
- (NSArray *)getTasks;

//On supprime la task donnée
- (void)deleteTask:(Task *)task;


#pragma mark - CRUD Trophy

//On récupère tous les trophies
- (NSArray *)getTrophies;

//On supprime le trophy donné
- (void)deleteTrophy:(Trophy *)trophy;

@end
