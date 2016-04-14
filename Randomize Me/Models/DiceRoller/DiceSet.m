//
//  DiceSet.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "DiceSet.h"
#import "Dice.h"

@implementation DiceSet

+(NSDictionary *) dicesSet {
    NSDictionary *result = @{
                            @"1" : @"dice1_blue",
                            @"2" : @"dice2_blue",
                            @"3" : @"dice3_blue",
                            @"4" : @"dice4_blue",
                            @"5" : @"dice5_blue",
                            @"6" : @"dice6_blue",
                            };
    return result;
}

- (void) addDice:(Dice*)dice {
    [_dices addObject:dice];
}

@end
