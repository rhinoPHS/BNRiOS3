//
//  DatePickerViewController.m
//  Homepwner
//
//  Created by rhino Q on 28/08/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "DatePickerViewController.h"
#import "Model/BNRItem.h"

@interface DatePickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:[self navigationController] action:@selector(popViewControllerAnimated:)];
    [[self navigationItem] setRightBarButtonItem:bbi];
    
    [_datePicker setDate:self.item.dateCreated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.item setDateCreated:[_datePicker date]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
