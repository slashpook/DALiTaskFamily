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
//    [self addTaskWithLibelle:@"Tache 1" andPoint:800];
//    [self addTaskWithLibelle:@"Tache 2" andPoint:500];
    
    NSArray *arrayTask = [[DDDatabaseAccess instance] getTasks];
    for (Task *task in arrayTask) {
        NSLog(@"Task : %@, Point : %@", task.libelle, task.point);
        
        for (Trophy *trophy in task.trophies) {
            NSLog(@"Trophy %@, Iteration: %@", trophy.type, trophy.iteration);
        }
    }
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
    
    NSString *message = [[DDDatabaseAccess instance] createTask:task withTrophies:[NSArray arrayWithObjects:trophy, trophy2, trophy3, nil]];
    
    if (message != nil)
        NSLog(@"Erreur : %@", message);
    else
        NSLog(@"Task crée");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
