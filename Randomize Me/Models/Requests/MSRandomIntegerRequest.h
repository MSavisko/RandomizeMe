//
//  MSRandomIntegerRequest.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/11/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomRequest.h"

@interface MSRandomIntegerRequest : MSRandomRequest

@property (readonly, nonatomic) NSInteger minValue;
@property (readonly, nonatomic) NSInteger maxValue;
@property (readonly, nonatomic) NSInteger base;

- (instancetype) initWithCount:(NSInteger)count min:(NSInteger)min max:(NSInteger)max unique:(BOOL)unique;

- (NSDictionary*) requestBody;

- (NSDictionary*) requestBodyWithSignature:(NSString*)signature atCompletionTime:(NSString*)completionTime serial:(NSInteger)serialNumber andDataArray:(NSArray*)array;

@end
