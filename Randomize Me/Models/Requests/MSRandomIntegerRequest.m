//
//  MSRandomIntegerRequest.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/11/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomIntegerRequest.h"
#import "MSRandomRequest.h"
#import "MSApiKey.h"

@implementation MSRandomIntegerRequest

- (instancetype) initWithCount:(NSInteger)count min:(NSInteger)min max:(NSInteger)max unique:(BOOL)unique {
    self = [super initWithMethod:@"generateSignedIntegers" count:count unique:unique];
    if (self) {
        _minValue = min;
        _maxValue = max;
        _base = 10;
    }
    return self;
}

- (NSDictionary*) requestBody {
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

- (NSDictionary*) requestBodyWithSignature:(NSString*)signature
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
