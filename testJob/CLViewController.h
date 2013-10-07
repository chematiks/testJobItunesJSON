//
//  CLViewController.h
//  testJob
//
//  Created by Администратор on 9/19/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLViewController : UIViewController <UITableViewDataSource>
{
    BOOL ascending;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sortLabelView;

@end
