//
//  MSDecimalRequest.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/5/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSDecimalRequest.h"
#import "MSRandomApiKey.h"

@interface MSDecimalRequest ()
@end

@implementation MSDecimalRequest

- (instancetype) initWithNumberOfDecimalFractions:(NSInteger)number
                                    DecimalPlaces:(NSInteger)decimalPlaces
                                   andReplacement:(BOOL)replacemet {
    self = [super init];
    if (self) {
        _requestId = arc4random_uniform(32767);
        _methodName = @"generateSignedDecimalFractions";
        _number = number;
        _decimalPlaces = decimalPlaces;
        _replacement = replacemet;
    }
    return self;
}

- (void) setReplacement:(BOOL)replacement {
    _replacement = replacement;
}

- (NSDictionary*) makeRequestBody {
    NSDictionary *paramOfRequest = [[NSDictionary alloc]init];
    paramOfRequest = @{
                       @"apiKey" : MSApiKey,
                       @"n" : [NSNumber numberWithInteger:self.number],
                       @"decimalPlaces" : [NSNumber numberWithInteger:self.decimalPlaces],
                       @"replacement" : [NSNumber numberWithBool:self.replacement],
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
                    @"decimalPlaces" : [NSNumber numberWithInteger:self.decimalPlaces],
                    };
    NSMutableDictionary *randomPartOfDict = [NSMutableDictionary
                                             dictionaryWithDictionary: @{
                                                                         @"method" : self.methodName,
                                                                         @"hashedApiKey" : MSHashedApiKey,
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
