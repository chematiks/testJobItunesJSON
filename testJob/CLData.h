//
//  CLData.h
//  testJob
//
//  Created by Администратор on 9/21/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLData : NSObject
{
    NSDictionary * dataDict;
}

@property (retain,nonatomic) NSArray * info;
@property ( nonatomic) NSInteger currentNumber;

+(CLData *) sharedData;
-(void) loadData;

@end
