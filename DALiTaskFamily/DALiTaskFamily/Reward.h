//
//  Reward.h
//  DALiTaskFamily
//
//  Created by Damien DELES on 30/04/2014.
//  Copyright (c) 2014 Damien DELES. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Reward : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * libelle;

@end
