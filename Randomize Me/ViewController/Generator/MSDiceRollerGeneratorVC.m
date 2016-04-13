//
//  MSDiceRollerGeneratorVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/13/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSDiceRollerGeneratorVC.h"
#import "MSDiceRollerResultVC.h"
#import "SWRevealViewController.h"
#import "MSRandomIntegerRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "MBProgressHUD.h"

@interface MSDiceRollerGeneratorVC () <UITextFieldDelegate, MSHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UITextField *numberOfDice;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIButton *rollDiceButton;
@property (strong, nonatomic) MSRandomIntegerRequest *request;
@property (strong, nonatomic) MSRandomResponse *response;
@end

@implementation MSDiceRollerGeneratorVC

static int MSRollButtonHeight = 30;

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setTextFieldDelegate];
    [self setKeyboardNotification];
    [self.rollDiceButton setEnabled:NO];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
    self.numberOfDice.text = @"";
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MSDiceRollerResultVC *resultVC = segue.destinationViewController;
    resultVC.response = self.response;
}

#pragma mark - IBAction
- (IBAction) rollDiceButtonPressed:(id)sender {
    if ([self.numberOfDice.text intValue] > 6 || [self.numberOfDice.text intValue] == 0) {
        self.numberOfDice.text = @"";
        [self showAlertWithMessage:@"Number of dice must be GREATER than 0 and LESS than 7!"];
        [self.numberOfDice becomeFirstResponder];
    } else {
        [self dismissKeyboard];
        [self roll];
    }
}

- (IBAction)clearButtonPressed:(id)sender {
    self.numberOfDice.text = @"";
    [self.rollDiceButton setEnabled:NO];
}

- (IBAction)infoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dice Roller"
                                                    message:@"This form allows you to roll virtual dice. The randomness comes from atmospheric noise, which for many purposes is better than the pseudo-random number algorithms typically used in computer programs."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)editingChanged {
    if ([self.numberOfDice.text length] != 0) {
        [self.rollDiceButton setEnabled:YES];
    }
    else {
        [self.rollDiceButton setEnabled:NO];
    }
}

#pragma mark - MSHTTPClient Delegate
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.response = [[MSRandomResponse alloc]init];
    [self.response parseResponseFromData:responseObject];
    if (!self.response.error) {
        [self performSegueWithIdentifier:@"ShowDiceRollerResult" sender:nil];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!string.length) {
        return YES;
    }
    
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound) {
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
    
    if (updatedText.length > 1) {
        [self showAlertForTextFieldWithNumber:1];
        return NO;
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height + MSRollButtonHeight, 0.0);
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
    self.numberOfDice.delegate = self;

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

- (void) roll {
    self.request = [[MSRandomIntegerRequest alloc]initWithCount:[self.numberOfDice.text intValue] min:1 max:6 unique:NO];
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequest:[self.request requestBody]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


@end
