//
//  MSLoteryTicketGenerator.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/16/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSLotteryQuickPickVC.h"
#import "SWRevealViewController.h"
#import "LotteryQuickPick.h"
#import "MSRandomIntegerRequest.h"
#import "MSRandomResponse.h"
#import "MSHTTPClient.h"
#import "MBProgressHUD.h"

@interface MSLotteryQuickPickVC () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, MSHTTPClientDelegate>
@property (strong, nonatomic) NSArray *loteryNames;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *copyingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;
@property (weak, nonatomic) IBOutlet UIButton *pickTicketButton;
@property (strong, nonatomic) NSString *chosenLoteryName;
@property (strong, nonatomic) MSRandomResponse *response;
@property (strong, nonatomic) LotteryQuickPick *ticket;
@end

@implementation MSLotteryQuickPickVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    self.loteryNames = @[@"Keno", @"Megalot", @"National Lottery"];
    self.chosenLoteryName = @"Keno";
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.ticketLabel.textColor = [UIColor lightGrayColor];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
}

#pragma mark - IBAction
- (IBAction)pickTicketPressed:(id)sender {
    self.ticket = [[LotteryQuickPick alloc]initWithName:self.chosenLoteryName];
    MSRandomIntegerRequest *ticketRequest = [self.ticket request];
    MSHTTPClient *client = [MSHTTPClient sharedClient];
    [client setDelegate:self];
    [client sendRequest:[ticketRequest requestBody]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - MSHTTPClient Delegate
- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didSucceedWithResponse:(id)responseObject {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.response = [[MSRandomResponse alloc]init];
    [self.response parseResponseFromData:responseObject];
    if (!self.response.error) {
        self.ticketLabel.text = [self.ticket pickFromResponse:self.response];
        self.ticketLabel.textColor = [UIColor blackColor];
    } else {
        [self showAlertWithMessage:[self.response parseError]];
    }
}

- (void) MSHTTPClient:(MSHTTPClient *)sharedHTTPClient didFailWithError:(NSError *)error {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self showAlertWithMessage:@"Could not connect to the generation server. Please check your Internet connection or try later!"];
}


#pragma mark PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.loteryNames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.loteryNames[row];
}

#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.chosenLoteryName = self.loteryNames[row];
}

#pragma mark - Setup Methods
- (void) setupMenuBar {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController)
    {
        [self.menuButton setTarget: self.revealViewController];
        [self.menuButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }
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


@end
