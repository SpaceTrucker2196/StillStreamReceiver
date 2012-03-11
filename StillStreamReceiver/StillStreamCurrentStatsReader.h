//
//  StillStreamCurrentStatsReader.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StillStreamCurrentStatsReader : NSObject <NSXMLParserDelegate> {
    
    
    NSMutableArray *parsedData;
    NSXMLParser *contentPageParser;
    NSString * currentElement;
    NSMutableString * currentTitle, *currentDescription, *currentDiv;
    // a temporary item; added to the "shows" array one at a time, and cleared for the next one
	NSMutableDictionary * item;

}

@property (nonatomic,retain) NSMutableArray *parsedData;

-(id) initWithURL:(NSString *)statusPageURL;
-(void)parseHTMLPageAtURL:(NSString *)URL;
@end
