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

static NSString *const hashedApiKey = @"BC/WYznRk76plu/5FxeAL85FWlpGMxC+jTkkm9ZyQY6+1doglqiX8hjq6T3srd0nSN47fgXd0UD7BI+YzFSwZg==";

@implementation MSRandomResponse

+ (MSRandomResponse*) parseFromData:(NSDictionary*)data {
    MSRandomResponse * response = [[MSRandomResponse alloc]init];
    response.methodName = data[@"result"][@"random"][@"method"];
    if ([response.methodName isEqualToString:@"generateSignedIntegers"]) {
        NSLog(@"This method is:%@", response.methodName);
    }
    return response;
}

@end
