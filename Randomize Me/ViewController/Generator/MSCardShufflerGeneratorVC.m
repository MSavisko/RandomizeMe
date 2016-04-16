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

@interface MSCardShufflerGeneratorVC () <MSHTTPClientDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (weak, nonatomic) IBOutlet UISwitch *spadesSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *heartsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *diamondsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *clubsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *jokersSwitch;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIButton *drawButton;
@property (strong, nonatomic) MSRandomStringsRequest *request;
@property (strong, nonatomic) MSRandomResponse *response;

@end

@implementation MSCardShufflerGeneratorVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    [self.clearButton setEnabled:NO];
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
- (IBAction) drawButtonPressed:(id)sender {
    if ([self allowedCharacters].length == 0) {
        [self showAlertWithMessage:@"All switch parameters are OFF. Please, switch ON one or more Cards parameters."];
    } else {
        [self drawCard];
    }
}

- (IBAction)clearButtonPressed:(UIBarButtonItem *)sender {
    [self.spadesSwitch setOn:YES animated:YES];
    [self.heartsSwitch setOn:YES animated:YES];
    [self.diamondsSwitch setOn:YES animated:YES];
    [self.clubsSwitch setOn:YES animated:YES];
    [self.jokersSwitch setOn:NO animated:YES];
    [self.clearButton setEnabled:NO];
}

- (IBAction)infoButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Strings Generator"
                                                    message:@"This form allows you to draw playing cards from randomly shuffled decks. The randomness comes from atmospheric noise, which for many purposes is better than the pseudo-random number algorithms typically used in computer programs."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)clearButtonActive:(id)sender {
    if (!self.spadesSwitch.isOn || !self.heartsSwitch.isOn || !self.diamondsSwitch.isOn || !self.clubsSwitch.isOn || self.jokersSwitch.isOn) {
        [self.clearButton setEnabled:YES];
    }
    else {
        [self.clearButton setEnabled:NO];
    }
}

#pragma mark - MSHTTPClient Delegate
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.response = [[MSRandomResponse alloc]init];
    [self.response parseResponseFromData:responseObject];
    if (!self.response.error) {
        [self performSegueWithIdentifier:@"ShowCardShufflerResult" sender:nil];
    } else {
        [self showAlertWithMessage:[self.response parseError]];
    }
}

- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showAlertWithMessage:@"Could not connect to the generation server. Please check your Internet connection or try later!"];
}

#pragma mark - Setup Methods
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
    if (self.jokersSwitch.isOn) {
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

@end
