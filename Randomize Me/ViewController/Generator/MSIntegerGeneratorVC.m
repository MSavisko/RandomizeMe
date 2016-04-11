//
//  MSIntegerGeneratorVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/27/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSIntegerGeneratorVC.h"
#import "MSIntegerResultVC.h"
#import "SWRevealViewController.h"
#import "MSRandomIntegerRequest.h"

#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "MBProgressHUD.h"

#import "MSRandomIntegerRequest.h"

@interface MSIntegerGeneratorVC () <UITextFieldDelegate, MSHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;
@property (weak, nonatomic) IBOutlet UITextField *numberOfIntegers;
@property (weak, nonatomic) IBOutlet UITextField *minValue;
@property (weak, nonatomic) IBOutlet UITextField *maxValue;
@property (weak, nonatomic) IBOutlet UISwitch *replacementSwitch;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (weak, nonatomic) UITextField *activeField;
@property (strong, nonnull) MSRandomIntegerRequest *request;
@property (strong, nonatomic) MSRandomResponse *response;
@end

@implementation MSIntegerGeneratorVC

static int MSGenerateButtonHeight = 40;

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setTextFieldDelegate];
    [self setKeyboardNotification];
    [self.generateButton setEnabled:NO];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar]; //Because when back from second view, pan guesture menu not work
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MSIntegerResultVC *resultVC = segue.destinationViewController;
    resultVC.response = self.response;
}

#pragma mark - IBAction
- (IBAction) generateButtonPressed:(id)sender {
    //Test new Model
//    MSRandomIntegerRequest *newRequest = [[MSRandomIntegerRequest alloc] initWithCount:10 min:1 max:10 unique:YES];
//    [newRequest setReplacement:YES];
//    NSLog(@"New Request Body: %hhd", newRequest.replacement);
    
    [self dismissKeyboard];
    self.request = [[MSRandomIntegerRequest alloc]initWithCount:[self.numberOfIntegers.text intValue] min:[self.minValue.text intValue] max:[self.maxValue.text intValue] unique:YES];
    if (self.replacementSwitch.isOn) {
        [self.request setReplacement:NO];
    };
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequestToRandomOrgWithParameters:[self.request requestBody]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (IBAction)clearButtonPressed:(id)sender {
    self.numberOfIntegers.text = @"";
    self.minValue.text = @"";
    self.maxValue.text = @"";
    [self.replacementSwitch setOn:NO animated:YES];
}
- (IBAction)infoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Integer Generation"
                                                    message:@"This form allows you to generate random integers. The randomness comes from atmospheric noise, which for many purposes is better than the pseudo-random number algorithms typically used in computer programs."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)editingChanged {
    if ([self.numberOfIntegers.text length] != 0 && [self.minValue.text length] != 0 && [self.maxValue.text length] != 0) {
        [self.generateButton setEnabled:YES];
    }
    else {
        [self.generateButton setEnabled:NO];
    }
}

#pragma mark - MSHTTPClient Delegate
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.response = [[MSRandomResponse alloc]init];
    [self.response parseResponseFromData:responseObject];
    if (!self.response.error) {
        [self performSegueWithIdentifier:@"ShowIntegerResult" sender:nil];
    } else {
        [self showAlertWithMessage:[self.response parseError]];
    }
}

- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSLog(@"%@", error);
}

#pragma mark - UITextFiled Delegate
- (void)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
}

- (void)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
    {
        return YES;
    }
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                            message:@"This field accepts only numeric entries!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    
    NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.activeField == self.numberOfIntegers) {
        if (updatedText.length > 5)
        {
            if (string.length > 1)
            {
                [self showAlertForTextFieldWithNumber:5];
            }
            [self showAlertForTextFieldWithNumber:5];
            return NO;
        }
    } else {
        if (updatedText.length > 10)
        {
            if (string.length > 1)
            {
                [self showAlertForTextFieldWithNumber:10];
            }
            [self showAlertForTextFieldWithNumber:10];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Keyboard Methods
-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height + MSGenerateButtonHeight, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbRect.size.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
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
    self.numberOfIntegers.delegate = self;
    self.minValue.delegate = self;
    self.maxValue.delegate = self;
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

#pragma mark - Helper Methods
- (void) showAlertForTextFieldWithNumber:(NSInteger)number {
    NSString *message = [NSString stringWithFormat:@"This field accepts a maximum of %d numbers!", number];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) showAlertWithMessage:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
