//
//  MSLoteryTicketGenerator.m
//  Randomize Me
//
//  Created by Maksym Savisko on 4/16/16.
//  Copyright © 2016 Maksym Savisko. All rights reserved.
//

#import "MSLotteryQuickPickVC.h"

@interface MSLotteryQuickPickVC () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) NSArray *loteryNames;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSString *chosenLoteryName;
@end

@implementation MSLotteryQuickPickVC

#pragma mark - UIViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    self.loteryNames = @[@"Keno", @"Megalot", @"National Lottery"];
    self.chosenLoteryName = @"Keno";
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
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

@end
