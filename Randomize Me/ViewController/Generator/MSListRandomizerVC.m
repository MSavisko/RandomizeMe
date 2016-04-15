    //
//  MSListRandomizerVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/15/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSListRandomizerVC.h"
#import "SWRevealViewController.h"
#import "MSRandomIntegerRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "MBProgressHUD.h"


@interface MSListRandomizerVC () <UITextViewDelegate, MSHTTPClientDelegate, SWRevealViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
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
    //[self testSample];
    //[self textViewSample];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
}


#pragma mark - IBAction
- (IBAction)doneButtonPressed:(id)sender {
    [self dismissKeyboard];
    [self.textView setContentOffset:CGPointZero animated:NO];
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

#pragma mark - SWRevealViewController Delegate
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionRight) {
        self.textView.editable = NO;
    }
    else {
        self.textView.editable = YES;
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Enter your items in the field below, each on a separate line.\nItems can be numbers, names, email addresses, etc. A maximum of 10,000 items are allowed."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Enter your items in the field below, each on a separate line.\nItems can be numbers, names, email addresses, etc. A maximum of 10,000 items are allowed.";
        textView.textColor = [UIColor lightGrayColor];
    }
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
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    self.textView.contentInset = UIEdgeInsetsZero;
    self.textView.scrollIndicatorInsets = UIEdgeInsetsZero;
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




- (void) textViewSample {
    NSString *textFieldText = [NSString stringWithFormat:@"First \nSecond\nThird\nFourth\nFifth"];
    NSArray *lines = [textFieldText componentsSeparatedByString:@"\n"];
    NSLog(@"%@", lines);
}

- (void) testSample {
    NSArray *listArray = @[@"Ivanov", @"Petrov", @"Sidorov", @"Petrov2", @"Ivanov2", @"Shevchenko", @"Ivanov3", @"Sidorov4"];
    
    NSMutableArray *dictArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < listArray.count; i++) {
        NSString *currentPosition = [NSString stringWithFormat:@"%ld", (long)i];
        NSString *text = [NSString stringWithFormat:@"%@", listArray[i]];
        
        
        NSMutableDictionary *line = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"current_position" : currentPosition,
                                                                                    @"text" : text,
                                                                                    @"new_position" : @"0"
                                                                                    }];
        
        [dictArray addObject:line];
    }
    
    NSArray *data = @[@8, @6, @3, @5, @4, @1, @7, @2];
    
    for (int i = 0; i < listArray.count; i++) {
        NSString *newPosition = [NSString stringWithFormat:@"%@", data[i]];
        dictArray[i][@"new_position"] = newPosition;
    }
    
    NSSortDescriptor *newPositionDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"new_position" ascending:YES];
    
    NSArray *descriptors = @[newPositionDescriptor];
    
    [dictArray sortUsingDescriptors:descriptors];
    
    NSMutableString * stringResult = [[NSMutableString alloc]init];
    for (int i = 0; i < dictArray.count; i++) {
        NSString *number = [NSString stringWithFormat:@"%d. ", i + 1];
        NSString *lineText = [NSString stringWithFormat:@"%@\n", dictArray[i][@"text"]];
        [stringResult appendString:number];
        [stringResult appendString:lineText];
    }
    NSLog(@"%@", stringResult);
}

@end
