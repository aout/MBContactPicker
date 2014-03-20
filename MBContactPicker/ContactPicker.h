//
//  MBContactPicker.h
//  MBContactPicker
//
//  Created by Matt Bowman on 12/2/13.
//  Copyright (c) 2013 Citrrus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
#import "ContactManager.h"
#import "ContactCollectionView.h"
#import "ContactCollectionViewContactCell.h"
#import "ContactCollectionViewPromptCell.h"
#import "ContactCollectionViewEntryCell.h"

@class ContactPicker;

@protocol ContactPickerDelegate <ContactCollectionViewDelegate>

@optional

- (void)contactPicker:(ContactPicker*)contactPicker didUpdateContentHeightTo:(CGFloat)newHeight;
- (void)didShowFilteredContactsForContactPicker:(ContactPicker*)contactPicker;
- (void)didHideFilteredContactsForContactPicker:(ContactPicker*)contactPicker;

@end

@interface ContactPicker : UIView <UITableViewDataSource, UITableViewDelegate, ContactCollectionViewDelegate>

@property (nonatomic, weak) id<ContactPickerDelegate> delegate;
@property (nonatomic, readonly) NSArray *contactsSelected;
@property (nonatomic) NSInteger cellHeight;
@property (nonatomic, copy) NSString *prompt;
@property (nonatomic) CGFloat maxVisibleRows;
@property (nonatomic, readonly) CGFloat currentContentHeight;
@property (nonatomic, readonly) CGFloat keyboardHeight;
@property (nonatomic) CGFloat animationSpeed;
@property (nonatomic) BOOL allowsCompletionOfSelectedContacts;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL showPrompt;

- (void)reloadData;

@end
