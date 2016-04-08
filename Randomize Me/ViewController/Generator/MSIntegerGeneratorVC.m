//
//  MSRandomNumberVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 3/27/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSIntegerGeneratorVC.h"
#import "MSIntegerResultVC.h"
#import "SWRevealViewController.h"
#import "MSIntegerRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"


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
@property (strong, nonatomic) MSIntegerRequest *integerRequest;
@property (strong, nonatomic) MSRandomResponse *response;
@end

@implementation MSIntegerGeneratorVC

static int MSGenerateButtonHeight = 40;

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setupMenuBar];
    [self setTextFieldDelegate];
    [self setKeyboardNotification];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MSIntegerResultVC *resultVC = segue.destinationViewController;
    resultVC.response = self.response;
}

#pragma mark - IBAction
- (IBAction) generateButtonPressed:(id)sender {
    [self dismissKeyboard];
    self.integerRequest = [[MSIntegerRequest alloc]initWithNumberOfIntegers:[self.numberOfIntegers.text intValue] minBoundaryValue:[self.minValue.text intValue] maxBoundaryValue:[self.maxValue.text intValue] andReplacement:YES forBase:10];
    if (self.replacementSwitch.isOn) {
        [self.integerRequest setReplacement:NO];
    };
    NSLog(@"Request Body: %@", [self.integerRequest makeRequestBody]);
    
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequestWithParameters:[self.integerRequest makeRequestBody]];
}
- (IBAction)clearButton:(id)sender {
    self.numberOfIntegers.text = @"";
    self.minValue.text = @"";
    self.maxValue.text = @"";
    [self.replacementSwitch setOn:NO animated:YES];
}

#pragma mark - MSHTTPClient Delegate
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    self.response = [[MSRandomResponse alloc]init];
    [self.response parseResponseFromData:responseObject];
    if (!self.response.error) {
        NSLog(@"Response data: %@", self.response.data);
        [self performSegueWithIdentifier:@"ShowIntegerResult" sender:nil];
    } else {
        NSLog(@"Error exist. %@", [self.response parseError]);
    }
}

- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
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

@end
