//
//  MSRandomResponse.h
//  Randomize Me
//
//  Created by Maksym Savisko on 3/21/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRandomResponse : NSObject

@property (strong, nonatomic) NSString *methodName; //For ALL response
@property (strong, nonatomic) NSString *hashedApiKey; //For ALL response
@property (strong, nonatomic) NSArray *data; //For ALL response
@property (strong, nonatomic) NSString *completionTime; //For ALL response
@property (nonatomic) NSInteger serialNumber; //For ALL response
@property (strong, nonatomic) NSString *signature; //For ALL response
@property (nonatomic) NSInteger requestId; //For ALL response
@property (strong, nonatomic) NSDictionary *dictionaryData; //Use for ALL response
@property (nonatomic) BOOL error; //Use for ALL response

+ (MSRandomResponse*) parseResponseFromData:(NSDictionary*)data;

@end
