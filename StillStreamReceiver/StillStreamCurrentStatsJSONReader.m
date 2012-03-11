//
//  StillStreamCurrentStatsJSONReader.m
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/22/11.
//  Copyright 2011 ~~river.io~~. All rights reserved.
//

#import "StillStreamCurrentStatsJSONReader.h"
#import "JSON.h"

@implementation StillStreamCurrentStatsJSONReader
@synthesize currentStats;

-(id) initWithURLString:(NSString *)theURL
{
    NSURL *jsonURL = [NSURL URLWithString:theURL];
    NSData *jsonStatsData = [[NSData alloc]initWithContentsOfURL:jsonURL];
    
    NSString *jsonStatsString = [[NSString alloc] initWithData:jsonStatsData encoding:NSUTF8StringEncoding];
    
    currentStats = [jsonStatsString JSONValue];
    
    [jsonStatsData release]; 
    [jsonStatsString release];
    
   // NSLog(@" Data: %@",currentStats);
    
    return self;    
}

@end
