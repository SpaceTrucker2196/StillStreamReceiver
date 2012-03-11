//
//  BackgroundImageManager.m
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 4/5/11.
//  Copyright 2011 ~river.io~. All rights reserved.
//

#import "BackgroundImageManager.h"


@implementation BackgroundImageManager

@synthesize bakImages;

-(id) init 
{
    
    bakImages = [[NSArray alloc] initWithArray:[self arrayOfBakImages]];
    return self;
}


-(NSMutableArray *) arrayOfBakImages 
{
    NSString *bundleDir = [[NSBundle mainBundle] bundlePath];
    NSFileManager *localFileManager=[[NSFileManager alloc] init];
    NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:bundleDir];
    NSMutableArray *pngFiles = [[[NSMutableArray alloc]init]autorelease];
    
    NSString *file;
    
    while ((file = [dirEnum nextObject])) 
    {
        if ([[file pathExtension] isEqualToString: @"png"]) {
            // process the document
            if ([[file substringToIndex:3] isEqualToString:@"bak"])
            {
                [pngFiles addObject:[bundleDir stringByAppendingPathComponent:file]];
                //NSLog(@"pngFile: %@",file); 
            }
        }
    }
    
    [localFileManager release];
    return pngFiles;
}

-(NSString *) nextImage
{
    int r = arc4random() % [bakImages count];
    return [bakImages objectAtIndex:r];
}



@end
