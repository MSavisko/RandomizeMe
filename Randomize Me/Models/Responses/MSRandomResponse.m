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
- (NSString*) makeStringWithSpaceFromIntegerData {
    if ([self.methodName isEqualToString:@"generateSignedIntegers"]) {
        NSString *result = [[self.data valueForKey:@"description"] componentsJoinedByString:@" "];
        return result;
    }
    else return @"Sorry! Planned maintenance work on the server, try again later";
}

- (NSString*) makeStringWithSpaceFromDecimalDataWithNumber: (NSInteger)number {
    if ([self.methodName isEqualToString:@"generateSignedDecimalFractions"]) {
        NSMutableString *mutableResult = [[NSMutableString alloc]init];
        for (NSInteger i=0; i < self.data.count; i++) {
            NSNumber *elementNumber = self.data[i];
            
            //Rounding, because of some double much longer than other
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [formatter setMaximumFractionDigits:number];
            [formatter setRoundingMode: NSNumberFormatterRoundUp];
            NSString *numberString = [formatter stringFromNumber:elementNumber];
            
            //Appending, because we need space between result number
            [mutableResult appendString:[NSString stringWithFormat:@"%@ ", numberString]];
        }
        return mutableResult;
    }
    else return @"Sorry! Planned maintenance work on the server, try again later";
}

- (NSString*) makeStringComplitionTime {
    return [self.completionTime substringToIndex:self.completionTime.length-1];
}

#pragma mark - Make String for Share
- (NSString*) makeStringFromAllIntegerData {
    NSString *resultName = @"Integer Generation";
    NSString *forResult = @"Result:";
    NSString *resultData = [self makeStringWithSpaceFromIntegerData];
    
    NSString *parametrs = @"Parameters of generation:";
    NSString *numberOfIntegers = [NSString stringWithFormat:@"Number of integers: %@", self.responseBody[@"result"][@"random"][@"n"]];
    
    NSString *minValue = [NSString stringWithFormat:@"Minimum value: %@", self.responseBody[@"result"][@"random"][@"min"]];
    NSString *maxValue = [NSString stringWithFormat:@"Maximum value: %@", self.responseBody[@"result"][@"random"][@"max"]];
    
    NSString *replacement = [NSString stringWithFormat:@"Unique integers: %@", self.responseBody[@"result"][@"random"][@"replacement"]];
    
    NSString *individualInformation = @"Individual information of generation:";
    NSString *completionTime = [NSString stringWithFormat:@"Completion time (UTC+0): %@", [self makeStringComplitionTime]];
    NSString *serialNumber = [NSString stringWithFormat:@"Serial Number: %ld", (long)self.serialNumber];
    NSString *signature = [NSString stringWithFormat:@"Signature: %@", self.signature];
    
    NSString *result = [NSString stringWithFormat:@"%@\r\r%@\r%@\r\r%@\r%@\r%@\r%@\r%@\r\r%@\r%@\r%@\r%@", resultName, forResult, resultData, parametrs, numberOfIntegers, minValue, maxValue, replacement, individualInformation, completionTime, serialNumber, signature];
    
    return result;
}


@end
