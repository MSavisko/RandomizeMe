//
//  MSAboutMenuVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/16/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSAboutMenuVC.h"
#import "SWRevealViewController.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"

@interface MSAboutMenuVC () <MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSArray *menuItems;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;

@end

@implementation MSAboutMenuVC
#pragma mark - UITableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.menuItems = @[@"feedback", @"license", @"version", @"materials"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
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

#pragma mark - Table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.menuItems[indexPath.row]isEqualToString:@"feedback"]) {
        [self sendFeedback];
    }
    else if ([self.menuItems[indexPath.row]isEqualToString:@"license"]) {
        //Segue with idenifier License
    }
    else if ([self.menuItems[indexPath.row]isEqualToString:@"materials"]) {
        //Segue with identifier materials
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Mail View Controller Delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    switch (result)
    {
        case MFMailComposeResultCancelled:
            [self showHudWithMessage:@"Cancelled"];
            break;
        case MFMailComposeResultSaved:
            [self showHudWithMessage:@"Saved"];
            break;
        case MFMailComposeResultSent:
            [self showHudWithMessage:@"Feedback sent"];
            break;
        case MFMailComposeResultFailed:
            [self showFeedbackAlert];
            break;
        default:
            break;
    }
}

#pragma mark - Table View Data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:@"version"]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

//**Because of warning in 8.1
//**"Warning once only: Detected a case where constraints ambiguously suggest a height of zero for a tableview cell's content view. We're considering the collapse unintentional and using standard height instead.
#pragma mark - Table View Cell Data source
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - Helper Method
- (void) sendFeedback {
    NSString *emailTitle = @"Feedback for Randomize Me";
    NSString *messageBody = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:@"stowyn@gmail.com"];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:YES];
    [mc setToRecipients:toRecipents];
    [self presentViewController:mc animated:YES completion:NULL];
}

#pragma mark - MBProgressHUD Method
- (void) showHudWithMessage:(NSString*)message {
    //Show
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = message;
    
    //Hide
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    });
}

#pragma mark - Alert Methods
- (void) showFeedbackAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback!"
                                                    message:@"Sorry. Could not send feedback.\nTry again later."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
