//
//  Card.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/14/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "Card.h"

@implementation Card

- (instancetype) initWithName:(NSString*)name andImageName:(NSString*)imageName {
    self = [super init];
    if (self) {
        _name = name;
        _imageName = imageName;
    }
    return self;
}

@end
