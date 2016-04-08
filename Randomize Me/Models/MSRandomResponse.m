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

- (NSString*) parseError {
    if (self.error) {
        return self.responseBody[@"error"][@"message"];
    }
    else {
        return @"No errors!";
    }
}

- (NSString*) makeStringFromIntegerData {
    if ([self.methodName isEqualToString:@"generateSignedIntegers"]) {
        NSString *result = [[self.data valueForKey:@"description"] componentsJoinedByString:@" "];
        return result;
    }
    else return @"Sorry! Planned maintenance work on the server, try again later";
}

//Beacause of problem with parse double to string
- (NSString*) makeStringFromDecimalDataWithNumber:(NSInteger)number {
    if ([self.methodName isEqualToString:@"generateSignedDecimalFractions"]) {
        NSMutableString *mutableResult = [[NSMutableString alloc]init];
        for (NSInteger i=0; i < self.data.count; i++) {
            NSNumber *elementNumber = self.data[i];
            NSString *elementString = [elementNumber stringValue];
            
            //elementString = [element NsubstringToIndex: MIN(15, [str length])];
            
            int number2 = number + 2;
            if (elementString.length > number2) {
                elementString = [elementString substringToIndex: number2];
                [mutableResult appendString:[NSString stringWithFormat:@"%@ ", elementString]];
            } else {
                [mutableResult appendString:[NSString stringWithFormat:@"%@ ", elementString]];
            }
        }
        NSString *result = mutableResult;
        return result;
        

    }
    else return @"Sorry! Planned maintenance work on the server, try again later";
}


@end
