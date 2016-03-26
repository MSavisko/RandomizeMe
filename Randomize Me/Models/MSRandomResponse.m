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

static NSString *const MSHashedApiKey = @"BC/WYznRk76plu/5FxeAL85FWlpGMxC+jTkkm9ZyQY6+1doglqiX8hjq6T3srd0nSN47fgXd0UD7BI+YzFSwZg==";

@implementation MSRandomResponse

+ (instancetype) parseResponseFromData:(NSDictionary*)data {
    MSRandomResponse * response = [[MSRandomResponse alloc]init];
    if ([data valueForKey:@"error"] != nil) {
        response.error = YES;
        response.dictionaryData = data;
        return response;
    }
    else {
        response.error = NO;
        response.methodName = data[@"result"][@"random"][@"method"];
        response.hashedApiKey = data[@"result"][@"random"][@"hashedApiKey"];
        response.data = data[@"result"][@"random"][@"data"];
        response.completionTime = data[@"result"][@"random"][@"completionTime"];
        response.serialNumber = [data[@"result"][@"random"][@"serialNumber"] integerValue];
        response.signature = data[@"result"][@"signature"];
        response.dictionaryData = data;
        return response;
    }
}

@end
