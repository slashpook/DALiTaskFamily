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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
