//
//  BackgroundImageManager.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BackgroundImageManager : NSObject {
    
    NSArray *bakImages;

    
    
}

@property (nonatomic,retain) NSArray *bakImages;

-(NSMutableArray *) arrayOfBakImages;
-(NSString *) nextImage;

@end
