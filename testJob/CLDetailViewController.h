//
//  CLDetailViewController.h
//  testJob
//
//  Created by Администратор on 9/22/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDetailViewController : UIViewController
{
    NSInteger number;
}

@property (weak, nonatomic) IBOutlet UIImageView *artworkImage;
@property (weak, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionText;

- (IBAction)buyButton:(id)sender;
-(void) setDetailitem:(NSInteger ) index;

@end
