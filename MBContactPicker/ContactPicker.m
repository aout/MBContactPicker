//
//  MBContactPicker.m
//  MBContactPicker
//
//  Created by Matt Bowman on 12/2/13.
//  Copyright (c) 2013 Citrrus, LLC. All rights reserved.
//

#import "ContactPicker.h"
#import "NSString+Mail.h"

CGFloat const kMaxVisibleRows = 100;
NSString * const kMBPrompt = @"To:";
CGFloat const kAnimationSpeed = .25;

@interface ContactPicker()

@property (nonatomic, weak) ContactCollectionView *contactCollectionView;
@property (nonatomic, weak) UITableView *searchTableView;
@property (nonatomic) NSArray *filteredContacts;
@property (nonatomic) NSMutableArray *selectedContacts;
@property (nonatomic) NSArray *contacts;
@property (nonatomic) CGFloat keyboardHeight;
@property (nonatomic) CGSize contactCollectionViewContentSize;

@property CGFloat originalHeight;
@property CGFloat originalYOffset;

@property (nonatomic) BOOL hasLoadedData;

@end

@implementation ContactPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

- (void)didMoveToWindow
{
    if (self.window)
    {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(keyboardChangedStatus:) name:UIKeyboardWillShowNotification object:nil];
        [nc addObserver:self selector:@selector(keyboardChangedStatus:) name:UIKeyboardWillHideNotification object:nil];
        
        if (!self.hasLoadedData)
        {
            [self reloadData];
            self.hasLoadedData = YES;
        }
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if (newWindow == nil)
    {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [nc removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)setup
{
    _prompt = kMBPrompt;
    _showPrompt = YES;
    
    self.originalHeight = -1;
    self.originalYOffset = -1;
    self.maxVisibleRows = kMaxVisibleRows;
    self.animationSpeed = kAnimationSpeed;
    self.allowsCompletionOfSelectedContacts = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.clipsToBounds = YES;
    self.enabled = YES;
    
    self.selectedContacts = [NSMutableArray new];
    
    ContactCollectionView *contactCollectionView = [ContactCollectionView contactCollectionViewWithFrame:self.bounds];
    contactCollectionView.contactDelegate = self;
    contactCollectionView.clipsToBounds = YES;
    contactCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:contactCollectionView];
    self.contactCollectionView = contactCollectionView;
    
    UITableView *searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 0)];
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    searchTableView.translatesAutoresizingMaskIntoConstraints = NO;
    searchTableView.hidden = YES;
    [self addSubview:searchTableView];
    self.searchTableView = searchTableView;
    
    
    [contactCollectionView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [searchTableView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[contactCollectionView(>=%ld,<=%ld)][searchTableView(>=0)]|", (long)self.cellHeight, (long)self.cellHeight]
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(contactCollectionView, searchTableView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contactCollectionView]-(0@500)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(contactCollectionView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contactCollectionView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(contactCollectionView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchTableView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(searchTableView)]];
    
    
#ifdef DEBUG_BORDERS
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0;
    contactCollectionView.layer.borderColor = [UIColor redColor].CGColor;
    contactCollectionView.layer.borderWidth = 1.0;
    searchTableView.layer.borderColor = [UIColor blueColor].CGColor;
    searchTableView.layer.borderWidth = 1.0;
#endif
}

#pragma mark - Keyboard Notification Handling
- (void)keyboardChangedStatus:(NSNotification*)notification
{
    CGRect keyboardRect;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    self.keyboardHeight = keyboardRect.size.height;
}

- (void)reloadData
{
    self.contactCollectionView.selectedContacts = [NSMutableArray new];
    
    self.contacts = [ContactManager getContacts];
    
    [self.contactCollectionView reloadData];
    [self.contactCollectionView performBatchUpdates:^{
    } completion:^(BOOL finished) {
        [self.contactCollectionView scrollToEntryAnimated:NO onComplete:nil];
    }];
}

#pragma mark - Properties

- (NSArray*)contactsSelected
{
    return self.contactCollectionView.selectedContacts;
}

- (void)setCellHeight:(NSInteger)cellHeight
{
    self.contactCollectionView.cellHeight = cellHeight;
    [self.contactCollectionView.collectionViewLayout invalidateLayout];
}

- (NSInteger)cellHeight
{
    return self.contactCollectionView.cellHeight;
}

- (void)setPrompt:(NSString *)prompt
{
    _prompt = [prompt copy];
    self.contactCollectionView.prompt = _prompt;
}

- (void)setMaxVisibleRows:(CGFloat)maxVisibleRows
{
    _maxVisibleRows = maxVisibleRows;
    [self.contactCollectionView.collectionViewLayout invalidateLayout];
}

- (CGFloat)currentContentHeight
{
    CGFloat minimumSizeWithContent = MAX(self.cellHeight, self.contactCollectionViewContentSize.height);
    CGFloat maximumSize = self.maxVisibleRows * self.cellHeight;
    return MIN(minimumSizeWithContent, maximumSize);
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    self.contactCollectionView.allowsSelection = enabled;
    self.contactCollectionView.allowsTextInput = enabled;
    
    if (!enabled)
    {
        [self resignFirstResponder];
    }
}

- (void)setShowPrompt:(BOOL)showPrompt
{
    _showPrompt = showPrompt;
    self.contactCollectionView.showPrompt = showPrompt;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredContacts.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"Cell"];
    }
    
    Contact* contact = (Contact*)self.filteredContacts[indexPath.row];
    
    cell.textLabel.text = [contact getFullName];
    
    cell.detailTextLabel.text = contact.email;
    cell.imageView.image = nil;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contact* contact = self.filteredContacts[indexPath.row];
    
    [self hideSearchTableView];
    [self.contactCollectionView addToSelectedContacts:contact withCompletion:^{
        [self becomeFirstResponder];
    }];
}

#pragma mark - ContactCollectionViewDelegate

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView willChangeContentSizeTo:(CGSize)newSize
{
    if (!CGSizeEqualToSize(self.contactCollectionViewContentSize, newSize))
    {
        self.contactCollectionViewContentSize = newSize;
        [self updateCollectionViewHeightConstraints];
        
        if ([self.delegate respondsToSelector:@selector(contactPicker:didUpdateContentHeightTo:)])
        {
            [self.delegate contactPicker:self didUpdateContentHeightTo:self.currentContentHeight];
        }
    }
}

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView entryTextDidChange:(NSString*)text
{
    [self.contactCollectionView.collectionViewLayout invalidateLayout];
    
    [self.contactCollectionView performBatchUpdates:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.contactCollectionView setFocusOnEntry];
    }];
    
    if ([text isEqualToString:@" "])
    {
        [self hideSearchTableView];
    }
    else
    {
        [self showSearchTableView];
        NSString *searchString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSPredicate *predicate;
        
        NSPredicate* fullNamePredicate = [NSPredicate predicateWithFormat:@"fullName contains[cd] %@", searchString];
        NSPredicate* emailPredicate = [NSPredicate predicateWithFormat:@"email contains[cd] %@", searchString];
        NSPredicate* notSelectedPredicate = [NSPredicate predicateWithFormat:@"!SELF IN %@", self.contactCollectionView.selectedContacts];
        
        NSPredicate* containPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[fullNamePredicate, emailPredicate]];
        
        if (self.allowsCompletionOfSelectedContacts) {
            predicate = containPredicate;
        } else {
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[containPredicate, notSelectedPredicate]];
        }
        self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
        [self.searchTableView reloadData];
    }
}

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView entryTextDidPressDone:(NSString*)text
{
    NSString* potentialMailAdress = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([potentialMailAdress isAnEmailAdress]) {
        // Create a contact and add it
        Contact* contact = [ContactManager getContactWithName:@"" andMail:potentialMailAdress orCreateOne:YES];
        [self.contactCollectionView addToSelectedContacts:contact withCompletion:^{
            [self.contactCollectionView.collectionViewLayout invalidateLayout];
            [self.contactCollectionView performBatchUpdates:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                [self hideSearchTableView];
                [self.contactCollectionView setFocusOnEntry];
            }];
        }];
    }
}

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView didRemoveContact:(Contact*)aContact
{
    if ([self.delegate respondsToSelector:@selector(contactCollectionView:didRemoveContact:)])
    {
        [self.delegate contactCollectionView:contactCollectionView didRemoveContact:aContact];
    }
}

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView didAddContact:(Contact*)aContact
{
    if ([self.delegate respondsToSelector:@selector(contactCollectionView:didAddContact:)])
    {
        [self.delegate contactCollectionView:contactCollectionView didAddContact:aContact];
    }
}

- (void)contactCollectionView:(ContactCollectionView*)contactCollectionView didSelectContact:(Contact*)aContact
{
    if ([self.delegate respondsToSelector:@selector(contactCollectionView:didSelectContact:)])
    {
        [self.delegate contactCollectionView:contactCollectionView didSelectContact:aContact];
    }
}

#pragma mark - UIResponder

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (BOOL)becomeFirstResponder
{
    if (!self.enabled)
    {
        return NO;
    }
    
    if (![self isFirstResponder])
    {
        if (self.contactCollectionView.indexPathOfSelectedCell)
        {
            [self.contactCollectionView scrollToItemAtIndexPath:self.contactCollectionView.indexPathOfSelectedCell atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        else
        {
            [self.contactCollectionView setFocusOnEntry];
        }
    }
    
    return YES;
}

- (BOOL)resignFirstResponder
{
    return [self.contactCollectionView resignFirstResponder];
}

#pragma mark Helper Methods

- (void)showSearchTableView
{
    self.searchTableView.hidden = NO;
    if ([self.delegate respondsToSelector:@selector(didShowFilteredContactsForContactPicker:)])
    {
        [self.delegate didShowFilteredContactsForContactPicker:self];
    }
}

- (void)hideSearchTableView
{
    self.searchTableView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(didHideFilteredContactsForContactPicker:)])
    {
        [self.delegate didHideFilteredContactsForContactPicker:self];
    }
}

- (void)updateCollectionViewHeightConstraints
{
    for (NSLayoutConstraint *constraint in self.constraints)
    {
        if (constraint.firstItem == self.contactCollectionView)
        {
            if (constraint.firstAttribute == NSLayoutAttributeHeight)
            {
                if (constraint.relation == NSLayoutRelationGreaterThanOrEqual)
                {
                    constraint.constant = self.cellHeight;
                }
                else if (constraint.relation == NSLayoutRelationLessThanOrEqual)
                {
                    constraint.constant = self.currentContentHeight;
                }
            }
        }
    }
    
}

@end