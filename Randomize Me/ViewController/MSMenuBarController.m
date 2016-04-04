//
//  MSMenuBarController.m
//  
//
//  Created by Maksym Savisko on 4/4/16.
//
//

#import "MSMenuBarController.h"
#import "SWRevealViewController.h"

@interface MSMenuBarController ()
@property (nonatomic, strong) NSArray *menuItems;
@end


@implementation MSMenuBarController

#pragma mark - UITableViewController
- (id) initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.menuItems = @[@"integer", @"decimal", @"string", @"list", @"password", @"dice", @"lottery", @"card", @"verify", @"history", @"settings", @"about"];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return cell;
}

@end

