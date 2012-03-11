//
//  RecentTrackTableCellController.m
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RecentTrackTableCell.h"


@implementation RecentTrackTableCell
@synthesize trackName;
@synthesize trackInfo;
@synthesize programInfo;
@synthesize timeCode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}



#pragma mark - View lifecycle





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
