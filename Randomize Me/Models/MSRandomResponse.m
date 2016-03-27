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

- (void) parseResponseFromData:(NSDictionary*)data {
    if ([data valueForKey:@"error"]) {
        self.error = YES;
        self.responseBody = data;
    }
    else {
        self.error = NO;
        self.methodName = data[@"result"][@"random"][@"method"];
        self.hashedApiKey = data[@"result"][@"random"][@"hashedApiKey"];
        self.data = data[@"result"][@"random"][@"data"];
        self.completionTime = data[@"result"][@"random"][@"completionTime"];
        self.serialNumber = [data[@"result"][@"random"][@"serialNumber"] integerValue];
        self.signature = data[@"result"][@"signature"];
        self.responseBody = data;
    }
}

- (BOOL) parseVerifyResponseFromData:(NSDictionary*)data {
    if ([data valueForKey:@"error"]) {
        self.error = YES;
        self.responseBody = data;
        return NO;
    }
    else {
        self.error = NO;
        self.responseBody = data;
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

- (NSString*) parseError {
    if (self.error) {
        return self.responseBody[@"error"][@"message"];
    }
    else {
        return @"No errors!";
    }
}


@end
