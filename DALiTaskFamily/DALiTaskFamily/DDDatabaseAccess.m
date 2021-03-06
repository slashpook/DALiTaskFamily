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


//On crée l'achievement pour le player donné, la task donnée et la date donnée
- (Achievement *)createAchievementForPlayer:(Player *)player andTask:(Task *)task atWeekAndYear:(int)weekAndYear
{
    Achievement *achievement = [NSEntityDescription insertNewObjectForEntityForName:@"Achievement"
                                                             inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    [achievement setWeekAndYear:[NSNumber numberWithInt:weekAndYear]];
    [achievement setPlayer:player];
    [achievement setTask:task];
    
    return achievement;
}

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

//On récupère l'achievement d'une semaine donnée pour un player donné et une task donnée
- (Achievement *)getAchievementsForPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(int)weekAndYear
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Achievement" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"player.pseudo == %@ && task.libelle = %@ && weekAndYear == %i", player.pseudo, task.libelle, weekAndYear];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie l'achievement s'il existe
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}

//On supprime l'achievement donné
- (void)deleteAchievement:(Achievement *)achievement
{
    [self.dataBaseManager.managedObjectContext deleteObject:achievement];
    [self saveContext];
}


#pragma mark - CRUD CategoryTask

//On crée la categoryTask donnée
- (void)createCategoryTask:(CategoryTask *)categoryTask
{
    [self.dataBaseManager.managedObjectContext insertObject:categoryTask];
    [self saveContext];
}

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

//On crée le player après avoir fait quelques tests préalable
- (void)createCategoryTrophy:(CategoryTrophy *)categoryTrophy withCategory:(CategoryTask *)category
{
    [self.dataBaseManager.managedObjectContext insertObject:categoryTrophy];
    [categoryTrophy setCategory:category];
    [self saveContext];
}

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

//On récupère tous les categoryTrophies de la categoryTask et on les trie
- (NSArray *)getCategoryTrophiesForCategorySorted:(CategoryTask *)categoryTask
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"CategoryTrophy" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"category.libelle == %@", categoryTask.libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([fetchedObjects count] == 3)
        return [self getTrophiesSortedInArray:fetchedObjects];
    else
        return nil;
}

//On supprime le categoryTrophy donné
- (void)deleteCategoryTrophy:(CategoryTrophy *)categoryTrophy
{
    [self.dataBaseManager.managedObjectContext deleteObject:categoryTrophy];
    [self saveContext];
}


#pragma mark - CRUD Event


//On crée l'event après avoir fait quelques tests préalable
- (NSString *)createEvent:(Event *)event forPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(int)weekAndYear
{
    if (task != nil)
    {
        //On récupère l'achievement du player s'il existe
        Achievement *achievement = [self getAchievementsForPlayer:player forTask:task atWeekAndYear:weekAndYear];
        
        //S'il n'existe pas, on le crée
        if (achievement == nil)
            achievement = [self createAchievementForPlayer:player andTask:task atWeekAndYear:weekAndYear];
        else
        {
            //On regarde si on a pas déjà un event qui existe pour ce jour
            Event *eventInDB = [self getEventForAchievement:achievement andDay:event.day];
            
            if (eventInDB != nil)
                return @"Un évènement existe déjà pour cette tache";
        }
        
        //On sauvegarde l'event
        [self.dataBaseManager.managedObjectContext insertObject:event];
        [achievement addEventsObject:event];
        
        [self saveContext];
        return nil;
    }
    else
        return @"Veuillez renseigner une tache !";
}

//On update l'event donné après avoir fait quelques test
- (NSString *)updateEvent:(Event *)event forPlayer:(Player *)player forTask:(Task *)task atWeekAndYear:(int)weekAndYear
{
    //On récupère l'achievement du player s'il existe
    Achievement *achievement = [self getAchievementsForPlayer:player forTask:task atWeekAndYear:weekAndYear];
    
    //S'il n'existe pas, on le crée
    if (achievement == nil)
        achievement = [self createAchievementForPlayer:player andTask:task atWeekAndYear:weekAndYear];
    
    [event setAchievement:achievement];
    
    //On regarde si on a pas déjà un event qui existe pour ce jour
    int countOfEvent = [self getCountOfEventForAchievement:achievement andDay:event.day];
    if (countOfEvent >= 2)
        return @"Un évènement existe déjà pour cette tache";
    
    //On sauvegarde l'event
    [self saveContext];
    return nil;
}

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

//On récupère l'event de l'achievement donnée, au jour donné
- (Event *)getEventForAchievement:(Achievement *)achievement andDay:(NSString *)day
{
    for (Event *event in [[achievement events] allObjects])
    {
        if ([event.day isEqualToString:day])
            return event;
    }
    
    return nil;
}

//On récupère le nombre d'event de l'achievement donnée, au jour donné
- (int)getCountOfEventForAchievement:(Achievement *)achievement andDay:(NSString *)day
{
    int count = 0;
    for (Event *event in [[achievement events] allObjects])
    {
        if ([event.day isEqualToString:day])
            count ++;
    }
    
    return count;
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

//On crée le player après avoir fait quelques tests préalable
- (NSString *)createPlayer:(Player *)player
{
    //On vérifie que un pseudo soit rentré
    if ([player.pseudo length] != 0)
    {
        //Si le pseudo n'existe pas déjà
        if ([self getPlayerForPseudo:player.pseudo] == nil)
        {
            //On sauvegarde le player
            [self.dataBaseManager.managedObjectContext insertObject:player];
            [self saveContext];
            return nil;
        }
        else
        {
            //On renvoie un message d'erreur
            return @"Un autre joueur porte déjà ce nom !";
        }
    }
    else
    {
        //On renvoie un message d'erreur
        return @"Veuillez rentrer un pseudo !";
    }
    
    return nil;
}

//On update le player donné après avoir fait quelques tests
- (NSString *)updatePlayer:(Player *)player
{
    NSString *errorMessage = nil;
    
    //On vérifie que un pseudo soit rentré
    if ([player.pseudo length] != 0)
    {
        //Si le pseudo n'existe pas déjà
        if ([self getCountOfPlayerForPseudo:player.pseudo] < 2)
        {
            //On sauvegarde le player
            [self saveContext];
            return nil;
        }
        else
        {
            //On renvoie un message d'erreur
            errorMessage = @"Un autre joueur porte déjà ce nom !";
        }
    }
    else
    {
        //On renvoie un message d'erreur
        errorMessage = @"Veuillez rentrer un pseudo !";
    }
    
    //On fait un rollback sur les modifications
    [self rollback];
    return errorMessage;
}

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

//On récupère le premier player
- (Player *)getFirstPlayer
{
    //On Défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Player" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"pseudo"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a des objets on retourne NO
    if (fetchedObjects.count > 0)
    {
        return [fetchedObjects objectAtIndex:0];
    }
    
    return nil;
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

//Retourne le nombre de player pour un pseudo donné
- (int)getCountOfPlayerForPseudo:(NSString *)pseudo
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
    
    return (int)[fetchedObjects count];
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


#pragma mark - CRUD Reward

//On sauvegarde le reward après avoir fait quelques tests préalable
- (NSString *)saveReward:(Reward *)reward
{
    //On sauvegarde le trophy
    [self saveContext];
    return nil;
}

//On tri le tableau de rewards
- (NSArray *)getRewardSortedInArray:(NSArray *)arrayTrophies
{
    //On crée le tableau de rewards et on les récupère dans le bon ordre
    NSMutableArray *arrayTrophiesSort = [[NSMutableArray alloc] init];
    
    [arrayTrophiesSort addObject:[self getTrophyForType:@"Bronze" inArray:arrayTrophies]];
    [arrayTrophiesSort addObject:[self getTrophyForType:@"Argent" inArray:arrayTrophies]];
    [arrayTrophiesSort addObject:[self getTrophyForType:@"Or" inArray:arrayTrophies]];
    
    return arrayTrophiesSort;
}

//On récupère le reward pour le type donnée
- (Reward *)getRewardForType:(NSString *)type
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Reward" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"type == %@" , type];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie la première donnée de la requète
    if ([fetchedObjects count] > 0)
        return [fetchedObjects objectAtIndex:0];
    else
        return nil;
}

//On supprime le reward donné
- (void)deleteReward:(Reward *)reward
{
    [self.dataBaseManager.managedObjectContext deleteObject:reward];
    [self saveContext];
}


#pragma mark - CRUD Task

//On crée la task après avoir fait quelques tests préalable
- (NSString *)createTask:(Task *)task forCategory:(CategoryTask *)categoryTask withTrophies:(NSArray *)arrayTrophies
{
    NSString *errorMessage = nil;
    
    //On parse les trophies pour voir s'ils sont tous bon
    for (Trophy *trophy in arrayTrophies)
    {
        errorMessage = [self createTrophy:trophy];
        if (errorMessage != nil)
        {
            [self rollback];
            return errorMessage;
        }
    }
    
    if ([task.libelle length] != 0 && task.point != nil)
    {
        //On fait les tests sur la tache
        if ([self getTaskWithLibelle:task.libelle] == nil)
        {
            //On rajoute le context à la task
            [self.dataBaseManager.managedObjectContext insertObject:task];
            
            //On rajoute la catégory à la task
            [task setCategory:categoryTask];
            
            //On ajoute les trophies
            [task addTrophies:[NSSet setWithArray:arrayTrophies]];
            
            //On sauvegarde la task ainsi que les trophies
            [self saveContext];
            return nil;
        }
        else
            return @"Une autre tache porte déjà ce nom!";
    }
    else
        return @"Veuillez remplir tous les champs liés à la tache !";
    
    return nil;
}

//On update la task donnée après avoir fait quelques tests
- (NSString *)updateTask:(Task *)task
{
    NSString *errorMessage = nil;
    
    //On parse les trophies pour voir s'ils sont tous bon
    for (Trophy *trophy in [[task trophies] allObjects])
    {
        errorMessage = [self updateTrophy:trophy];
        if (errorMessage != nil)
        {
            [self rollback];
            return errorMessage;
        }
    }
    
    if ([task.libelle length] != 0 && task.point != nil)
    {
        //On fait les tests sur la tache
        if ([self getCountOfTaskWithLibelle:task.libelle] > 2)
        {
            //On sauvegarde la task ainsi que les trophies
            [self saveContext];
            return nil;
        }
        else
            return @"Une autre tache porte déjà ce nom!";
    }
    else
        return @"Veuillez remplir tous les champs liés à la tache !";
    
    return nil;
}

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

//On récupère le tableau des historique d'utilisation des tasks
- (NSArray *)getArrayHistoriqueTask
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Task" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setFetchLimit:10];
    
    //On rajoute un tri sur l'history
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"history"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le tableau de la requète
    return fetchedObjects;
}

//On récupère la task avec le libellé donné
- (Task *)getTaskWithLibelle:(NSString *)libelle
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Task" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"libelle == %@", libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //Si on a une task, on la renvoie
    if (fetchedObjects.count > 0)
    {
        return [fetchedObjects objectAtIndex:0];
    }
    
    //Sinon on renvoie nil
    return nil;
}

//On renvoie le nombre de task avec le libellé donné
- (int)getCountOfTaskWithLibelle:(NSString *)libelle
{
    //On défini la classe pour la requète
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Task" inManagedObjectContext:self.dataBaseManager.managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    
    //On rajoute un filtre
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"libelle == %@", libelle];
    [fetchRequest setPredicate:newPredicate];
    
    NSError *error;
    NSArray *fetchedObjects = [self.dataBaseManager.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //On renvoie le count des tasks
    return (int)[fetchedObjects count];
}

//On supprime la task donnée
- (void)deleteTask:(Task *)task
{
    [self.dataBaseManager.managedObjectContext deleteObject:task];
    [self saveContext];
}


#pragma mark - CRUD Trophy

//On crée le trophy après avoir fait quelques tests préalable
- (NSString *)createTrophy:(Trophy *)trophy
{
    if (trophy.iteration != nil)
    {
        //On sauvegarde le trophy
        [self.dataBaseManager.managedObjectContext insertObject:trophy];
        return nil;
    }
    else
        return [NSString stringWithFormat:@"Vous devez renseigner un trophée de %@", trophy.type];
}

//On update le trophy après avoir fait quelques tests préalable
- (NSString *)updateTrophy:(Trophy *)trophy
{
    //On teste juste si on a bien une iteration pour le trophy
    if (trophy.iteration != nil)
    {
        return nil;
    }
    else
        return [NSString stringWithFormat:@"Vous devez renseigner un trophée de %@", trophy.type];
}

//On récupère tous les trophies
- (NSArray *)getTrophies
{
    return [self getAllObjectForEntity:@"Trophy"];
}

//On récupère le trophy pour le type donnée
- (Trophy *)getTrophyForType:(NSString *)type inArray:(NSArray *)arrayTrophies
{
    //On parse le tableau pour récupérer le bon trophy
    for (Trophy *trophy in arrayTrophies)
    {
        if ([[trophy type] isEqualToString:type])
            return trophy;
    }
    
    return nil;
}

//On tri le tableau de trophies
- (NSArray *)getTrophiesSortedInArray:(NSArray *)arrayTrophies
{
    //On crée le tableau de trophies et on les récupère dans le bon ordre
    NSMutableArray *arrayTrophiesSort = [[NSMutableArray alloc] init];
    
    [arrayTrophiesSort addObject:[self getTrophyForType:@"Bronze" inArray:arrayTrophies]];
    [arrayTrophiesSort addObject:[self getTrophyForType:@"Argent" inArray:arrayTrophies]];
    [arrayTrophiesSort addObject:[self getTrophyForType:@"Or" inArray:arrayTrophies]];
    
    return arrayTrophiesSort;
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
