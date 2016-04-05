//
//  MSStringsRequest.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/5/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSStringsRequest : NSObject
@property (readonly, nonatomic) NSInteger requestId;
@property (readonly, strong, nonatomic) NSString *methodName;
@property (readonly, nonatomic) BOOL replacement;
@property (readonly, nonatomic) NSInteger number;
@property (readonly, nonatomic) NSInteger length;
@property (readonly, strong, nonatomic) NSString *characters;

- (instancetype) initWithNumberOfStrings:(NSInteger)number andLength:(NSInteger)length forCharacters:(NSString*)characters andReplacement:(BOOL)replacemet;

- (void) setReplacement:(BOOL)replacement;

- (NSDictionary*) makeRequestBody;

- (NSDictionary*) makeRequestBodyWithSignature:(NSString*)signature atCompletionTime:(NSString*)completionTime serial:(NSInteger)serialNumber andDataArray:(NSArray*)array;

@end
