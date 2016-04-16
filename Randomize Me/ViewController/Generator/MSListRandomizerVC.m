    //
//  MSListRandomizerVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSListRandomizerVC.h"
#import "MSListResultVC.h"
#import "SWRevealViewController.h"
#import "MSRandomIntegerRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "MBProgressHUD.h"


@interface MSListRandomizerVC () <UITextViewDelegate, MSHTTPClientDelegate, SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *randomizeButton;

@property (strong, nonnull) MSRandomIntegerRequest *request;
@property (strong, nonatomic) MSRandomResponse *response;

@end

@implementation MSListRandomizerVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setKeyboardNotification];
    [self setTextView];
    [self.doneButton setEnabled:NO];
    [self.clearButton setEnabled:NO];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MSListResultVC *resultVC = segue.destinationViewController;
    resultVC.response = self.response;
    resultVC.list = [self.textView.text componentsSeparatedByString:@"\n"];
}

#pragma mark - IBAction
- (IBAction)randomizeButtonPressed:(id)sender {
    NSArray *lines = [self.textView.text componentsSeparatedByString:@"\n"];
    if ([self checkTextFIeld]) {
        [self randomizeWithList:lines];
    }
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissKeyboard];
    [self.textView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    self.textView.text = @"Enter your items in the field below, each on a separate line.\nItems can be numbers, names, email addresses, etc. A maximum of 10,000 items are allowed.";
    self.textView.textColor = [UIColor lightGrayColor];
    [self.clearButton setEnabled:NO];
}

- (IBAction)infoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"List Randomizer"
                                                    message:@"This form allows you to arrange the items of a list in random order. The randomness comes from atmospheric noise, which for many purposes is better than the pseudo-random number algorithms typically used in computer programs."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
    revealViewController.delegate = self;
    if (revealViewController)
    {
        [self.menuButtonItem setTarget: self.revealViewController];
        [self.menuButtonItem setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
}

- (void) setTextView {
    self.textView.delegate = self;
    self.textView.text = @"Enter your items in the field below, each on a separate line.\nItems can be numbers, names, email addresses, etc. A maximum of 10,000 items are allowed.";
    self.textView.textColor = [UIColor lightGrayColor];
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

#pragma mark - SWRevealViewController Delegate
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionRight) {
        self.textView.editable = NO;
    }
    else {
        self.textView.editable = YES;
    }
}

#pragma mark - MSHTTPClient Delegate
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.response = [[MSRandomResponse alloc]init];
    [self.response parseResponseFromData:responseObject];
    if (!self.response.error) {
        [self performSegueWithIdentifier:@"ShowListResult" sender:nil];
    } else {
        [self showAlertWithMessage:[self.response parseError]];
    }
}

- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showAlertWithMessage:@"Could not connect to the generation server. Please check your Internet connection or try later!"];
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Enter your items in the field below, each on a separate line.\nItems can be numbers, names, email addresses, etc. A maximum of 10,000 items are allowed."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        [self.clearButton setEnabled:NO];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Enter your items in the field below, each on a separate line.\nItems can be numbers, names, email addresses, etc. A maximum of 10,000 items are allowed.";
        textView.textColor = [UIColor lightGrayColor];
        [self.clearButton setEnabled:NO];
    }
    [self.clearButton setEnabled:YES];
    [textView resignFirstResponder];
}

#pragma mark - Keyboard Methods
-(void) dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.textView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.textView.scrollIndicatorInsets = self.textView.contentInset;
    [self.doneButton setEnabled:YES];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [self.doneButton setEnabled:NO];
}

#pragma mark - Helper Methods
- (void) showAlertWithMessage:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning!"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) randomizeWithList:(NSArray*)list {
    self.request = [[MSRandomIntegerRequest alloc]initWithCount:list.count min:1 max:list.count unique:YES];
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequest:[self.request requestBody]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (BOOL) checkTextFIeld {
    NSArray *lines = [self.textView.text componentsSeparatedByString:@"\n"];
    if ([lines.lastObject isEqualToString:@""]) {
        if (lines.count - 1 < 2) {
            [self showAlertWithMessage:@"Your list must contain at least two items!"];
            return NO;
        }
    }
    else if (lines.count < 2) {
        [self showAlertWithMessage:@"Your list must contain at least two items!"];
        return NO;
    }
    else if (lines.count > 9999) {
        [self showAlertWithMessage:@"Your list must contain at less than 10000 items!"];
        return NO;
    }
    else if ([self.textView.text isEqualToString:@"Enter your items in the field below, each on a separate line.\nItems can be numbers, names, email addresses, etc. A maximum of 10,000 items are allowed."]) {
        [self showAlertWithMessage:@"Your list must contain at least two items!"];
        return NO;
    }
    return YES;
}

@end
