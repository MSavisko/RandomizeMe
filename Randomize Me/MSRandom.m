//
//  MSRandom.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/20/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandom.h"

@interface MSRandom ()
@end

#warning change MY_API
static NSString *const apiKey = @"MY_API";
static NSString *const hashedApiKey = @"BC/WYznRk76plu/5FxeAL85FWlpGMxC+jTkkm9ZyQY6+1doglqiX8hjq6T3srd0nSN47fgXd0UD7BI+YzFSwZg==";

@implementation MSRandom

- (instancetype) initWithNumberOfIntegers:(NSInteger)n
                    minBoundaryValue:(NSInteger)minValue
                    maxBoundaryValue:(NSInteger)maxValue
                 andReplacement:(BOOL)replacemet
                        forBase:(NSInteger)base {
    self = [super init];
    if (self) {
        self.requestId = arc4random_uniform(32767);
        self.methodName = @"generateSignedIntegers";
        self.n = n;
        self.minValue = minValue;
        self.maxValue = maxValue;
        self.replacement = replacemet;
        self.base = base;
        NSDictionary * paramData = @{
                                @"apiKey" : apiKey,
                                @"n" : [NSNumber numberWithInteger:n],
                                @"min" : [NSNumber numberWithInteger:minValue],
                                @"max" : [NSNumber numberWithInteger:maxValue],
                                @"replacement" : [NSNumber numberWithBool:replacemet],
                                @"base": [NSNumber numberWithInteger:base]
                                };
        
        self.dictionaryData = @{
                                  @"id" : [NSNumber numberWithInteger:self.requestId],
                                  @"jsonrpc" : @"2.0",
                                  @"method" : self.methodName,
                                  @"params" : paramData
                                  };
        
        
    }
    return self;
}

- (instancetype) initWithNumberOfDecimalFractions:(NSInteger)n
                                    DecimalPlaces:(NSInteger)decimalPlaces
                                   andReplacement:(BOOL)replacemet {
    self = [super init];
    if (self) {
        self.requestId = arc4random_uniform(32767);
        self.methodName = @"generateSignedDecimalFractions";
        self.n = n;
        self.decimalPlaces = decimalPlaces;
        self.replacement = replacemet;
        NSDictionary * paramData = @{
                                     @"apiKey" : apiKey,
                                     @"n" : [NSNumber numberWithInteger:n],
                                     @"decimalPlaces" : [NSNumber numberWithInteger:decimalPlaces],
                                     @"replacement" : [NSNumber numberWithBool:replacemet],
                                     };
        
        self.dictionaryData = @{
                                @"id" : [NSNumber numberWithInteger:self.requestId],
                                @"jsonrpc" : @"2.0",
                                @"method" : self.methodName,
                                @"params" : paramData
                                };
    }
    return self;
}

- (instancetype) initWithNumberOfStrings:(NSInteger)n
                               andLength:(NSInteger)length
                           forCharacters:(NSString*)characters {
    self = [super init];
    if (self) {
        self.requestId = arc4random_uniform(32767);
        self.methodName = @"generateSignedStrings";
        self.n = n;
        self.length = length;
        self.characters = characters;
    }
    return self;
}

@end
