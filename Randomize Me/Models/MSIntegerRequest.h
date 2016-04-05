//
//  MSIntegerRequest.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/5/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSIntegerRequest : NSObject

@property (readonly, nonatomic) NSInteger requestId;
@property (readonly, strong, nonatomic) NSString *methodName;
@property (readonly, nonatomic) BOOL replacement;
@property (readonly, nonatomic) NSInteger number;
@property (readonly, nonatomic) NSInteger minValue;
@property (readonly, nonatomic) NSInteger maxValue;
@property (readonly, nonatomic) NSInteger base;

- (instancetype) initWithNumberOfIntegers:(NSInteger)number minBoundaryValue:(NSInteger)minValue maxBoundaryValue:(NSInteger)maxValue andReplacement:(BOOL)replacemet forBase:(NSInteger)base;

//Make request body for integer generation
- (NSDictionary*) makeRequestBody;

//Make Verify Request Body
- (NSDictionary*) makeRequestBodyWithSignature:(NSString*)signature atCompletionTime:(NSString*)completionTime serial:(NSInteger)serialNumber andDataArray:(NSArray*)array;

//Because of changing state switch need
- (void) setReplacement:(BOOL)replacement;

@end
