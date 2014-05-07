//
//  DDViewController.m
//  DALiTaskFamily
//
//  Created by Damien DELES on 26/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import "DDViewController.h"

@interface DDViewController ()

@end

@implementation DDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addPlayerWithName:@"Damien"];
    [self addPlayerWithName:@"Damien"];
    [self addPlayerWithName:@"Thomas"];
    
    NSArray *arrayPlayer = [[DDDatabaseAccess instance] getPlayers];
    for (Player *player in arrayPlayer) {
        NSLog(@"Joueur : %@", player.pseudo);
    }
    
    [self addTaskWithLibelle:@"Tache 3" andPoint:300];
    [self addTaskWithLibelle:@"Tache 1" andPoint:800];
    [self addTaskWithLibelle:@"Tache 4" andPoint:500];
    
    NSArray *arrayTask = [[DDDatabaseAccess instance] getTasks];
    for (Task *task in arrayTask) {
        NSLog(@"Task : %@, Point : %@", task.libelle, task.point);
        
        for (Trophy *trophy in [[DDDatabaseAccess instance] getTrophiesSortedInArray:[task.trophies allObjects]]) {
            NSLog(@"Trophy %@, Iteration: %@", trophy.type, trophy.iteration);
        }
    }
    
    Player *player = [[DDDatabaseAccess instance] getPlayerForPseudo:@"Damien"];
    Player *player2 = [[DDDatabaseAccess instance] getPlayerForPseudo:@"Thomas"];
    Task *task = [[DDDatabaseAccess instance] getTaskWithLibelle:@"Tache 1"];
    Task *task2 = [[DDDatabaseAccess instance] getTaskWithLibelle:@"Tache 2"];
    
    [self addEventForPlayer:player andTask:task atDay:@"Lundi"];
    [self addEventForPlayer:player andTask:task atDay:@"Lundi"];
    [self addEventForPlayer:player andTask:task2 atDay:@"Lundi"];
    [self addEventForPlayer:player andTask:task atDay:@"Mardi"];
    [self addEventForPlayer:player2 andTask:task atDay:@"Lundi"];
    [self addEventForPlayer:player2 andTask:task atDay:@"Vendredi"];
    [self addEventForPlayer:player2 andTask:task2 atDay:@"Lundi"];
    
    NSArray *arrayEvent = [[DDDatabaseAccess instance] getEventsForPlayer:player atWeekAndYear:201423 andDay:@"Lundi"];
    
    for (Event *event in arrayEvent) {
        NSLog(@"Event pour le joueur : %@, tache : %@, jour : %@, weekAndYear : %@", event.achievement.player.pseudo, event.achievement.task.libelle, event.day, event.achievement.weekAndYear);
    }

    [player2 setPseudo:@"Thomas"];
    NSString *message = [[DDDatabaseAccess instance] updatePlayer:player2];
    NSLog(@"%@", message);
}

- (void)addPlayerWithName:(NSString *)pseudo
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Player" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Player *player = [[Player alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    player.pseudo = pseudo;
    
    NSString *message = [[DDDatabaseAccess instance] createPlayer:player];
    
    if (message != nil)
        NSLog(@"Erreur : %@", message);
    else
        NSLog(@"Joueur crée");
}

- (void)addTaskWithLibelle:(NSString *)libelle andPoint:(int)point
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Task *task = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    task.libelle = libelle;
    task.point = [NSNumber numberWithInt:point];
    
    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Trophy" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Trophy *trophy = [[Trophy alloc] initWithEntity:entity2 insertIntoManagedObjectContext:nil];
    trophy.type = @"Bronze";
    trophy.iteration = [NSNumber numberWithInt:14];
    
    NSEntityDescription *entity3 = [NSEntityDescription entityForName:@"Trophy" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Trophy *trophy2 = [[Trophy alloc] initWithEntity:entity3 insertIntoManagedObjectContext:nil];
    trophy2.type = @"Argent";
    trophy2.iteration = [NSNumber numberWithInt:23];
    
    NSEntityDescription *entity4 = [NSEntityDescription entityForName:@"Trophy" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Trophy *trophy3 = [[Trophy alloc] initWithEntity:entity4 insertIntoManagedObjectContext:nil];
    trophy3.type = @"Or";
    trophy3.iteration = [NSNumber numberWithInt:30];
    
    NSString *message = [[DDDatabaseAccess instance] createTask:task forCategory:nil withTrophies:[NSArray arrayWithObjects:trophy, trophy2, trophy3, nil]];
    
    if (message != nil)
        NSLog(@"Erreur : %@", message);
    else
        NSLog(@"Task crée");
}

- (void)addEventForPlayer:(Player *)player andTask:(Task *)task atDay:(NSString *)day;
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:[DDDatabaseAccess instance].dataBaseManager.managedObjectContext];
    Event *event = [[Event alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
    event.day = day;
    event.recurrent = [NSNumber numberWithBool:NO];
    event.comment = @"TG";
    
    NSString *message = [[DDDatabaseAccess instance] createEvent:event forPlayer:player forTask:task atWeekAndYear:201423];
    
    if (message != nil)
        NSLog(@"Erreur : %@", message);
    else
        NSLog(@"Event crée");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
