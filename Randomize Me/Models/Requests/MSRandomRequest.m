//
//  MSRandomRequest.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/11/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomRequest.h"

@interface MSRandomRequest ()
@end

@implementation MSRandomRequest

- (instancetype) initWithMethod:(NSString*)method count:(NSInteger)count unique:(BOOL)unique {
    self = [super init];
    if (self) {
        _requestId = arc4random_uniform(32767);
        _methodName = method;
        _replacement = !unique;
        _number = count;
    }
    return self;
}

@end
