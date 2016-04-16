//
//  MSMSRandomStringsRequest.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/11/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomStringsRequest.h"
#import "MSRandomRequest.h"
#import "MSApiKey.h"

@implementation MSRandomStringsRequest

- (instancetype) initWithCount:(NSInteger)count length:(NSInteger)length forCharacters:(NSString*)characters unique:(BOOL)unique {
    self = [super initWithMethod:@"generateSignedStrings" count:count unique:unique];
    
    if (self) {
        _length = length;
        _characters = characters;
    }
    return self;
}

- (void) setCharacters:(NSString *)characters {
    _characters = characters;
}

- (NSDictionary*) requestBody {
    NSDictionary *paramOfRequest = [[NSDictionary alloc]init];
    paramOfRequest = @{
                       @"apiKey" : MSRandomApiKey,
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

@end
