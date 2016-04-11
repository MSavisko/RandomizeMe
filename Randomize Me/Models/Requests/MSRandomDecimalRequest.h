//
//  MSRandomDecimalRequest.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/11/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomRequest.h"

@interface MSRandomDecimalRequest : MSRandomRequest

@property (readonly, nonatomic) NSInteger decimalPlaces;

- (instancetype) initWithCount:(NSInteger)count andDecimalPlaces:(NSInteger)decimalPlaces;

- (NSDictionary*) requestBody;

- (NSDictionary*) requestBodyWithSignature:(NSString*)signature atCompletionTime:(NSString*)completionTime serial:(NSInteger)serialNumber andDataArray:(NSArray*)array;

@end
