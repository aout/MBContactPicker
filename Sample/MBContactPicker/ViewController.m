//
//  ViewController.m
//  MBContactPicker
//
//  Created by Matt Bowman on 11/20/13.
//  Copyright (c) 2013 Citrrus, LLC. All rights reserved.
//

#import "ViewController.h"
#import "ContactPicker.h"

@interface ViewController () <ContactPickerDelegate>

@property (weak, nonatomic) IBOutlet ContactPicker *contactPickerView;
@property (weak, nonatomic) IBOutlet UITextField *promptTextField;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contactPickerViewHeightConstraint;

- (IBAction)resignFirstResponder:(id)sender;
- (IBAction)takeFirstResponder:(id)sender;
- (IBAction)enabledSwitched:(id)sender;
- (IBAction)completeDuplicatesSwitched:(id)sender;

@end

@implementation ViewController

- (IBAction)clearSelectedButtonTouchUpInside:(id)sender
{
    [self.contactPickerView reloadData];
}

- (IBAction)addContactsButtonTouchUpInside:(id)sender
{
    [self.contactPickerView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.contactPickerView.delegate = self;
    
    self.promptTextField.text = self.contactPickerView.prompt;
    [self.promptTextField addTarget:self action:@selector(promptTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}


#pragma mark - MBContactPickerDelegate

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView didSelectContact:(Contact*)aContact
{
    //NSLog(@"Did Select: %@", model.contactTitle);
}

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView didAddContact:(Contact*)aContact
{
    //NSLog(@"Did Add: %@", model.contactTitle);
}

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView didRemoveContact:(Contact*)aContact
{
    //NSLog(@"Did Remove: %@", model.contactTitle);
}

// This delegate method is called to allow the parent view to increase the size of
// the contact picker view to show the search table view
- (void)didShowFilteredContactsForContactPicker:(ContactPicker*)contactPicker
{
    if (self.contactPickerViewHeightConstraint.constant <= contactPicker.currentContentHeight)
    {
        [UIView animateWithDuration:contactPicker.animationSpeed animations:^{
            CGRect pickerRectInWindow = [self.view convertRect:contactPicker.frame fromView:nil];
            CGFloat newHeight = self.view.window.bounds.size.height - pickerRectInWindow.origin.y - contactPicker.keyboardHeight;
            self.contactPickerViewHeightConstraint.constant = newHeight;
            [self.view layoutIfNeeded];
        }];
    }
}

// This delegate method is called to allow the parent view to decrease the size of
// the contact picker view to hide the search table view
- (void)didHideFilteredContactsForContactPicker:(ContactPicker*)contactPicker
{
    if (self.contactPickerViewHeightConstraint.constant > contactPicker.currentContentHeight)
    {
        [UIView animateWithDuration:contactPicker.animationSpeed animations:^{
            self.contactPickerViewHeightConstraint.constant = contactPicker.currentContentHeight;
            [self.view layoutIfNeeded];
        }];
    }
}

// This delegate method is invoked to allow the parent to increase the size of the
// collectionview that shows which contacts have been selected. To increase or decrease
// the number of rows visible, change the maxVisibleRows property of the MBContactPicker
- (void)contactPicker:(ContactPicker*)contactPicker didUpdateContentHeightTo:(CGFloat)newHeight
{
    self.contactPickerViewHeightConstraint.constant = newHeight;
    [UIView animateWithDuration:contactPicker.animationSpeed animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)takeFirstResponder:(id)sender
{
    [self.contactPickerView becomeFirstResponder];
}

- (IBAction)resignFirstResponder:(id)sender
{
    [self.contactPickerView resignFirstResponder];
}

- (IBAction)enabledSwitched:(id)sender
{
    self.contactPickerView.enabled = ((UISwitch *)sender).isOn;
}

- (IBAction)completeDuplicatesSwitched:(id)sender
{
    self.contactPickerView.allowsCompletionOfSelectedContacts = ((UISwitch *)sender).isOn;
}

- (void)promptTextFieldDidChange:(UITextField *)textField
{
    self.contactPickerView.prompt = textField.text;
}

@end