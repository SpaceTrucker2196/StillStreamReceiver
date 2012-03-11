//
//  StillStreamPlaylistRSSReader.m
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StillStreamPlaylistRSSReader.h"


@implementation StillStreamPlaylistRSSReader
@synthesize tracks;

- (id) initWithRSSURL:(NSString *)rssURL
{
    [self parseXMLFileAtURL:rssURL];
    
    return self;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{	
//	NSLog(@"found file and started parsing");
	
}

- (void)parseXMLFileAtURL:(NSString *)URL
{	
	tracks = [[NSMutableArray alloc] init];
	
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL URLWithString:URL];
	
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [rssParser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];	
}



- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download feed from web site (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	//UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict 
{			
   // NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"item"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"title"];
		[item setObject:currentLink forKey:@"link"];
		//[item setObject:currentSummary forKey:@"description"];
		[item setObject:currentDate forKey:@"date"];
        [item addEntriesFromDictionary:[self parseDescription:currentSummary]];
		[tracks addObject:item];
		//NSLog(@"adding track: %@",item);
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"title"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"link"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"description"]) {
		[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"pubDate"]) {
		[currentDate appendString:string];
	}
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	//NSLog(@"all done!");
	//NSLog(@"tracklist array has %d items", [tracks count]);
}

- (NSMutableDictionary *)parseDescription:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    NSMutableDictionary *elements = [[[NSMutableDictionary alloc]init]autorelease];
    
    
    theScanner = [NSScanner scannerWithString:html];
    
    [theScanner scanUpToString:@"Host:" intoString:&text];
    [elements setObject:text forKey:@"Program"];
    text = @" ";
    
    [theScanner scanUpToString:@"Artist:" intoString:&text];
    [elements setObject:text forKey:@"Host"];
    text = @" ";
    
    [theScanner scanUpToString:@"Track:" intoString:&text];
    [elements setObject:text forKey:@"Artist"];
    text = @" ";
    
    [theScanner scanUpToString:@"Album:" intoString:&text];
    [elements setObject:text forKey:@"Track"];
    text = @" ";
    
    [theScanner scanUpToString:@"Year:" intoString:&text];
    [elements setObject:text forKey:@"Album"];
    text = @" ";
    
    [theScanner scanUpToString:@"Label" intoString:&text];
    [elements setObject:text forKey:@"Year"];
    text = @" ";
    
    [theScanner scanUpToString:@"</a>" intoString:&text];
    [elements setObject:text forKey:@"Label"];
    text = @" ";
    
    return elements;
}


@end
