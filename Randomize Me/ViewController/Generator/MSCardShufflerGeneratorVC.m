//
//  MSCardShuffler.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/14/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSCardShufflerGeneratorVC.h"
#import "MSCardShufflerResultVC.h"
#import "SWRevealViewController.h"
#import "MSRandomStringsRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "MBProgressHUD.h"

@interface MSCardShufflerGeneratorVC () <UITextFieldDelegate, MSHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UISwitch *spadesSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *heartsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *diamondsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *clubsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *jokersSwitch;
@property (weak, nonatomic) IBOutlet UITextField *numberOfDecks;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
@property (strong, nonatomic) MSRandomStringsRequest *request;
@property (strong, nonatomic) MSRandomResponse *response;

@end

@implementation MSCardShufflerGeneratorVC

static int MSGenerateButtonHeight = 30;

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self hideKeyboardByTap];
    [self setTextFieldDelegate];
    [self setKeyboardNotification];
    [self.drawButton setEnabled:NO];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MSCardShufflerResultVC *resultVC = segue.destinationViewController;
    resultVC.response = self.response;
}

#pragma mark - IBAction
- (IBAction)generateButtonPressed:(id)sender {
    [self dismissKeyboard];
    if ([self allowedCharacters].length == 0) {
        [self showAlertWithMessage:@"All switch parameters are OFF. Please, switch ON one or more characters parameters."];
    } else {
        [self drawCard];
    }
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
    self.numberOfDecks.delegate = self;
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

#pragma mark - Alert Methods
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

#pragma mark - Helper Methods
- (NSString*) allowedCharacters {
    NSMutableString *characters = [NSMutableString stringWithFormat:@""];
    if (self.spadesSwitch.isOn) {
        [characters appendString:@"abcdefghijklm"];
    }
    if (self.heartsSwitch.isOn) {
        [characters appendString:@"nopqrstuvwxyz"];
    }
    if (self.diamondsSwitch.isOn) {
        [characters appendString:@"123456789ABCD"];
    }
    if (self.clubsSwitch.isOn) {
        [characters appendString:@"EFGHIJKLMNOPQ"];
    }
    if (self.clubsSwitch.isOn) {
        [characters appendString:@"RS"];
    }
    return characters;
}

- (void) drawCard {
    self.request = [[MSRandomStringsRequest alloc]initWithCount:1 length:1 forCharacters:[self allowedCharacters] unique:NO];
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequest: [self.request requestBody]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (NSArray*) imageNameFromResult:(NSString*)result {
    NSMutableArray *card = [[NSMutableArray alloc]init];
    
    //Spades
    if ([result isEqualToString:@"a"]) {
        [card addObjectsFromArray:@[@"2_of_spades", @"Two of Spades"]];
    }
    else if ([result isEqualToString:@"b"]) {
        [card addObjectsFromArray:@[@"3_of_spades", @"Three of Spades"]];
    }
    else if ([result isEqualToString:@"c"]) {
        [card addObjectsFromArray:@[@"4_of_spades", @"Four of Spades"]];
    }
    else if ([result isEqualToString:@"d"]) {
        [card addObjectsFromArray:@[@"5_of_spades", @"Five of Spades"]];
    }
    else if ([result isEqualToString:@"e"]) {
        [card addObjectsFromArray:@[@"6_of_spades", @"Six of Spades"]];
    }
    else if ([result isEqualToString:@"f"]) {
        [card addObjectsFromArray:@[@"7_of_spades", @"Seven of Spades"]];
    }
    else if ([result isEqualToString:@"g"]) {
        [card addObjectsFromArray:@[@"8_of_spades", @"Eight of Spades"]];
    }
    else if ([result isEqualToString:@"h"]) {
        [card addObjectsFromArray:@[@"9_of_spades", @"Nine of Spades"]];
    }
    else if ([result isEqualToString:@"i"]) {
        [card addObjectsFromArray:@[@"10_of_spades", @"Ten of Spades"]];
    }
    else if ([result isEqualToString:@"j"]) {
        [card addObjectsFromArray:@[@"ace_of_spades", @"Ace of Spades"]];
    }
    else if ([result isEqualToString:@"k"]) {
        [card addObjectsFromArray:@[@"jack_of_spades", @"Jack of Spades"]];
    }
    else if ([result isEqualToString:@"l"]) {
        [card addObjectsFromArray:@[@"king_of_spades", @"King of Spades"]];
    }
    else if ([result isEqualToString:@"m"]) {
        [card addObjectsFromArray:@[@"queen_of_spades", @"Queen of Spades"]];
    }
    
    //Hearts
    else if ([result isEqualToString:@"n"]) {
        [card addObjectsFromArray:@[@"2_of_hearts", @"Two of Hearts"]];
    }
    else if ([result isEqualToString:@"o"]) {
        [card addObjectsFromArray:@[@"3_of_hearts", @"Three of Hearts"]];
    }
    else if ([result isEqualToString:@"p"]) {
        [card addObjectsFromArray:@[@"4_of_hearts", @"Four of Hearts"]];
    }
    else if ([result isEqualToString:@"q"]) {
        [card addObjectsFromArray:@[@"5_of_hearts", @"Five of Hearts"]];
    }
    else if ([result isEqualToString:@"r"]) {
        [card addObjectsFromArray:@[@"6_of_hearts", @"Six of Hearts"]];
    }
    else if ([result isEqualToString:@"s"]) {
        [card addObjectsFromArray:@[@"7_of_hearts", @"Seven of Hearts"]];
    }
    else if ([result isEqualToString:@"t"]) {
        [card addObjectsFromArray:@[@"8_of_hearts", @"Eight of Hearts"]];
    }
    else if ([result isEqualToString:@"u"]) {
        [card addObjectsFromArray:@[@"9_of_hearts", @"Nine of Hearts"]];
    }
    else if ([result isEqualToString:@"v"]) {
        [card addObjectsFromArray:@[@"10_of_hearts", @"Ten of Hearts"]];
    }
    else if ([result isEqualToString:@"w"]) {
        [card addObjectsFromArray:@[@"ace_of_hearts", @"Ace of Hearts"]];
    }
    else if ([result isEqualToString:@"x"]) {
        [card addObjectsFromArray:@[@"jack_of_hearts", @"Jack of Hearts"]];
    }
    else if ([result isEqualToString:@"y"]) {
        [card addObjectsFromArray:@[@"king_of_hearts", @"King of Hearts"]];
    }
    else if ([result isEqualToString:@"z"]) {
        [card addObjectsFromArray:@[@"queen_of_hearts", @"Queen of Hearts"]];
    }
    
    //Diamonds
    else if ([result isEqualToString:@"1"]) {
        [card addObjectsFromArray:@[@"2_of_diamonds", @"Two of Diamonds"]];
    }
    else if ([result isEqualToString:@"2"]) {
        [card addObjectsFromArray:@[@"3_of_diamonds", @"Three of Diamonds"]];
    }
    else if ([result isEqualToString:@"3"]) {
        [card addObjectsFromArray:@[@"4_of_diamonds", @"Four of Diamonds"]];
    }
    else if ([result isEqualToString:@"4"]) {
        [card addObjectsFromArray:@[@"5_of_diamonds", @"Five of Diamonds"]];
    }
    else if ([result isEqualToString:@"5"]) {
        [card addObjectsFromArray:@[@"6_of_diamonds", @"Six of Diamonds"]];
    }
    else if ([result isEqualToString:@"6"]) {
        [card addObjectsFromArray:@[@"7_of_diamonds", @"Seven of Diamonds"]];
    }
    else if ([result isEqualToString:@"7"]) {
        [card addObjectsFromArray:@[@"8_of_diamonds", @"Eight of Diamonds"]];
    }
    else if ([result isEqualToString:@"8"]) {
        [card addObjectsFromArray:@[@"9_of_diamonds", @"Nine of Diamonds"]];
    }
    else if ([result isEqualToString:@"9"]) {
        [card addObjectsFromArray:@[@"10_of_diamonds", @"Ten of Diamonds"]];
    }
    else if ([result isEqualToString:@"A"]) {
        [card addObjectsFromArray:@[@"ace_of_diamonds", @"Ace of Diamonds"]];
    }
    else if ([result isEqualToString:@"B"]) {
        [card addObjectsFromArray:@[@"jack_of_diamonds", @"Jack of Diamonds"]];
    }
    else if ([result isEqualToString:@"C"]) {
        [card addObjectsFromArray:@[@"king_of_diamonds", @"King of Diamonds"]];
    }
    else if ([result isEqualToString:@"D"]) {
        [card addObjectsFromArray:@[@"queen_of_diamonds", @"Queen of Diamonds"]];
    }
    
    //Clubs
    else if ([result isEqualToString:@"E"]) {
        [card addObjectsFromArray:@[@"2_of_clubs", @"Two of Clubs"]];
    }
    else if ([result isEqualToString:@"F"]) {
        [card addObjectsFromArray:@[@"3_of_clubs", @"Three of Clubs"]];
    }
    else if ([result isEqualToString:@"G"]) {
        [card addObjectsFromArray:@[@"4_of_clubs", @"Four of Clubs"]];
    }
    else if ([result isEqualToString:@"H"]) {
        [card addObjectsFromArray:@[@"5_of_clubs", @"Five of Clubs"]];
    }
    else if ([result isEqualToString:@"I"]) {
        [card addObjectsFromArray:@[@"6_of_clubs", @"Six of Clubs"]];
    }
    else if ([result isEqualToString:@"J"]) {
        [card addObjectsFromArray:@[@"7_of_clubs", @"Seven of Clubs"]];
    }
    else if ([result isEqualToString:@"K"]) {
        [card addObjectsFromArray:@[@"8_of_clubs", @"Eight of Clubs"]];
    }
    else if ([result isEqualToString:@"L"]) {
        [card addObjectsFromArray:@[@"9_of_clubs", @"Nine of Clubs"]];
    }
    else if ([result isEqualToString:@"M"]) {
        [card addObjectsFromArray:@[@"10_of_clubs", @"Ten of Clubs"]];
    }
    else if ([result isEqualToString:@"N"]) {
        [card addObjectsFromArray:@[@"ace_of_clubs", @"Ace of Clubs"]];
    }
    else if ([result isEqualToString:@"O"]) {
        [card addObjectsFromArray:@[@"jack_of_clubs", @"Jack of Clubs"]];
    }
    else if ([result isEqualToString:@"P"]) {
        [card addObjectsFromArray:@[@"king_of_clubs", @"King of Clubs"]];
    }
    else if ([result isEqualToString:@"Q"]) {
        [card addObjectsFromArray:@[@"queen_of_clubs", @"Queen of Clubs"]];
    }
    
    //Jokers
    else if ([result isEqualToString:@"R"]) {
        [card addObjectsFromArray:@[@"black_joker", @"Black Joker"]];
    }
    else if ([result isEqualToString:@"S"]) {
        [card addObjectsFromArray:@[@"red_joker", @"Red Joker"]];
    }
    return card;
}



@end
