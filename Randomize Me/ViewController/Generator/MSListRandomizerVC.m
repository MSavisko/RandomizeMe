//
//  MSListRandomizerVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSListRandomizerVC.h"

@implementation MSListRandomizerVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    //[self testSample];
    //[self textViewSample];
}

- (void) textViewSample {
    NSString *textFieldText = [NSString stringWithFormat:@"First \nSecond\nThird\nFourth\nFifth"];
    NSArray *lines = [textFieldText componentsSeparatedByString:@"\n"];
    NSLog(@"%@", lines);
}

- (void) testSample {
    NSArray *listArray = @[@"Ivanov", @"Petrov", @"Sidorov", @"Petrov2", @"Ivanov2", @"Shevchenko", @"Ivanov3", @"Sidorov4"];
    
    NSMutableArray *dictArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < listArray.count; i++) {
        NSString *currentPosition = [NSString stringWithFormat:@"%ld", (long)i];
        NSString *text = [NSString stringWithFormat:@"%@", listArray[i]];
        
        
        NSMutableDictionary *line = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"current_position" : currentPosition,
                                                                                    @"text" : text,
                                                                                    @"new_position" : @"0"
                                                                                    }];
        
        [dictArray addObject:line];
    }
    
    NSArray *data = @[@8, @6, @3, @5, @4, @1, @7, @2];
    
    for (int i = 0; i < listArray.count; i++) {
        NSString *newPosition = [NSString stringWithFormat:@"%@", data[i]];
        dictArray[i][@"new_position"] = newPosition;
    }
    
    NSSortDescriptor *newPositionDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"new_position" ascending:YES];
    
    NSArray *descriptors = @[newPositionDescriptor];
    
    [dictArray sortUsingDescriptors:descriptors];
    
    NSMutableString * stringResult = [[NSMutableString alloc]init];
    for (int i = 0; i < dictArray.count; i++) {
        NSString *number = [NSString stringWithFormat:@"%d. ", i + 1];
        NSString *lineText = [NSString stringWithFormat:@"%@\n", dictArray[i][@"text"]];
        [stringResult appendString:number];
        [stringResult appendString:lineText];
    }
    NSLog(@"%@", stringResult);
}

@end
