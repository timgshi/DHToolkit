//
//  DHEditingSettingCell.h
//  DHToolkit
//
//  Created by Tim Shi on 3/15/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHEditingSettingCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UITextField *editingField;

@end
