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

@end
