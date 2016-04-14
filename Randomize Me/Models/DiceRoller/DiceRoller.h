//
//  DiceRoller.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRandomResponse.h"
#import "DiceSet.h"

@interface DiceRoller : NSObject
@property (strong, nonatomic) DiceSet *setOfDices;

- (NSArray*) imageSet;
- (NSArray*) nameSet;
- (void) rollWithResponse:(MSRandomResponse*)response;

@end
