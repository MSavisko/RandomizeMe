//
//  CardShuffler.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/14/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "CardShuffler.h"
#import "Card.h"
#import "Deck.h"
#import "MSRandomResponse.h"

@implementation CardShuffler

- (Card*) shuffleWithResponse:(MSRandomResponse*)response {
    NSString *cardMapper = response.data[0];
    NSString *name = [Deck cards][cardMapper][1];
    NSString *imageName = [Deck cards][cardMapper][0];
    
    Card *card = [[Card alloc]initWithName:name andImageName:imageName];
    
    return card;
}

@end
