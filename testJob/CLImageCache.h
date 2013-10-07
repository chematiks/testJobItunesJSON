//
//  CLImageCache.h
//  testJob
//
//  Created by Администратор on 10/6/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLImageCache : NSObject

@property (nonatomic,retain) NSCache * imgCache;

+(CLImageCache *) sharedImageCache;
-(void) addImage:(NSString *)imageURL :(UIImage *) image;
-(UIImage *) getImage:(NSString *)imageURL;
-(BOOL) doesExist:(NSString *) imageURL;


@end
