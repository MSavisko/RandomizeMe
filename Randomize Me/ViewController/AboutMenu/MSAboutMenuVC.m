//
//  MSAboutMenuVC.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/16/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSAboutMenuVC.h"
#import "SWRevealViewController.h"

@interface MSAboutMenuVC ()
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
       //Send Feedback
    }
    else if ([self.menuItems[indexPath.row]isEqualToString:@"license"]) {
        //Segue with idenifier License
    }
    else if ([self.menuItems[indexPath.row]isEqualToString:@"materials"]) {
        //Segue with identifier materials
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


#pragma mark - Table View data source
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

#pragma mark - Table View Cell data source
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
