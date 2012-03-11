//
//  StillStreamUpcomingShowsReader.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/13/11.
//  Copyright 2011 ~River.io~. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StillStreamUpcomingShowsReader : NSObject <NSXMLParserDelegate>{
    
    NSMutableArray *shows;
    NSXMLParser *rssParser;
    NSString * currentElement;
    NSMutableString * currentTitle, *currentDescription, *currentLink;
    // a temporary item; added to the "shows" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
}

@property (nonatomic,retain) NSMutableArray *shows;

-(id) initWithRSSURL:(NSString *)rssURL;
- (void)parseXMLFileAtURL:(NSString *)URL;

@end
