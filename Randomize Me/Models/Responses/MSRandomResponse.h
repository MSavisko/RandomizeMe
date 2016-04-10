//
//  MSRandomResponse.h
//  Randomize Me
//
//  Created by Maksym Savisko on 3/21/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRandomResponse : NSObject

@property (readonly, strong, nonatomic) NSString *methodName;
@property (readonly, strong, nonatomic) NSString *hashedApiKey;
@property (readonly, strong, nonatomic) NSArray *data;
@property (readonly, strong, nonatomic) NSString *completionTime;
@property (readonly, nonatomic) NSInteger serialNumber;
@property (readonly, strong, nonatomic) NSString *signature;
@property (readonly, nonatomic) NSInteger requestId;
@property (readonly, strong, nonatomic) NSDictionary *responseBody;
@property (readonly, nonatomic) BOOL error;

- (void) parseResponseFromData:(NSDictionary*)data;
- (BOOL) parseVerifyResponseFromData:(NSDictionary*)data;
- (NSString*) parseError;
- (NSString*) makeStringWithSpaceFromIntegerData;
- (NSString*) makeStringWithSpaceFromDecimalDataWithNumber: (NSInteger)number;
- (NSString*) makeStringComplitionTime;
- (NSString*) makeStringFromAllIntegerData;

@end
