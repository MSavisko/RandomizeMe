//
//  Dice.h
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dice : NSObject
@property (readonly, nonatomic) NSInteger number;
@property (readonly, strong, nonatomic) NSString *name;
@property (readonly, strong, nonatomic) NSString *imageName;
@property (readonly, strong, nonatomic) NSString *smallImageName;

- (instancetype) initWithName:(NSString*)name number:(NSInteger)number imageName:(NSString*)imageName smallImageName:(NSString*)smallImageName;

@end
