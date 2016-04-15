//
//  ListRandomizer.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSRandomResponse.h"

@interface ListRandomizer : NSObject
@property (readonly, strong, nonatomic) NSMutableArray *inputList;
@property (readonly, strong, nonatomic) NSMutableArray *outputList;

- (instancetype) initWithList:(NSArray*)list;
- (void) randomizeWithResponse:(MSRandomResponse*)response;
- (NSString*) stringDescription;

@end
