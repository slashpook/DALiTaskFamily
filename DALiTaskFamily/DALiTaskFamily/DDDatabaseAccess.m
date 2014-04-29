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

//On récupère tous les objets de l'entity donnée
- (NSArray *)getAllObjectForEntity:(NSString *)entityName
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                   entityForName:entityName inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le tableau de la requète
    return fetchedObjects;
}

#pragma mark - CRUD Achievement

//On récupère tous les achievements
- (NSArray *)getAchievements
{
    NSArray *arrayEntities = [self getAllObjectForEntity:@"Achievement"];
    
    //Si on a des achievements, on les tries par date
    if (arrayEntities.count > 0)
    {
        arrayEntities = [arrayEntities sortedArrayUsingComparator:^NSComparisonResult(Achievement *obj1, Achievement *obj2) {
            return (NSComparisonResult)[obj2.weekAndYear compare:obj1.weekAndYear];
        }];
    }

    return arrayEntities;
}

//On récupère tous les achievements d'une semaine donnée pour un player donné (utile pour récupérer les points gagnés dans la semaine)
- (NSArray *)getAchievementsForPlayer:(Player *)player atWeekAndYear:(int)weekAndYear
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                   entityForName:@"Achievement" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"player.pseudo == %@ && weekAndYear == %i", player.pseudo, weekAndYear];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le tableau de la requète
    return fetchedObjects;
}

//On supprime l'achievement donné
- (void)deleteAchievement:(Achievement *)achievement
{
    [self.dataBaseManager.managedObjectContext deleteObject:achievement];
    [self saveContext];
}


#pragma mark - CRUD CategoryTask

//On récupère toutes les categoryTasks
- (NSArray *)getCategoryTasks
{
    NSArray *arrayEntities = [self getAllObjectForEntity:@"CategoryTask"];
    
    //Si on a des categoryTasks, on les tries par libelle
    if (arrayEntities.count > 0)
    {
        arrayEntities = [arrayEntities sortedArrayUsingComparator:^NSComparisonResult(CategoryTask *obj1, CategoryTask *obj2) {
            return (NSComparisonResult)[obj1.libelle compare:obj2.libelle];
        }];
    }
    
    return arrayEntities;
}

//On supprime la categoryTask donnée
- (void)deleteCategoryTask:(CategoryTask *)categoryTask
{
    [self.dataBaseManager.managedObjectContext deleteObject:categoryTask];
    [self saveContext];
}


#pragma mark - CRUD CategoryTrophy

//On récupère tous les categoryTrophies
- (NSArray *)getCategoryTrophies
{
    NSArray *arrayEntities = [self getAllObjectForEntity:@"CategoryTrophy"];
    
    //Si on a des categoryTrophy, on les tries par category
    if (arrayEntities.count > 0)
    {
        arrayEntities = [arrayEntities sortedArrayUsingComparator:^NSComparisonResult(CategoryTrophy *obj1, CategoryTrophy *obj2) {
            return (NSComparisonResult)[obj1.category.libelle compare:obj2.category.libelle];
        }];
    }
    
    return arrayEntities;
}

//On supprime le categoryTrophy donné
- (void)deleteCategoryTrophy:(CategoryTrophy *)categoryTrophy
{
    [self.dataBaseManager.managedObjectContext deleteObject:categoryTrophy];
    [self saveContext];
}


#pragma mark - CRUD Event

//On récupère tous les events
- (NSArray *)getEvents
{
    return [self getAllObjectForEntity:@"Event"];
}

//On récupère tous les events d'un joueur données, pour une semaine donnée et un jour donné
- (NSArray *)getEventsForPlayer:(Player *)player atWeekAndYear:(int)weekAndYear andDay:(NSString *)day
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && achievement.weekAndYear == %i && day == %@", player.pseudo, weekAndYear, day];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le tableau de la requète
    return fetchedObjects;
}

//On récupère tous les events réalisé d'un player donné pour une task donnée.
- (int)getNumberOfEventCheckedForPlayer:(Player *)player forTask:(Task *)task
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Event" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"achievement.player.pseudo == %@ && achievement.task.libelle == %@", player.pseudo, task.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    //On renvoie le tableau de la requète
    return (int)[fetchedObjects count];
}

//On supprime l'event donné
- (void)deleteEvent:(Event *)event
{
    [self.dataBaseManager.managedObjectContext deleteObject:event];
    [self saveContext];
}


#pragma mark - CRUD Player

//On récupère tous les players
- (NSArray *)getPlayers
{
    NSArray *arrayEntities = [self getAllObjectForEntity:@"Player"];
    
    //Si on a des players, on les tries par pseudo
    if (arrayEntities.count > 0)
    {
        arrayEntities = [arrayEntities sortedArrayUsingComparator:^NSComparisonResult(Player *obj1, Player *obj2) {
            return (NSComparisonResult)[obj1.pseudo compare:obj2.pseudo];
        }];
    }
    
    return arrayEntities;
}

//On récupère le joueur donné
- (Player *)getPlayerForPseudo:(NSString *)pseudo
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Player" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"pseudo == %@" , pseudo];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le tableau de la requète
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}

//On récupère le joueur à l'index donné
- (Player *)getPlayerAtIndex:(int)index
{
    NSArray *arrayPlayer = [self getPlayers];
    
    if ([arrayPlayer count] > 0 && [arrayPlayer count] >= (index + 1))
        return [arrayPlayer objectAtIndex:index];
    else
        return nil;
}

//On supprime le player donné
- (void)deletePlayer:(Player *)player
{
    [self.dataBaseManager.managedObjectContext deleteObject:player];
    [self saveContext];
}


#pragma mark - CRUD Task

//On récupère tous les tasks
- (NSArray *)getTasks
{
    return [self getAllObjectForEntity:@"Task"];
}

//On récupère les tasks d'une categoryTask
- (NSArray *)getTasksForCategory:(CategoryTask *)category
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Task" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"category.libelle == %@", category.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des tasks, on les tries par libelle
    if (fetchedObjects.count > 0)
    {
        fetchedObjects = [fetchedObjects sortedArrayUsingComparator:^NSComparisonResult(Task *obj1, Task *obj2) {
            return (NSComparisonResult)[obj1.libelle compare:obj2.libelle];
        }];
    }
    
    //On renvoie le tableau de la requète
    return fetchedObjects;
}

//On supprime la task donnée
- (void)deleteTask:(Task *)task
{
    [self.dataBaseManager.managedObjectContext deleteObject:task];
    [self saveContext];
}


#pragma mark - CRUD Trophy

//On récupère tous les trophies
- (NSArray *)getTrophies
{
    return [self getAllObjectForEntity:@"Trophy"];
}

//On récupère le nombre de trophies réalisés pour un joueur donné, une catégorie donnée et un type de trophé donné
- (int)getNumberOfTrophyAchievedForPlayer:(Player *)player inCategory:(CategoryTask *)category andType:(NSString *)type
{
    int numberOfTrophyAchieved = 0;
    
    if (player != nil)
    {
        //On récupère les tasks de la categoryTask donnée triés par ordre alphabétique
        NSArray *arrayTasks = [self getTasksForCategory:category];
        
        //Si on a des résultats, on les parses
        if ([arrayTasks count] > 0)
        {
            for (Task *task in arrayTasks)
            {
                //On parse les trophies de chaque task
                for (Trophy *trophy in [task.trophies allObjects])
                {
                    //Si on trouve le bon, on le rajoute dans le tableau
                    if ([trophy.type isEqualToString:type])
                    {
                        int numberOfEventChecked = [self getNumberOfEventCheckedForPlayer:player forTask:task];
                        
                        if ([trophy.iteration intValue] >= numberOfEventChecked)
                            numberOfTrophyAchieved ++;
                    }
                }
            }
        }
    }

    return numberOfTrophyAchieved;
}

//On supprime le trophy donné
- (void)deleteTrophy:(Trophy *)trophy
{
    [self.dataBaseManager.managedObjectContext deleteObject:trophy];
    [self saveContext];
}

@end
