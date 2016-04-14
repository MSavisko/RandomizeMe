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
                            @"1" : @[@"dice1_blue", @"dice1_small"],
                            @"2" : @[@"dice2_blue", @"dice2_small"],
                            @"3" : @[@"dice3_blue", @"dice3_small"],
                            @"4" : @[@"dice4_blue", @"dice4_small"],
                            @"5" : @[@"dice5_blue", @"dice5_small"],
                            @"6" : @[@"dice6_blue", @"dice6_small"],
                            };
    return result;
}

- (void) addDice:(Dice*)dice {
    [_dices addObject:dice];
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _dices = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
