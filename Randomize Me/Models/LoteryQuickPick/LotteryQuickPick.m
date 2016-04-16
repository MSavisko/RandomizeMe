//
//  LoteryTicket.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/16/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "LotteryQuickPick.h"
#import "MSRandomIntegerRequest.h"
#import "MSRandomResponse.h"

@implementation LotteryQuickPick


- (instancetype) initWithName:(NSString*)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (MSRandomIntegerRequest*) request {
    if ([_name isEqualToString:@"Keno"]) {
        MSRandomIntegerRequest *kenoRequest = [[MSRandomIntegerRequest alloc]initWithCount:10 min:1 max:80 unique:YES];
        return kenoRequest;
    }
    else if ([_name isEqualToString:@"Megalot"]) {
        MSRandomIntegerRequest *megalotRequest = [[MSRandomIntegerRequest alloc]initWithCount:6 min:1 max:42 unique:YES];
        return megalotRequest;
    }
    else {
        MSRandomIntegerRequest *nationalRequest = [[MSRandomIntegerRequest alloc]initWithCount:6 min:1 max:52 unique:YES];
        return nationalRequest;
    }
}

- (NSString*) pickFromResponse:(MSRandomResponse*)response {
    NSMutableString *firstPart = [[NSMutableString alloc]init];
    for (int i = 0; i < response.data.count; i++) {
        NSString *stringNumber = [NSString stringWithFormat:@"%@", response.data[i]];
        if (stringNumber.length == 1) {
            [firstPart appendString:[NSString stringWithFormat:@"0%@-",stringNumber]];
        }
        else {
            [firstPart appendString:[NSString stringWithFormat:@"%@-",stringNumber]];
        }
    }
    NSString *mediumResult = [firstPart substringToIndex:firstPart.length - 1];
    NSMutableString *result = [[NSMutableString alloc]initWithString:mediumResult];
    if ([_name isEqualToString:@"Megalot"]) {
        NSString *lastNumber = [NSString stringWithFormat:@" / %02d", arc4random_uniform(10)];
        [result appendString:lastNumber];
    }
    return result;
}

@end
