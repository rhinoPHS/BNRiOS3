//
//  DetailViewController.m
//  Homepwner
//
//  Created by rhino Q on 26/08/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "DetailViewController.h"
#import "Model/BNRItem.h"
#import "DatePickerViewController.h"
#import "Model/BNRImageStore.h"
#import "CameraOverlayView.h"
#import "Model/ItemStore.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (weak, nonatomic) IBOutlet UIButton *removeImageButton;

@end

@implementation DetailViewController

- (instancetype)initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if(self) {
        if(isNew){
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                      target:self
                                                                                      action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                        target:self
                                                                                        action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}

-(void)save:(id)sender{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:_dismissBlock];
}

-(void)cancel:(id)sender {
    // If the user cancelled, then remove the BNRItem from the store
    [[ItemStore sharedStore] removeItem:_item];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:_dismissBlock];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [nameField setText:_item.itemName];
    [serialNumberField setText:[_item serialNumber]];
    valueField.text = [NSString stringWithFormat:@"%d", [_item valueInDollars]];
    
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Use filetered NSDate object to set dateLabel contents
    [dateLabel setText:[dateFormatter stringFromDate:[_item dateCreated]]];
    
    [self addDoneButtonOnKeyboard];
    
    NSString *imageKey = [_item imageKey];
    
    if(imageKey) {
        //Get image for image key from image store
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        // Use that image to put on the screen in imageView
        [_imageView setImage:imageToDisplay];
        [_removeImageButton setHidden:NO];
    } else {
        // Clear the imageView
        [_imageView setImage:nil];
        [_removeImageButton setHidden:YES];
    }
}

- (void)setItem:(BNRItem *)i {
    _item = i;
    [[self navigationItem] setTitle:[_item itemName]];
}
//https://stackoverflow.com/questions/38133853/how-to-add-a-return-key-on-a-decimal-pad-in-swift
-(void) addDoneButtonOnKeyboard {
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flexSapce = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction)];
    
    NSArray *items = [NSArray arrayWithObjects:flexSapce,done, nil];
    doneToolbar.items = items;
    [doneToolbar sizeToFit];
    self.valueTextField.inputAccessoryView = doneToolbar;
}

-(void)doneButtonAction {
    [self.valueTextField resignFirstResponder];
}
- (IBAction)changeDateButtonAction:(UIButton *)sender {
    DatePickerViewController *datePickerVC = [DatePickerViewController new];
    datePickerVC.item = self.item;
    [[self navigationController] pushViewController:datePickerVC animated:YES];
}

- (IBAction)takePicture:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise,
    // we just pick from photo library
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setAllowsEditing:YES];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // 1. Determine the frame within which the crosshair will be drawn
        CGRect screenRect = [[[self view] window] bounds];
        CGPoint centre;
        centre.x = screenRect.origin.x + screenRect.size.width / 2.0;
        centre.y = screenRect.origin.y + screenRect.size.height / 2.0;
        CGSize size;
        size.width = screenRect.size.width * 0.25;
        size.height = screenRect.size.height * 0.2;
        CGRect overlayRect = CGRectMake(centre.x - size.width/2, centre.y - size.height/2, size.width, size.height);
        
        // 2. Create the overlay's UIView within that frame
        UIView *overlayView = [[CameraOverlayView alloc] initWithFrame:overlayRect];
        
        // 3. Tell the image picker to show an overlay view
        [imagePicker setCameraOverlayView:overlayView];
    }
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        CGRect rect = CGRectMake(100, 100, self.view.frame.size.width, self.view.frame.size.height);
        imagePicker.modalPresentationStyle = UIModalPresentationPopover;
        imagePicker.popoverPresentationController.sourceView = self.view;
        imagePicker.popoverPresentationController.sourceRect = rect;
        
        //        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    NSString *oldKey = [_item imageKey];
    //Did the item already have an image?
    if(oldKey) {
        // Delete the old image
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    //Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [_item setThumbnailDataFromImage:image];
    
    // Create a CFUUID object  it knows how to create unique identifier strings
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    
    //Create a string from unique identifier
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    
    // Use taht unique ID to set our item's imageKey
    NSString *key = (__bridge NSString*)newUniqueIDString;
    [_item setImageKey:key];
    
    //Store image in the BNRImageStore with this key
    [[BNRImageStore sharedStore] setImage:image forkey:[_item imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueId);
    
    
    //Put that iimage onto the screen in our image view
    [_imageView setImage:image];
    [_removeImageButton setHidden:NO];
    
    //Take iamge picker off the screen
    //you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backgoundTapped:(id)sender {
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)removeImage:(UIButton *)sender {
    NSString *imageKey = [_item imageKey];
    if(imageKey) {
        [[BNRImageStore sharedStore]deleteImageForKey:imageKey];
        [_item setImageKey:nil];
        [_imageView setImage:nil];
        [_removeImageButton setHidden:YES];
    } else {
        NSLog(@"no image to remove");
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [_item setSerialNumber:serialNumberField.text];
    [_item setItemName:nameField.text];
    [_item setValueInDollars:[valueField.text intValue]];
}

@end
