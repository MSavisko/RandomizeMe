//
//  MSDecimalGeneratorVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/6/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSDecimalGeneratorVC.h"
#import "MSDecimalResultVC.h"
#import "SWRevealViewController.h"
#import "MSRandomDecimalRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "MBProgressHUD.h"

@interface MSDecimalGeneratorVC () <UITextFieldDelegate, MSHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;
@property (weak, nonatomic) IBOutlet UITextField *numberOfDecimals;
@property (weak, nonatomic) IBOutlet UITextField *decimalPlaces;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) MSRandomDecimalRequest *request;
@property (strong, nonatomic) MSRandomResponse *response;
@end

@implementation MSDecimalGeneratorVC

static int MSGenerateButtonHeight = 30;

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setTextFieldDelegate];
    [self setKeyboardNotification];
    [self.generateButton setEnabled:NO];
    [self.clearButton setEnabled:NO];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MSDecimalResultVC *resultVC = segue.destinationViewController;
    resultVC.response = self.response;
    resultVC.decimalPlaces = self.request.decimalPlaces;
}

#pragma mark - IBAction
- (IBAction)generateButtonPressed:(id)sender {
    [self dismissKeyboard];
    self.request = [[MSRandomDecimalRequest alloc]initWithCount:[self.numberOfDecimals.text intValue] andDecimalPlaces:[self.decimalPlaces.text intValue]];
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequest: [self.request requestBody]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    self.numberOfDecimals.text = @"";
    self.decimalPlaces.text = @"";
    [self.generateButton setEnabled:NO];
    [self.clearButton setEnabled:NO];
}

- (IBAction)infoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Decimal Generator"
                                                    message:@"This form allows you to generate random decimal fractions in the [0,1] interval. The randomness comes from atmospheric noise, which for many purposes is better than the pseudo-random number algorithms typically used in computer programs."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)editingChanged {
    if ([self.numberOfDecimals.text length] != 0 && [self.decimalPlaces.text length] != 0) {
        [self.generateButton setEnabled:YES];
    }
    else {
        [self.generateButton setEnabled:NO];
    }
}

- (IBAction)clearButtonActive:(id)sender {
    if ([self.numberOfDecimals.text length] != 0 || [self.decimalPlaces.text length] != 0) {
        [self.clearButton setEnabled:YES];
    }
    else {
        [self.clearButton setEnabled:NO];
    }
}

#pragma mark - MSHTTPClientDelegate
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.response = [[MSRandomResponse alloc]init];
    [self.response parseResponseFromData:responseObject];
    if (!self.response.error) {
        [self performSegueWithIdentifier:@"ShowDecimalResult" sender:nil];
    } else {
        [self showAlertWithMessage:[self.response parseError]];
    }
}

- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showAlertWithMessage:@"Could not connect to the generation server. Please check your Internet connection or try later!"];
}


#pragma mark - UITextFiledDelegate
- (void)textFieldDidBeginEditing:(UITextField *)sender {
    self.activeField = sender;
}

- (void)textFieldDidEndEditing:(UITextField *)sender {
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
            [self showAlertWithMessage:@"This field accepts only numeric entries!"];
            return NO;
        }
    }
    
    NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.activeField == self.numberOfDecimals) {
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
        if (updatedText.length > 2)
        {
            if (string.length > 1)
            {
                [self showAlertForTextFieldWithNumber:2];
            }
            [self showAlertForTextFieldWithNumber:2];
            return NO;
        }
    }
    return YES;
}

#pragma mark - KeyboardMethods
-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
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

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - SetupMethods
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

#pragma mark - HelperMethods
- (void) showAlertForTextFieldWithNumber:(NSInteger)number {
    NSString *message = [NSString stringWithFormat:@"This field accepts a maximum of %ld numbers!", (long)number];
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
