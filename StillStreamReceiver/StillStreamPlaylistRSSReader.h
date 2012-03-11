//
//  StillStreamPlaylistRSSReader.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StillStreamPlaylistRSSReader : NSObject <NSXMLParserDelegate> {

    NSXMLParser *rssParser;
	
	NSMutableArray *tracks;
    
    // a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;
    
}
@property (nonatomic,retain) NSMutableArray *tracks;

- (void)parseXMLFileAtURL:(NSString *)URL;
- (NSMutableDictionary *)parseDescription:(NSString *)html;

@end

