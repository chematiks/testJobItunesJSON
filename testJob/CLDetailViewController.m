//
//  CLDetailViewController.m
//  testJob
//
//  Created by Администратор on 9/22/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLDetailViewController.h"
#import "CLOneObjects.h"
#import "CLData.h"

@interface CLDetailViewController ()

@end

@implementation CLDetailViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    number=[CLData sharedData].currentNumber;
    CLOneObjects * currentItem=[[CLData sharedData].info objectAtIndex:number];
    NSURL * url=[NSURL URLWithString:currentItem.artwork];
    NSData * dataImage=[[NSData alloc] initWithContentsOfURL:url];
    UIImage * image=[[UIImage alloc] initWithData:dataImage];
    self.artworkImage.image=image;
    self.trackNameLabel.text=currentItem.trackName;
    self.priceLabel.text=currentItem.formattedPrice;
    self.descriptionText.text=currentItem.description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) setDetailitem:(NSInteger ) index
{
   [CLData sharedData].currentNumber=index;
}

- (IBAction)buyButton:(id)sender {
    number=[CLData sharedData].currentNumber;
    CLOneObjects * currentItem=[[CLData sharedData].info objectAtIndex:number];
    NSURL * url=[NSURL URLWithString:currentItem.trackViewUrl];
    [[UIApplication sharedApplication] openURL:url];
}
@end
