//
//  DH_PFStreamTVC.h
//  DHToolkit
//
//  Created by Tim Shi on 1/10/12.
//  Copyright (c) 2012 www.timshi.com. All rights reserved.
//

#import "Parse/PFQueryTableViewController.h"

@interface DH_PFStreamTVC : PFQueryTableViewController

@property (nonatomic, weak) NSManagedObjectContext *context;

- initInManagedObjectContext:(NSManagedObjectContext *)aContext;

@end
