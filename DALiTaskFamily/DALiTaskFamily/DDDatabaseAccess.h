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

//On récupère tous les achievements d'une semaine donnée (utile pour récupérer les points gagnés dans la semaine)
- (NSArray *)getAchievementsForPlayer:(Player *)player atWeekAndYear:(int)weekAndYear;

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

//On récupère tous les events d'un joueur données, pour une semaine donnée et un jour donné
- (NSArray *)getEventsForPlayer:(Player *)player atWeekAndYear:(int)weekAndYear andDay:(NSString *)day;

//On récupère tous les events réalisé d'un player donné pour une task donnée.
- (int)getNumberOfEventCheckedForPlayer:(Player *)player forTask:(Task *)task;

//On supprime l'event donné
- (void)deleteEvent:(Event *)event;


#pragma mark - CRUD Player

//On récupère tous les players
- (NSArray *)getPlayers;

//On récupère le joueur donné
- (Player *)getPlayerForPseudo:(NSString *)pseudo;

//On récupère le joueur à l'index donné
- (Player *)getPlayerAtIndex:(int)index;

//On supprime le player donné
- (void)deletePlayer:(Player *)player;


#pragma mark - CRUD Task

//On récupère tous les tasks
- (NSArray *)getTasks;

//On récupère les tasks d'une categoryTask
- (NSArray *)getTasksForCategory:(CategoryTask *)category;

//On supprime la task donnée
- (void)deleteTask:(Task *)task;


#pragma mark - CRUD Trophy

//On récupère tous les trophies
- (NSArray *)getTrophies;

//On récupère le nombre de trophies réalisés pour un joueur donné, une catégorie donnée et un type de trophé donné;
- (int)getNumberOfTrophyAchievedForPlayer:(Player *)player inCategory:(CategoryTask *)category andType:(NSString *)type;

//On supprime le trophy donné
- (void)deleteTrophy:(Trophy *)trophy;

@end
