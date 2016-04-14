//
//  DiceRoller.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "DiceRoller.h"
#import "Dice.h"
#import "DiceSet.h"
#import "MSRandomResponse.h"

@implementation DiceRoller
- (void) rollWithResponse:(MSRandomResponse*)response {
    
    self.setOfDices = [[DiceSet alloc]init];
    
    for (int i = 0; i < response.data.count; i++) {
        NSNumber *number = response.data[i];
        NSString *name = [NSString stringWithFormat:@"dice %d", [number intValue]];
        NSString *imageName = [DiceSet dicesSet][[number stringValue]];
        
        Dice *newDice = [[Dice alloc]initWithName:name number:[number intValue] andImageName:imageName];
        
        [self.setOfDices addDice:newDice];
    }
}

- (NSArray*) imageSet {
    NSMutableArray *imageSet = [[NSMutableArray alloc]init];
    for (int i = 0; self.setOfDices.dices.count; i++) {
        Dice *dice = self.setOfDices.dices[i];
        [imageSet addObject:dice.imageName];
    }
    return imageSet;
}

- (NSArray*) nameSet {
    NSMutableArray *nameSet = [[NSMutableArray alloc]init];
    for (int i = 0; self.setOfDices.dices.count; i++) {
        Dice *dice = self.setOfDices.dices[i];
        [nameSet addObject:dice.name];
    }
    return nameSet;
    
}

@end
