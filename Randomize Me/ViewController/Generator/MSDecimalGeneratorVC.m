//
//  MSDecimalGeneratorVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/6/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSDecimalGeneratorVC.h"
#import "SWRevealViewController.h"

@interface MSDecimalGeneratorVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;
@property (weak, nonatomic) IBOutlet UITextField *numberOfDecimals;
@property (weak, nonatomic) IBOutlet UITextField *decimalPlaces;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation MSDecimalGeneratorVC

static int MSGenerateButtonHeight = 30;

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setupMenuBar];
    [self setTextFieldDelegate];
    [self setKeyboardNotification];
}

#pragma mark - IBAction
- (IBAction)generateButtonPressed:(UIButton *)sender {
    [self dismissKeyboard];
    NSLog(@"Decimal Generator Button Pressed!");
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    self.numberOfDecimals.text = @"";
    self.decimalPlaces.text = @"";
}



#pragma mark - UITextFiled Delegate
- (void)textFieldDidBeginEditing:(UITextField *)sender {
    self.activeField = sender;
}

- (void)textFieldDidEndEditing:(UITextField *)sender {
    self.activeField = nil;
}

#pragma mark - Keyboard Methods
-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height + MSGenerateButtonHeight, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Setup Methods
- (void) hideKeyboardByTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void) setupMenuBar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.menuButtonItem setTarget: self.revealViewController];
        [self.menuButtonItem setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

- (void) setTextFieldDelegate {
    self.numberOfDecimals.delegate = self;
    self.decimalPlaces.delegate = self;
}

- (void) setKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

@end
