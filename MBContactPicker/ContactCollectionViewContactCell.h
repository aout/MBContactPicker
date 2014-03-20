//
//  ContactCollectionViewCell.h
//  MBContactPicker
//
//  Created by Matt Bowman on 11/20/13.
//  Copyright (c) 2013 Citrrus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactCollectionViewContactCell : UICollectionViewCell

@property (nonatomic, strong) Contact* contact;
@property (nonatomic) BOOL focused;

- (void)configureForContact:(Contact*)aContact;
- (CGFloat)widthForCellWithContact:(Contact*)aContact;

@end
