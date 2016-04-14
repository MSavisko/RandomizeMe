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

- (Card*) shuffleResponse:(MSRandomResponse*)response {
    Card *card = [[Card alloc]init];
    NSString *cardMapper = response.data[0];
    
    card.name = [Deck cards][cardMapper][1];
    card.imageName = [Deck cards][cardMapper][0];
    
    return card;
}

@end
