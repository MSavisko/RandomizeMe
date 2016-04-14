//
//  Deck.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/14/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "Deck.h"

@implementation Deck
+ (NSDictionary*) cards {
    NSMutableDictionary *cards = [[NSMutableDictionary alloc]init];
    
    //Spades
    NSDictionary *spades = [[NSDictionary alloc]init];
    spades = @{
               @"a" : @[@"2_of_spades", @"Two of Spades"],
               @"b" : @[@"3_of_spades", @"Three of Spades"],
               @"c" : @[@"4_of_spades", @"Four of Spades"],
               @"d" : @[@"5_of_spades", @"Five of Spades"],
               @"e" : @[@"6_of_spades", @"Six of Spades"],
               @"f" : @[@"7_of_spades", @"Seven of Spades"],
               @"g" : @[@"7_of_spades", @"Seven of Spades"],
               @"h" : @[@"9_of_spades", @"Nine of Spades"],
               @"i": @[@"10_of_spades", @"Ten of Spades"],
               @"j": @[@"ace_of_spades", @"Ace of Spades"],
               @"k": @[@"jack_of_spades", @"Jack of Spades"],
               @"l": @[@"king_of_spades", @"King of Spades"],
               @"m": @[@"queen_of_spades", @"Queen of Spades"],
               };
    
    //Hearts
    NSDictionary *hearts = [[NSDictionary alloc]init];
    hearts = @{
               @"n" : @[@"2_of_hearts", @"Two of Hearts"],
               @"o" : @[@"3_of_hearts", @"Three of Hearts"],
               @"p" : @[@"4_of_hearts", @"Four of Hearts"],
               @"q" : @[@"5_of_hearts", @"Five of Hearts"],
               @"r" : @[@"6_of_hearts", @"Six of Hearts"],
               @"s" : @[@"7_of_hearts", @"Seven of Hearts"],
               @"t" : @[@"8_of_hearts", @"Eight of Hearts"],
               @"u" : @[@"9_of_hearts", @"Nine of Hearts"],
               @"v" : @[@"10_of_hearts", @"Ten of Hearts"],
               @"w" : @[@"ace_of_hearts", @"Ace of Hearts"],
               @"x" : @[@"jack_of_hearts", @"Jack of Hearts"],
               @"y" : @[@"king_of_hearts", @"King of Hearts"],
               @"z" : @[@"queen_of_hearts", @"Queen of Hearts"],
               };
    
    //Diamonds
    NSDictionary *diamonds = [[NSDictionary alloc]init];
    diamonds = @{
                 @"1" : @[@"2_of_diamonds", @"Two of Diamonds"],
                 @"2" : @[@"3_of_diamonds", @"Three of Diamonds"],
                 @"3" : @[@"4_of_diamonds", @"Four of Diamonds"],
                 @"4" : @[@"5_of_diamonds", @"Five of Diamonds"],
                 @"5" : @[@"6_of_diamonds", @"Six of Diamonds"],
                 @"6" : @[@"7_of_diamonds", @"Seven of Diamonds"],
                 @"7" : @[@"8_of_diamonds", @"Eight of Diamonds"],
                 @"8" : @[@"9_of_diamonds", @"Nine of Diamonds"],
                 @"9" : @[@"10_of_diamonds", @"Ten of Diamonds"],
                 @"A" : @[@"ace_of_diamonds", @"Ace of Diamonds"],
                 @"B" : @[@"jack_of_diamonds", @"Jack of Diamonds"],
                 @"C" : @[@"king_of_diamonds", @"King of Diamonds"],
                 @"D" : @[@"queen_of_diamonds", @"Queen of Diamonds"],
                 };
    
    //Clubs
    NSDictionary *clubs = [[NSDictionary alloc]init];
    clubs = @{
              @"E" : @[@"2_of_clubs", @"Two of Clubs"],
              @"F" : @[@"3_of_clubs", @"Three of Clubs"],
              @"G" : @[@"4_of_clubs", @"Four of Clubs"],
              @"H" : @[@"5_of_clubs", @"Five of Clubs"],
              @"I" : @[@"6_of_clubs", @"Six of Clubs"],
              @"J" : @[@"7_of_clubs", @"Seven of Clubs"],
              @"K" : @[@"8_of_clubs", @"Eight of Clubs"],
              @"L" : @[@"9_of_clubs", @"Nine of Clubs"],
              @"M" : @[@"10_of_clubs", @"Ten of Clubs"],
              @"N" : @[@"ace_of_clubs", @"Ace of Clubs"],
              @"O" : @[@"jack_of_clubs", @"Jack of Clubs"],
              @"P" : @[@"king_of_clubs", @"King of Clubs"],
              @"Q" : @[@"queen_of_clubs", @"Queen of Clubs"],
              };
    
    //Jokers
    NSDictionary *jokers = [[NSDictionary alloc]init];
    jokers = @{
               @"R" : @[@"black_joker", @"Black Joker"],
               @"S" : @[@"red_joker", @"Red Joker"],
               };
    
    [cards addEntriesFromDictionary:spades];
    [cards addEntriesFromDictionary:hearts];
    [cards addEntriesFromDictionary:diamonds];
    [cards addEntriesFromDictionary:clubs];
    [cards addEntriesFromDictionary:jokers];
    
    return cards;
}


@end
