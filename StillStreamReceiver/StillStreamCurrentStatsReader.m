//
//  StillStreamCurrentStatsReader.m
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StillStreamCurrentStatsReader.h"


@implementation StillStreamCurrentStatsReader

@synthesize parsedData;

-(id) initWithURL:(NSString *)statusPageURL
{
    [super init];
    [self parseHTMLPageAtURL:statusPageURL];
    
    return self;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{	
	NSLog(@"found file and started parsing");	
}

- (void)parseHTMLPageAtURL:(NSString *)URL
{	
	parsedData = [[NSMutableArray alloc] init];
	
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *contentURL = [NSURL URLWithString:URL];
	
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    contentPageParser = [[NSXMLParser alloc] initWithContentsOfURL:contentURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [contentPageParser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [contentPageParser setShouldProcessNamespaces:NO];
    [contentPageParser setShouldReportNamespacePrefixes:NO];
    [contentPageParser setShouldResolveExternalEntities:NO];
	
    [contentPageParser parse];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download upcoming show feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    //NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"div"]) 
    {
		
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"div"]) {
        NSLog(@"adding content: %@", currentDiv);
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
		[currentDiv appendString:string];
	
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	NSLog(@"all done!");
	NSLog(@"shows array has %d items", [parsedData count]);
}


@end
