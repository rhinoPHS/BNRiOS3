//
//  DetailViewController.h
//  Homepwner
//
//  Created by rhino Q on 26/08/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;
NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
}
@property (nonatomic, strong) BNRItem *item;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, copy) void (^dismissBlock)(void);
-(instancetype)initForNewItem:(BOOL)isNew;

@end

NS_ASSUME_NONNULL_END
