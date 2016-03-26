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
    if ([data valueForKey:@"error"] != nil) {
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


@end
