//
//  MSRandomStringsRequest.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/11/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSRandomRequest.h"

@interface MSRandomStringsRequest : MSRandomRequest

@property (readonly, nonatomic) NSInteger length;
@property (readonly, strong, nonatomic) NSString *characters;

- (instancetype) initWithCount:(NSInteger)count length:(NSInteger)length forCharacters:(NSString*)characters unique:(BOOL)unique;

- (void) setCharacters:(NSString *)characters;

- (NSDictionary*) requestBody;

@end
