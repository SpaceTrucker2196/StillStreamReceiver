//
//  StillStreamCurrentStatsJSONReader.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StillStreamCurrentStatsJSONReader : NSObject {
    
    NSDictionary *currentStats;
}

@property (nonatomic, retain) NSDictionary *currentStats;

-(id) initWithURLString:(NSString *)theURL;

@end
