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

- (BOOL) parseVerifyResponseFromData:(NSDictionary*)data {
    if ([data valueForKey:@"error"]) {
        _error = YES;
        _responseBody = data;
        return NO;
    }
    else {
        _error = NO;
        _responseBody = data;
        BOOL authenticity = [data[@"result"][@"authenticity"] boolValue];
        if (authenticity) {
            NSLog(@"Authenticity: %@", data[@"result"][@"authenticity"]);
            return YES;
        }
        else {
            NSLog(@"Authenticity: %@", data[@"result"][@"authenticity"]);
            return NO;
        }
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

#pragma mark - Make String for represent
- (NSString*) makeStringComplitionTime {
    return [self.completionTime substringToIndex:self.completionTime.length-1];
}


@end
