//
//  MSRandomRequest.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/20/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomRequest.h"

@interface MSRandomRequest ()
@end

#warning replace MY_API_KEY
static NSString *const MSApiKey = @"MY_API_KEY";
static NSString *const MSHashedApiKey = @"BC/WYznRk76plu/5FxeAL85FWlpGMxC+jTkkm9ZyQY6+1doglqiX8hjq6T3srd0nSN47fgXd0UD7BI+YzFSwZg==";

@implementation MSRandomRequest

- (instancetype) initWithNumberOfIntegers:(NSInteger)n
                         minBoundaryValue:(NSInteger)minValue
                         maxBoundaryValue:(NSInteger)maxValue
                           andReplacement:(BOOL)replacemet
                                  forBase:(NSInteger)base {
    self = [super init];
    if (self) {
        _requestId = arc4random_uniform(32767);
        _methodName = @"generateSignedIntegers";
        _n = n;
        _minValue = minValue;
        _maxValue = maxValue;
        _replacement = replacemet;
        _base = base;
    }
    return self;
}

- (instancetype) initWithNumberOfDecimalFractions:(NSInteger)n
                                    DecimalPlaces:(NSInteger)decimalPlaces
                                   andReplacement:(BOOL)replacemet {
    self = [super init];
    if (self) {
        _requestId = arc4random_uniform(32767);
        _methodName = @"generateSignedDecimalFractions";
        _n = n;
        _decimalPlaces = decimalPlaces;
        _replacement = replacemet;
    }
    return self;
}

- (instancetype) initWithNumberOfStrings:(NSInteger)n
                               andLength:(NSInteger)length
                           forCharacters:(NSString*)characters
                          andReplacement:(BOOL)replacemet {
    self = [super init];
    if (self) {
        _requestId = arc4random_uniform(32767);
        _methodName = @"generateSignedStrings";
        _n = n;
        _length = length;
        _characters = characters;
        _replacement = replacemet;
    }
    return self;
}

- (void) setReplacement:(BOOL)replacement {
    _replacement = replacement;
};

- (NSDictionary*) makeRequestBody {
    NSDictionary *paramOfRequest = [[NSDictionary alloc]init];
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
    NSDictionary *requestBody = @{
                                  @"id" : [NSNumber numberWithInteger:self.requestId],
                                  @"jsonrpc" : @"2.0",
                                  @"method" : self.methodName,
                                  @"params" : paramOfRequest,
                                  };
    return requestBody;
}

- (NSDictionary*) makeRequestBodyWithSignature:(NSString*)signature
                              atCompletionTime:(NSString*)completionTime
                                        serial:(NSInteger)serialNumber
                                  andDataArray:(NSArray*)array {
    NSDictionary * uniqueParam = [[NSDictionary alloc]init];
    if ([self.methodName isEqualToString:@"generateSignedIntegers"]) {
        uniqueParam = @{
                        @"min" : [NSNumber numberWithInteger:self.minValue],
                        @"max" : [NSNumber numberWithInteger:self.maxValue],
                        @"base" : [NSNumber numberWithInteger:self.base],
                        };
    };
    if ([self.methodName isEqualToString:@"generateSignedDecimalFractions"]) {
        uniqueParam = @{
                        @"decimalPlaces" : [NSNumber numberWithInteger:self.decimalPlaces],
                        };
    }
    if ([self.methodName isEqualToString:@"generateSignedStrings"]) {
        uniqueParam = @{
                        @"length" : [NSNumber numberWithInteger:self.length],
                        @"characters" : self.characters,
                        };
    }
    NSMutableDictionary *randomPartOfDict = [NSMutableDictionary
                                   dictionaryWithDictionary: @{
                                                               @"method" : self.methodName,
                                                               @"hashedApiKey" : MSHashedApiKey,
                                                               @"n" : [NSNumber numberWithInteger:self.n],
                                                               @"replacement" : [NSNumber numberWithBool:self.replacement],
                                                               @"data" : array,
                                                               @"completionTime" : completionTime,
                                                               @"serialNumber" : [NSNumber numberWithInteger:serialNumber],
                                                               }];
    [randomPartOfDict addEntriesFromDictionary: uniqueParam];
    NSDictionary * requestBody = @{
                                   @"jsonrpc": @"2.0",
                                   @"method": @"verifySignature",
                                   @"params" : @{@"random" : randomPartOfDict, @"signature" : signature,},
                                   @"id" : [NSNumber numberWithInteger:self.requestId],
                                   };
    
    return requestBody;
}

@end
