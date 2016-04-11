//
//  MSStringsRandomRequest.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/11/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomRequest.h"

@interface MSStringsRandomRequest : MSRandomRequest

@property (readonly, nonatomic) NSInteger length;
@property (readonly, strong, nonatomic) NSString *characters;

- (instancetype) initWithCount:(NSInteger)count length:(NSInteger)length forCharacters:(NSString*)characters unique:(BOOL)unique;

- (NSDictionary*) requestBody;

- (NSDictionary*) requestBodyWithSignature:(NSString*)signature atCompletionTime:(NSString*)completionTime serial:(NSInteger)serialNumber andDataArray:(NSArray*)array;

@end
