//
//  MSStringsGeneratorVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/12/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSStringsGeneratorVC.h"
#import "MSStringsResultVC.h"
#import "SWRevealViewController.h"
#import "MSRandomStringsRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "MBProgressHUD.h"

@interface MSStringsGeneratorVC () <UITextFieldDelegate, MSHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UITextField *numberOfStrings;
@property (weak, nonatomic) IBOutlet UITextField *charactersLength;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UISwitch *digitsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *uppercaseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lowercaseSwitch;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;
@property (strong, nonatomic) MSRandomStringsRequest *request;
@property (strong, nonatomic) MSRandomResponse *response;

@end

@implementation MSStringsGeneratorVC

static int MSGenerateButtonHeight = 27;

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
    MSStringsResultVC *resultVC = segue.destinationViewController;
    resultVC.response = self.response;
}

#pragma mark - IBAction
- (IBAction)generateButtonPressed:(id)sender {
    [self dismissKeyboard];
    if ([self allowedCharacters].length == 0) {
        [self showAlertWithMessage:@"All switch parameters are OFF. Please, switch ON one or more characters parameters."];
    } else {
        self.request = [[MSRandomStringsRequest alloc]initWithCount:[self.numberOfStrings.text intValue] length:[self.charactersLength.text integerValue] forCharacters:[self allowedCharacters] unique:NO];
        MSHTTPClient *client = [MSHTTPClient sharedClient];
        [client setDelegate:self];
        [client sendRequestToRandomOrgWithParameters: [self.request requestBody]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    self.numberOfStrings.text = @"";
    self.charactersLength.text = @"";
    [self.digitsSwitch setOn:YES animated:YES];
    [self.lowercaseSwitch setOn:NO animated:YES];
    [self.uppercaseSwitch setOn:NO animated:YES];
}

- (IBAction)infoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Strings Generator"
                                                    message:@"This form allows you to generate random text strings. The randomness comes from atmospheric noise, which for many purposes is better than the pseudo-random number algorithms typically used in computer programs."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)editingChanged {
    if ([self.numberOfStrings.text length] != 0 && [self.charactersLength.text length] != 0) {
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
        [self performSegueWithIdentifier:@"ShowStringsResult" sender:nil];
        NSLog(@"Result: %@", self.response.data);
    } else {
        [self showAlertWithMessage:[self.response parseError]];
    }
}

- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showAlertWithMessage:@"Could not connect to the generation server. Please check your Internet connection or try later!"];
}

#pragma mark - UITextFiled Delegate
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
    
    if (self.activeField == self.numberOfStrings) {
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

#pragma mark - Keyboard Methods
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
    self.numberOfStrings.delegate = self;
    self.charactersLength.delegate = self;
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

- (NSString*) allowedCharacters {
    NSMutableString *characters = [NSMutableString stringWithFormat:@""];
    if (self.uppercaseSwitch.isOn) {
        [characters appendString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    }
    if (self.lowercaseSwitch.isOn) {
        [characters appendString:@"abcdefghijklmnopqrstuvwxyz"];
    }
    if (self.digitsSwitch.isOn) {
        [characters appendString:@"0123456789"];
    }
    return characters;
}

@end
