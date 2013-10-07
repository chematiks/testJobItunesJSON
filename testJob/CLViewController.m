//
//  CLViewController.m
//  testJob
//
//  Created by Администратор on 9/19/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLViewController.h"
#import "CLCellImageNameDetail.h"
#import "CLData.h"
#import "CLOneObjects.h"
#import "CLDetailViewController.h"
#import "CLImageCache.h"

@interface CLViewController ()

@end

@implementation CLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[CLData sharedData] loadData];
    ascending=YES;
    
    //persistent data, load from file
    NSString *filePath=[self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString * truefalse=[[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if ([truefalse isEqualToString:@"0"]) {
            ascending=NO;
            CGRect sortLabelRect=self.sortLabelView.frame;
            sortLabelRect.origin.x=-180;
            self.sortLabelView.frame=sortLabelRect;
        }
    }
    UIApplication *app=[UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(applicationWillResignActive:)
        name:UIApplicationWillResignActiveNotification
        object:app];
    
    //create swipe gesture
    UISwipeGestureRecognizer * horizontalLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reportHorizontalSwipeLeft:)];
    UISwipeGestureRecognizer * horizontalRigth=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(reportHorizontalSwipeRigth:)];
    
    horizontalLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    horizontalRigth.direction=UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:horizontalLeft];
    [self.view addGestureRecognizer:horizontalRigth];
}

//if deactive app, save sort in file
-(void) applicationWillResignActive:(NSNotification *)notification
{
    NSString * filePath=[self dataFilePath];
    NSString * ascendingString=[NSString stringWithFormat:@"%d",ascending];
    [ascendingString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

//get file path
-(NSString *) dataFilePath
{
    NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory=[paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//count rows in table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[CLData sharedData].info count];
}

//init cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const cellId=@"cell";
    int currentIndexPath;
    if (ascending)
        currentIndexPath=indexPath.row;
    else
        currentIndexPath=[CLData sharedData].info.count-1-indexPath.row;
 
    CLCellImageNameDetail * cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(cell==nil){
        cell=[[CLCellImageNameDetail alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    CLOneObjects * currentObject=[[CLData sharedData].info objectAtIndex:currentIndexPath];
    if ([[CLImageCache sharedImageCache] doesExist:currentObject.artwork]==true) {
        cell.cellimage.image=[[CLImageCache sharedImageCache] getImage:currentObject.artwork];
        [cell.cellimage setNeedsLayout];
    }else{
        cell.cellimage.hidden=YES;
        NSURL * url=[NSURL URLWithString:currentObject.artwork];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage * image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [cell.cellimage setImage:image];
                [[CLImageCache sharedImageCache] addImage:currentObject.artwork:image];
                cell.cellimage.hidden=NO;
                [cell.cellimage setNeedsLayout];
            });
        });
    }
    
    cell.titletext.text=currentObject.trackName;
    cell.priceText.text=currentObject.formattedPrice;

    return cell;
}

//push data to detail view controller
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath * index=[self.tableView indexPathForSelectedRow];
    int indexInt=index.row;
    if(!ascending)
        indexInt=[[CLData sharedData].info count]-1-indexInt;
    [segue.destinationViewController setDetailitem:indexInt];
}

//if swipe to left
-(void) reportHorizontalSwipeLeft:(UIGestureRecognizer *) recognize
{
    if (ascending) {
        ascending=NO;
        [UIView animateWithDuration:0.5f
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             CGRect sortLabelRect=self.sortLabelView.frame;
                             sortLabelRect.origin.x=-180;
                             self.sortLabelView.frame=sortLabelRect;
                                     }
                         completion:^(BOOL finished){}];
         [UIView transitionWithView:self.tableView
                           duration:0.5f
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             [self.tableView reloadData];}
                         completion:NULL];
    }
}

//if swipe to rigth
-(void) reportHorizontalSwipeRigth:(UIGestureRecognizer *) recognize
{
    if (!ascending) {
        ascending=YES;
        [UIView animateWithDuration:0.5f
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             CGRect sortLabelRect=self.sortLabelView.frame;
                             sortLabelRect.origin.x=0;
                             self.sortLabelView.frame=sortLabelRect;}
                         completion:^(BOOL finished){}];
         [UIView transitionWithView:self.tableView
                           duration:0.5f
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             [self.tableView reloadData];}
                         completion:NULL];
    }
}

@end
