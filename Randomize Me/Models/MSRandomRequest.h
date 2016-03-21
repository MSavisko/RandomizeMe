//
//  MSRandom.h
//  Randomize Me
//
//  Created by Maksym Savisko on 3/20/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRandomRequest : NSObject

@property (nonatomic) NSInteger requestId; //Use for ALL requests
@property (nonatomic, strong) NSString * methodName; //Use for ALL requests
@property (nonatomic) BOOL replacement; //Use for ALL requests
@property (nonatomic, strong) NSDictionary * dictionaryData; //Use for ALL requests
@property (nonatomic) NSInteger n; //Use for generateSignedIntegers and generateSignedDecimalFractions requests
@property (nonatomic) NSInteger minValue; //Use for generateSignedIntegers request
@property (nonatomic) NSInteger maxValue; //Use for generateSignedIntegers request
@property (nonatomic) NSInteger base; //Use for generateSignedIntegers request
@property (nonatomic) NSInteger decimalPlaces; //Use for generateSignedDecimalFractions request
@property (nonatomic) NSInteger length; //Use for generateSignedStrings request
@property (nonatomic) NSString * characters; //Use for generateSignedStrings request

//Initialization for Integers generation
- (instancetype) initWithNumberOfIntegers:(NSInteger)n minBoundaryValue:(NSInteger)minValue maxBoundaryValue:(NSInteger)maxValue andReplacement:(BOOL)replacemet forBase:(NSInteger)base;
//Initialization for Decimals generation
- (instancetype) initWithNumberOfDecimalFractions:(NSInteger)n DecimalPlaces:(NSInteger)decimalPlaces andReplacement:(BOOL)replacemet;
//Initialization for String generation
- (instancetype) initWithNumberOfStrings:(NSInteger)n andLength:(NSInteger)length forCharacters:(NSString*)characters;

@end
