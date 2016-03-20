//
//  MSRandom.h
//  Randomize Me
//
//  Created by Maksym Savisko on 3/20/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRandom : NSObject

//Use for generateSignedIntegers
@property (nonatomic) NSInteger requestId;
@property (nonatomic, strong) NSString * methodName;
@property (nonatomic, strong) NSString * hashedApiKey;
@property (nonatomic) NSInteger n;
@property (nonatomic) NSInteger minValue;
@property (nonatomic) NSInteger maxValue;
@property (nonatomic) BOOL replacement;
@property (nonatomic) NSInteger base;
@property (nonatomic, strong) NSArray * data; //only for response
@property (nonatomic, strong) NSString * completionTime; //only for response
@property (nonatomic) NSInteger serialNumber; //only for response
@property (nonatomic, strong) NSString * signature; //only for response
@property (nonatomic, strong) NSDictionary * dictionaryData;
//Use for generateSignedDecimalFractions
@property (nonatomic) NSInteger decimalPlaces;

//Use for generateSignedStrings
@property (nonatomic) NSInteger length;
@property (nonatomic) NSString * characters;

//Use for verifySignature
@property (nonatomic, strong) NSString * methodVerifyName;

//Initialization for Integers generation
- (instancetype) initWithNumberOfIntegers:(NSInteger)n minBoundaryValue:(NSInteger)minValue maxBoundaryValue:(NSInteger)maxValue andReplacement:(BOOL)replacemet forBase:(NSInteger)base;
//Initialization for Decimals generation
- (instancetype) initWithNumberOfDecimalFractions:(NSInteger)n DecimalPlaces:(NSInteger)decimalPlaces andReplacement:(BOOL)replacemet;
//Initialization for String generation
- (instancetype) initWithNumberOfStrings:(NSInteger)n andLength:(NSInteger)length forCharacters:(NSString*)characters;

@end
