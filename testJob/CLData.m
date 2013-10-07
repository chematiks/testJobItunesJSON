//
//  CLData.m
//  testJob
//
//  Created by Администратор on 9/21/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLData.h"
#import "CLOneObjects.h"

@implementation CLData
@synthesize info=_info;
@synthesize currentNumber=_currentNumber;
static CLData * sCLData = nil;

+(CLData *) sharedData
{
    @synchronized (self)
    {
        if (sCLData == nil)
        {
            sCLData = [[CLData alloc] init];
        }
    }
    return sCLData;
}

//parsing data and save in singleton
-(void) loadData
{
    NSMutableArray * dataArray=[NSMutableArray array];
    NSURL * urlData=[NSURL URLWithString:@"https://itunes.apple.com/search?term=ios&country=ru&entity=software"];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:urlData];
    NSData * data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError * jsonparserError=nil;
    dataDict=[NSJSONSerialization JSONObjectWithData:data options:1 error:&jsonparserError];
    NSDictionary * dataDict2=[dataDict objectForKey:@"results"];
    NSArray * arrayData=[[NSArray alloc] initWithObjects:dataDict2, nil];
    NSArray * arrayData2=[arrayData objectAtIndex:0];
    for (int i=0; i<[arrayData2 count]; i++) {
        NSDictionary * dataDict3=[arrayData2 objectAtIndex:i];
        CLOneObjects * object=[[CLOneObjects alloc] init];
        object.artwork=[dataDict3 objectForKey:@"artworkUrl60"];
        object.trackName=[dataDict3 objectForKey:@"trackName"];
        object.formattedPrice=[dataDict3 objectForKey:@"formattedPrice"];
        object.description=[dataDict3 objectForKey:@"description"];
        object.trackViewUrl=[dataDict3 objectForKey:@"trackViewUrl"];
        [dataArray addObject:object];
    }
    
    [self sortArrayOnName:dataArray];
}

//sonrting array by ABC
-(void) sortArrayOnName:(NSMutableArray *) array
{
    NSSortDescriptor * descriptor=[[NSSortDescriptor alloc] initWithKey:@"trackName" ascending:YES];
    NSArray * sortDescriptors=@[descriptor];
    _info=[NSArray array];
    _info=[array sortedArrayUsingDescriptors:sortDescriptors];
}

@end
