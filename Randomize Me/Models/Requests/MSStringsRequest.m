//
//  MSStringsRequest.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/5/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSStringsRequest.h"
#import "MSRandomApiKey.h"

@interface MSStringsRequest ()
@end

@implementation MSStringsRequest

- (instancetype) initWithNumberOfStrings:(NSInteger)number
                               andLength:(NSInteger)length
                           forCharacters:(NSString*)characters
                          andReplacement:(BOOL)replacemet {
    self = [super init];
    if (self) {
        _requestId = arc4random_uniform(32767);
        _methodName = @"generateSignedStrings";
        _number = number;
        _length = length;
        _characters = characters;
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
                       @"length" : [NSNumber numberWithInteger:self.length],
                       @"characters" : self.characters,
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
                    @"length" : [NSNumber numberWithInteger:self.length],
                    @"characters" : self.characters,
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
