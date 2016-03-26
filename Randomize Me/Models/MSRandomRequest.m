//
//  MSRandom.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/20/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomRequest.h"

@interface MSRandomRequest ()
@end

#warning change MY_API_KEY
static NSString *const MSApiKey = @"MY_API_KEY";
static NSString *const MShashedApiKey = @"BC/WYznRk76plu/5FxeAL85FWlpGMxC+jTkkm9ZyQY6+1doglqiX8hjq6T3srd0nSN47fgXd0UD7BI+YzFSwZg==";

@implementation MSRandomRequest

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
    }
    return self;
}

- (instancetype) initWithNumberOfStrings:(NSInteger)n
                               andLength:(NSInteger)length
                           forCharacters:(NSString*)characters
                          andReplacement:(BOOL)replacemet {
    self = [super init];
    if (self) {
        self.requestId = arc4random_uniform(32767);
        self.methodName = @"generateSignedStrings";
        self.n = n;
        self.length = length;
        self.characters = characters;
        self.replacement = replacemet;
    }
    return self;
}

- (NSDictionary*) makeRequestBody {
    NSDictionary * paramOfRequest = [[NSDictionary alloc]init];
    if ([self.methodName isEqualToString:@"generateSignedIntegers"]) {
        paramOfRequest = @{
                      @"apiKey" : MSApiKey,
                      @"n" : [NSNumber numberWithInteger:self.n],
                      @"min" : [NSNumber numberWithInteger:self.minValue],
                      @"max" : [NSNumber numberWithInteger:self.maxValue],
                      @"replacement" : [NSNumber numberWithBool:self.replacement],
                      @"base": [NSNumber numberWithInteger:self.base]
                      };
    }
    if ([self.methodName isEqualToString:@"generateSignedDecimalFractions"]) {
        paramOfRequest = @{
                      @"apiKey" : MSApiKey,
                      @"n" : [NSNumber numberWithInteger:self.n],
                      @"decimalPlaces" : [NSNumber numberWithInteger:self.decimalPlaces],
                      @"replacement" : [NSNumber numberWithBool:self.replacement],
                      };
    }
    if ([self.methodName isEqualToString:@"generateSignedStrings"]) {
        paramOfRequest = @{
                      @"apiKey" : MSApiKey,
                      @"n" : [NSNumber numberWithInteger:self.n],
                      @"length" : [NSNumber numberWithInteger:self.length],
                      @"characters" : self.characters,
                      @"replacement" : [NSNumber numberWithBool:self.replacement],
                      };
    }
    NSDictionary * requestBody = @{
                                  @"id" : [NSNumber numberWithInteger:self.requestId],
                                  @"jsonrpc" : @"2.0",
                                  @"method" : self.methodName,
                                  @"params" : paramOfRequest,
                                  };
    return requestBody;
}

- (NSDictionary*) makeRequestBodyWithSignature:(NSString*)signature
                               atCompletionTime:(NSString*)completionTime
                                         Serial:(NSInteger)serialNumber
                                   andDataArray:(NSArray*)array {
    if ([self.methodName isEqualToString:@"generateSignedIntegers"]) {
        return self;
    };
    return self;
}

@end
