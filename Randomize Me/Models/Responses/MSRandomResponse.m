//
//  MSRandomResponse.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/21/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomResponse.h"

@interface MSRandomResponse ()
@end

@implementation MSRandomResponse

#pragma mark - Parse from Data
- (void) parseResponseFromData:(NSDictionary*)data {
    if ([data valueForKey:@"error"]) {
        _error = YES;
        _responseBody = data;
    }
    else {
        _error = NO;
        _methodName = data[@"result"][@"random"][@"method"];
        _hashedApiKey = data[@"result"][@"random"][@"hashedApiKey"];
        _data = data[@"result"][@"random"][@"data"];
        _completionTime = data[@"result"][@"random"][@"completionTime"];
        _serialNumber = [data[@"result"][@"random"][@"serialNumber"] integerValue];
        _signature = data[@"result"][@"signature"];
        _responseBody = data;
    }
}

#pragma mark - Parse Error
- (NSString*) parseError {
    if (self.error) {
        return self.responseBody[@"error"][@"message"];
    }
    else {
        return @"No errors!";
    }
}


@end
