//
//  MSRandomRequest.h
//  Randomize Me
//
//  Created by Maksym Savisko on 3/20/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRandomRequest : NSObject

@property (readonly, nonatomic) NSInteger requestId; //Use for ALL requests
@property (readonly, strong, nonatomic) NSString *methodName; //Use for ALL requests
@property (readonly, nonatomic) BOOL replacement; //Use for ALL requests
@property (readonly, nonatomic) NSInteger n; //Use for generateSignedIntegers and generateSignedDecimalFractions requests
@property (readonly, nonatomic) NSInteger minValue; //Use for generateSignedIntegers request
@property (readonly, nonatomic) NSInteger maxValue; //Use for generateSignedIntegers request
@property (readonly, nonatomic) NSInteger base; //Use for generateSignedIntegers request
@property (readonly, nonatomic) NSInteger decimalPlaces; //Use for generateSignedDecimalFractions request
@property (readonly, nonatomic) NSInteger length; //Use for generateSignedStrings request
@property (readonly, strong, nonatomic) NSString *characters; //Use for generateSignedStrings request

//Initialization for Integers generation
- (instancetype) initWithNumberOfIntegers:(NSInteger)n minBoundaryValue:(NSInteger)minValue maxBoundaryValue:(NSInteger)maxValue andReplacement:(BOOL)replacemet forBase:(NSInteger)base;

//Initialization for Decimals generation
- (instancetype) initWithNumberOfDecimalFractions:(NSInteger)n DecimalPlaces:(NSInteger)decimalPlaces andReplacement:(BOOL)replacemet;

//Initialization for String generation
- (instancetype) initWithNumberOfStrings:(NSInteger)n andLength:(NSInteger)length forCharacters:(NSString*)characters andReplacement:(BOOL)replacemet;

//Make Random Request Body
- (NSDictionary*) makeRequestBody;

//Make Verify Request Body
- (NSDictionary*) makeRequestBodyWithSignature:(NSString*)signature atCompletionTime:(NSString*)completionTime serial:(NSInteger)serialNumber andDataArray:(NSArray*)array;

//Because of changing state switch need
- (void) setReplacement:(BOOL)replacement;


@end
