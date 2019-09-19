//
//  ItemsTableViewController.m
//  Homepwner
//
//  Created by rhino Q on 14/08/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "Model/BNRItem.h"
#import "Model/ItemStore.h"
#import "DetailViewController.h"
#import "HomepwnerItemCell.h"

@interface ItemsTableViewController ()

@end

@implementation ItemsTableViewController

//- (UIView *)headerView {
//    if(!headerView) {
//        [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    return headerView;
//}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (instancetype)init
{
//    self = [super init];
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Homepwer"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
//        for(int i =0; i<5; i++) {
//            [[ItemStore sharedStore] createItem];
//        }
//        [[ItemStore sharedStore] divideInValue:50];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%lu",(unsigned long)[[ItemStore sharedStore] allItems].count);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//- (void)toggleEditingMode:(id)sender {
//    if([self isEditing]) {
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        [self setEditing:NO animated:YES];
//    } else {
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        [self setEditing:YES animated:YES];
//    }
//}

#pragma mark - Table view data source.


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==0) {
        return [[[ItemStore sharedStore] allItems]count];
    } else if ( section==1 ) {
        return 1;
    } else {
        return 0;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if(section == 0)
//        return @"More than $50";
//    else if (section == 1) {
//        return @"Rest";
//    } else {
//        return @"";
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    [cell setController:self];
    [cell setTableView:tableView];
    
    BNRItem *p;
    
    if(indexPath.section ==0) {
        p = [[[ItemStore sharedStore] allItems] objectAtIndex:indexPath.row];
        cell.titleLabel.text = p.itemName;
        cell.idLabel.text = p.serialNumber;
        cell.valueLabel.text = [NSString stringWithFormat:@"$%d",p.valueInDollars];
        cell.thumbNameImageView.image = p.thumbnail;
     } else  {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.textLabel.text = @"No More items";
        return cell;
    }
    
    
    
    
//    cell.textLabel.font = [UIFont systemFontOfSize:20];
//    cell.textLabel.numberOfLines = 0;
//    cell.textLabel.text = [p description];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (indexPath.section) {
//        case 0: case 1:
//            return 60;
//            break;
//        default:
//            return 44;
//            break;
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if(section == 0) { return [self headerView];}
//    return nil;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if(section ==0) { return [[self headerView] bounds].size.height; }
//    return 0;
//}

-(void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip {
    NSLog(@"Going to show the image for %@",ip);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 0)
    {
        ItemStore *ps = [ItemStore sharedStore];
//        NSArray *items = [ps itemsMoreThan];
        NSArray *items  = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
//        [ps.itemsMoreThan removeObjectIdenticalTo:p];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)addNewItem:(id)sender {
    
    BNRItem *newItem = [[ItemStore sharedStore] createItem];
    
//    int lastRow = (int)[self.tableView numberOfRowsInSection:0];
    
//    [[[ItemStore sharedStore] itemsMoreThan] addObject:newItem];
    
//    int lastRow = (int)[[[ItemStore sharedStore] allItems] indexOfObject:newItem];
    
//    int lastRow = (int)[[[ItemStore sharedStore] itemsMoreThan] indexOfObject:newItem];
    
//    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{
        [self.tableView reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
//    it hides the "cancel", "done" buttons of detailVC
//    [navController setModalPresentationStyle:UIModalPresentationCurrentContext];
//    [self setDefinesPresentationContext:YES];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    } else {
        [navController setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    }
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 ) { return false; }
    return true;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [[ItemStore sharedStore] moveItemAtIndex:(int)[sourceIndexPath row] toIndex:(int)[destinationIndexPath row]];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DetailViewController *detailViewControoler = [[DetailViewController alloc] init];
    DetailViewController *detailViewControoler = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[ItemStore sharedStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    // Give detail view controller a pointer to the item object in row
    [detailViewControoler setItem:selectedItem];
    
    //Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewControoler animated:YES];
    
}

- (BOOL)shouldAutorotate {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}

@end
