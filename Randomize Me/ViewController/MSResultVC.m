//
//  MSRandomNumberResultVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/2/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSResultVC.h"

@interface MSResultVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@end

@implementation MSResultVC

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultTextView.text = [self.response makeStringFromData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - Helper Methods
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

@end
