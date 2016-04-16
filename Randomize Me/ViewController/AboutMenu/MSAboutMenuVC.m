//
//  MSAboutMenuVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/16/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSAboutMenuVC.h"
#import "MSDetailMenuVC.h"
#import "SWRevealViewController.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD.h"

@interface MSAboutMenuVC () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) NSString *displayData;
@property (strong, nonatomic) NSString *detailTitle;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButtonItem;

@end

@implementation MSAboutMenuVC
#pragma mark - UITableViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.menuItems = @[@"feedback", @"license", @"version", @"materials"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupMenuBar];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MSDetailMenuVC *resultVC = segue.destinationViewController;
    resultVC.displayData = self.displayData;
    resultVC.titleForView = self.detailTitle;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.menuItems[indexPath.row]isEqualToString:@"feedback"]) {
        [self sendFeedback];
    }
    else if ([self.menuItems[indexPath.row]isEqualToString:@"license"]) {
        self.detailTitle = @"License";
        self.displayData = [self licenses];
        [self performSegueWithIdentifier:@"ShowDetailMenu" sender:nil];
    }
    else if ([self.menuItems[indexPath.row]isEqualToString:@"materials"]) {
        self.detailTitle = @"Used materials";
        self.displayData = [self usedMaterials];
        [self performSegueWithIdentifier:@"ShowDetailMenu" sender:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - MailViewControllerDelegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
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

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
#pragma mark - TableViewCellDataSource
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - HelperMethod
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

#pragma mark - MBProgressHUDMethod
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

#pragma mark - AlertMethods
- (void) showFeedbackAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Feedback!"
                                                    message:@"Sorry. Could not send feedback.\nTry again later."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - PresentationDataStringMethod
- (NSString*) licenses {
    NSString *networking = [NSString stringWithFormat:@"AFNetworking\n\nCopyright (c) 2011–2016 Alamofire Software Foundation (http://alamofire.org/)\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n\n"];
    
    NSString *hudProgress = [NSString stringWithFormat:@"MBProgressHUD\n\nCopyright (c) 2009-2015 Matej Bukovinski\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n\n"];
    
    NSString *vk = [NSString stringWithFormat:@"Vk-ios-sdk\n\nThe MIT License (MIT)\nCopyright (c) 2015 VK.com\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n\n"];
    
    NSString *facebook = [NSString stringWithFormat:@"Facebook-ios-sdk\n\nCopyright (c) 2014-present, Facebook, Inc. All rights reserved.\nYou are hereby granted a non-exclusive, worldwide, royalty-free license to use, copy, modify, and distribute this software in source code or binary form for use in connection with the web services and APIs provided by Facebook.\nAs with any software that integrates with the Facebook platform, your use of this software is subject to the Facebook Developer Principles and Policies [http://developers.facebook.com/policy/]. This copyright notice shall be included in all copies or substantial portions of the software.\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n\n\n"];
    
    NSString *swreveal = [NSString stringWithFormat:@"SWRevealViewController\n\nCopyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\nTHE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\nEarly code inspired on a similar class by Philip Kluz (Philip.Kluz@zuui.org)"];
    
    NSMutableString *result = [[NSMutableString alloc]initWithString:networking];
    [result appendString:hudProgress];
    [result appendString:vk];
    [result appendString:facebook];
    [result appendString:swreveal];
    
    return result;
    
}

- (NSString*) usedMaterials {
    NSString *icons = [NSString stringWithFormat:@"Icons8\nhttps://icons8.com/\n\n\n"];
    NSString *images = [NSString stringWithFormat:@"Flaticon\nhttp://www.flaticon.com/\n\n\n"];
    NSString *cards = [NSString stringWithFormat:@"Vector playing cards\nhttps://code.google.com/archive/p/vector-playing-cards/\n\n\n"];
    NSString *api = [NSString stringWithFormat:@"RandomOrg\nhttps://www.random.org/\n\n\n"];
    NSMutableString *result = [[NSMutableString alloc]initWithString:icons];
    [result appendString:images];
    [result appendString:cards];
    [result appendString:api];
    
    return result;
}

@end
