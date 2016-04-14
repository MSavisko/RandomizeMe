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
        //NSNumber *number = response.data[i];
        NSString *stringNumber = [NSString stringWithFormat:@"%@", response.data[i]];
        NSString *name = [NSString stringWithFormat:@"dice#%@", stringNumber];
        NSString *imageName = [DiceSet dicesSet][stringNumber][0];
        NSString *smallImageName = [DiceSet dicesSet][stringNumber][1];
        
        Dice *newDice = [[Dice alloc]initWithName:name number:[stringNumber intValue] imageName:imageName smallImageName:smallImageName];
        
        [self.setOfDices addDice:newDice];
    }
}

- (NSArray*) imageSet {
    NSMutableArray *imageSet = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.setOfDices.dices.count; i++) {
        Dice *dice = self.setOfDices.dices[i];
        [imageSet addObject:dice.imageName];
    }
    return imageSet;
}

- (NSArray*) smallImageSet {
    NSMutableArray *imageSet = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.setOfDices.dices.count; i++) {
        Dice *dice = self.setOfDices.dices[i];
        [imageSet addObject:dice.smallImageName];
    }
    return imageSet;
}

- (NSArray*) nameSet {
    NSMutableArray *nameSet = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.setOfDices.dices.count; i++) {
        Dice *dice = self.setOfDices.dices[i];
        [nameSet addObject:dice.name];
    }
    return nameSet;
    
}

@end
