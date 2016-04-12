//
//  MSDecimalResultVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/8/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSDecimalResultVC.h"
#import "SWRevealViewController.h"

@interface MSDecimalResultVC ()
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *copyingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end

@implementation MSDecimalResultVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self.trashButton setEnabled:NO];
    [self.trashButton setTintColor:[UIColor clearColor]];
    self.resultTextView.text = [self stringResultWithNumber:self.decimalPlaces];
    self.timestampLabel.text = [self stringComplitionTime];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar]; //Because when back from second view, pan guesture menu not work
}

- (void)viewDidLayoutSubviews {
    [self.resultTextView setContentOffset:CGPointZero animated:NO]; //Because position of text view must be Zero
}

#pragma mark - Setup Methods
- (void) setupMenuBar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

#pragma mark - IBAction

#pragma mark - Keyboard Methods
- (void) hideKeyboardByTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Presentation Data Method
- (NSString*) stringResultWithNumber: (NSInteger)number {
    NSMutableString *mutableResult = [[NSMutableString alloc]init];
    for (NSInteger i=0; i < self.response.data.count; i++) {
        NSNumber *elementNumber = self.response.data[i];
        
        //Rounding, because of some double much longer than other
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:number];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        NSString *numberString = [formatter stringFromNumber:elementNumber];
        
        //Appending, because we need space between result number
        [mutableResult appendString:[NSString stringWithFormat:@"%@ ", numberString]];
    }
    return mutableResult;
}

- (NSString*) stringComplitionTime {
    return [self.response.completionTime substringToIndex:self.response.completionTime.length-1];
}


@end
