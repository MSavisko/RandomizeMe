//
//  MSRandomDecimalRequest.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/11/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomDecimalRequest.h"
#import "MSRandomRequest.h"
#import "MSApiKey.h"

@implementation MSRandomDecimalRequest

- (instancetype) initWithCount:(NSInteger)count andDecimalPlaces:(NSInteger)decimalPlaces {
    self = [super initWithMethod:@"generateSignedDecimalFractions" count:count unique:YES];
    if (self) {
        _decimalPlaces = decimalPlaces;
    }
    
    return self;
}

- (NSDictionary*) requestBody {
    NSDictionary *paramOfRequest = [[NSDictionary alloc]init];
    paramOfRequest = @{
                       @"apiKey" : MSRandomApiKey,
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

- (NSDictionary*) requestBodyWithSignature:(NSString*)signature
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
