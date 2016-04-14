//
//  CardShuffler.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/14/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "MSRandomResponse.h"

@interface CardShuffler : NSObject

- (Card*) shuffleWithResponse:(MSRandomResponse*)response;

@end
