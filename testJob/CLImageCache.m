//
//  CLImageCache.m
//  testJob
//
//  Created by Администратор on 10/6/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import "CLImageCache.h"

@implementation CLImageCache

@synthesize imgCache;

static CLImageCache* sharedImageCache=nil;

//singleton for caching image
+(CLImageCache *) sharedImageCache
{
    @synchronized ([CLImageCache class])
    {
        if (!sharedImageCache)
            sharedImageCache=[[self alloc] init];
        return sharedImageCache;
    }
    return nil;
}

+(id) alloc{
    @synchronized([CLImageCache class])
    {
        NSAssert(sharedImageCache==nil, @"second singleton");
        sharedImageCache=[super alloc];
        return sharedImageCache;
    }
    return nil;
}

-(id) init
{
    self=[super init];
    if (self!=nil) {
        imgCache=[[NSCache alloc]init];
    }
    return self;
}

-(void) addImage:(NSString *)imageURL :(UIImage *)image
{
    [imgCache setObject:image forKey:imageURL];
}

-(NSString *) getImage:(NSString *)imageURL
{
    return [imgCache objectForKey:imageURL];
}

-(BOOL) doesExist:(NSString *)imageURL
{
    if ([imgCache objectForKey:imageURL]==nil) {
        return false;
    }
    return true;
}


@end
