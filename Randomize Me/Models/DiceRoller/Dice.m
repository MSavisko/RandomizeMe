//
//  Dice.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "Dice.h"

@implementation Dice

- (instancetype) initWithName:(NSString*)name number:(NSInteger)number andImageName:(NSString*)imageName {
    self = [super init];
    if (self) {
        _name = name;
        _number = number;
        _imageName = imageName;
    }
    return self;
}

@end
