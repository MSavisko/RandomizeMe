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

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setupMenuBar];
    
    [self setTextFieldDelegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - IBAction
- (IBAction)generateButtonPressed:(UIButton *)sender {
    NSLog(@"Decimal Generator Button Pressed!");
}
- (IBAction)menuButtonPressed:(UIBarButtonItem *)sender {
    [self dismissKeyboard];
}

#pragma mark - UITextFiled Delegate
- (IBAction)textFieldDidBeginEditing:(UITextField *)sender
{
    self.activeField = sender;
}

- (IBAction)textFieldDidEndEditing:(UITextField *)sender
{
    self.activeField = nil;
}

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

- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // If you are using Xcode 6 or iOS 7.0, you may need this line of code. There was a bug when you
    // rotated the device to landscape. It reported the keyboard as the wrong size as if it was still in portrait mode.
    //kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height + 30, 0.0);
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

#pragma mark - Helper Methods
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

@end
