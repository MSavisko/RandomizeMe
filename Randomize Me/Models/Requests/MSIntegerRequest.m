//
//  MSIntegerRequest.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/5/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSIntegerRequest.h"
#import "MSApiKey.h"

@interface MSIntegerRequest ()
@end

@implementation MSIntegerRequest

- (instancetype) initWithNumberOfIntegers:(NSInteger)number
                         minBoundaryValue:(NSInteger)minValue
                         maxBoundaryValue:(NSInteger)maxValue
                           andReplacement:(BOOL)replacemet
                                  forBase:(NSInteger)base {
    self = [super init];
    if (self) {
        _requestId = arc4random_uniform(32767);
        _methodName = @"generateSignedIntegers";
        _number = number;
        _minValue = minValue;
        _maxValue = maxValue;
        _replacement = replacemet;
        _base = base;
    }
    return self;
}

- (void) setReplacement:(BOOL)replacement {
    _replacement = replacement;
};

- (NSDictionary*) makeRequestBody {
    NSDictionary *paramOfRequest = [[NSDictionary alloc]init];
    paramOfRequest = @{
                       @"apiKey" : MSRandomApiKey,
                       @"n" : [NSNumber numberWithInteger:self.number],
                       @"min" : [NSNumber numberWithInteger:self.minValue],
                       @"max" : [NSNumber numberWithInteger:self.maxValue],
                       @"replacement" : [NSNumber numberWithBool:self.replacement],
                       @"base": [NSNumber numberWithInteger:self.base]
                       };
    
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
    uniqueParam = @{
                    @"min" : [NSNumber numberWithInteger:self.minValue],
                    @"max" : [NSNumber numberWithInteger:self.maxValue],
                    @"base" : [NSNumber numberWithInteger:self.base],
                    };
    NSMutableDictionary *randomPartOfDict = [NSMutableDictionary
                                             dictionaryWithDictionary: @{
                                                                         @"method" : self.methodName,
                                                                         @"hashedApiKey" : MSRandomHashedApiKey,
                                                                         @"n" : [NSNumber numberWithInteger:self.number],
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
