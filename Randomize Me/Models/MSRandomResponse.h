//
//  MSRandomResponse.h
//  Randomize Me
//
//  Created by Maksym Savisko on 3/21/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRandomResponse : NSObject

@property (readonly, strong, nonatomic) NSString *methodName; //For ALL response
@property (readonly, strong, nonatomic) NSString *hashedApiKey; //For ALL response
@property (readonly, strong, nonatomic) NSArray *data; //For ALL response
@property (readonly ,strong, nonatomic) NSString *completionTime; //For ALL response
@property (readonly, nonatomic) NSInteger serialNumber; //For ALL response
@property (readonly, strong, nonatomic) NSString *signature; //For ALL response
@property (readonly, nonatomic) NSInteger requestId; //For ALL response
@property (readonly, strong, nonatomic) NSDictionary *responseBody; //Use for ALL response
@property (readonly, nonatomic) BOOL error; //Use for ALL response

- (void) parseResponseFromData:(NSDictionary*)data;
- (BOOL) parseVerifyResponseFromData:(NSDictionary*)data;
- (NSString*) parseError;

@end
