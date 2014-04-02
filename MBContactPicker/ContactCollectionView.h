//
//  ContactCollectionView.h
//  MBContactPicker
//
//  Created by Matt Bowman on 11/20/13.
//  Copyright (c) 2013 Citrrus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactCollectionViewContactCell.h"
#import "ContactCollectionViewEntryCell.h"
#import "ContactCollectionViewPromptCell.h"
#import "ContactCollectionViewFlowLayout.h"

@class ContactCollectionView;

@protocol ContactCollectionViewDelegate <NSObject>

@optional

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView willChangeContentSizeTo:(CGSize)newSize;
- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView entryTextDidChange:(NSString*)text;
- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView entryTextDidPressDone:(NSString*)text;
- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView didSelectContact:(Contact*)aContact;
- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView didAddContact:(Contact*)aContact;
- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView didRemoveContact:(Contact*)aContact;

@end

@interface ContactCollectionView : UICollectionView

@property (nonatomic) NSMutableArray *selectedContacts;
@property (nonatomic, weak) id<ContactCollectionViewDelegate> contactDelegate;

- (void)addToSelectedContacts:(Contact*)aContact withCompletion:(void(^)())completion;
- (void)removeFromSelectedContacts:(NSInteger)index withCompletion:(void(^)())completion;
- (void)setFocusOnEntry;
- (void)scrollToEntryAnimated:(BOOL)animated onComplete:(void(^)())complete;
- (BOOL)isEntryCell:(NSIndexPath*)indexPath;
- (BOOL)isPromptCell:(NSIndexPath*)indexPath;
- (BOOL)isContactCell:(NSIndexPath*)indexPath;
- (NSInteger)entryCellIndex;
- (NSInteger)selectedContactIndexFromIndexPath:(NSIndexPath*)indexPath;
- (NSInteger)selectedContactIndexFromRow:(NSInteger)row;
- (NSIndexPath*)indexPathOfSelectedCell;

+ (ContactCollectionView*)contactCollectionViewWithFrame:(CGRect)frame;

@property (nonatomic) NSInteger cellHeight;
@property (nonatomic, copy) NSString *prompt;
@property (nonatomic) BOOL allowsTextInput;
@property (nonatomic) BOOL showPrompt;

@end
