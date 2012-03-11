//
//  RecentsTableController.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecentsTableController : UITableViewController {
    
    IBOutlet UITableView * newsTable;
    
    NSMutableArray * tracks;
    NSXMLParser * rssParser;
    
    CGSize cellSize;
    UIActivityIndicatorView * activityIndicator;
    
    NSMutableDictionary * item;
    
    NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink;

}

@end
