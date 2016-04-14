//
//  DiceSet.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dice.h"

@interface DiceSet : NSObject
@property (strong, nonatomic) NSMutableArray *dices;

+(NSDictionary *) dicesSet;
- (void) addDice:(Dice*)dice;

@end
