//
//  ListRandomizer.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "ListRandomizer.h"
#import "MSRandomResponse.h"

@implementation ListRandomizer

- (instancetype) initWithList:(NSArray*)list {
    self = [super init];
    if (self) {
        NSMutableArray *dictArray = [[NSMutableArray alloc]init];
        
        for (NSInteger i = 0; i < list.count; i++) {
            NSString *currentPosition = [NSString stringWithFormat:@"%ld", (long)i];
            NSString *text = [NSString stringWithFormat:@"%@", list[i]];
            
            NSMutableDictionary *line = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                        @"current_position" : currentPosition,
                                                                                        @"text" : text,
                                                                                        @"new_position" : @"0"
                                                                                        }];
            
            [dictArray addObject:line];
        }
        _inputList = dictArray;
    }
    return self;
}

- (void) randomizeWithResponse:(MSRandomResponse*)response {
    NSArray *data = response.data;
    NSMutableArray *randomizeList = _inputList;
    
    for (int i = 0; i < randomizeList.count; i++) {
        NSString *newPosition = [NSString stringWithFormat:@"%@", data[i]];
        randomizeList[i][@"new_position"] = newPosition;
    }
    
    NSSortDescriptor *newPositionDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"new_position" ascending:YES];
    
    NSArray *descriptors = @[newPositionDescriptor];
    
    [randomizeList sortUsingDescriptors:descriptors];
    _outputList = randomizeList;
}

- (NSString*) stringDescription {
    NSMutableString * result = [[NSMutableString alloc]init];
    for (int i = 0; i < self.outputList.count; i++) {
        NSString *number = [NSString stringWithFormat:@"%d. ", i + 1];
        NSString *lineText = [NSString stringWithFormat:@"%@\n", self.outputList[i][@"text"]];
        [result appendString:number];
        [result appendString:lineText];
    }
    return result;
    
}

@end
