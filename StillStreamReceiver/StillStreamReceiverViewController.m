//
//  StillStreamReceiverViewController.m
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 2/27/11.
//  Copyright 2011 ~~river.io. All rights reserved.
//

#import "StillStreamReceiverViewController.h"
#import "RecentTrackTableCell.h"
#import "ShowCubeView.h"
#import "StillStreamUpcomingShowsReader.h"
#import "StillStreamCurrentStatsJSONReader.h"
#import "StillStreamPlaylistRSSReader.h"
#import "StillStreamReceiverAppDelegate.h"
#import "BackgroundImageManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation StillStreamReceiverViewController

@synthesize recentTrackTable;
@synthesize upComingShowsScrollView;
@synthesize volumeControlView;
@synthesize coverArtImg;
@synthesize chatView;
@synthesize pauseBtn;
@synthesize player;
@synthesize streamStatusImg;

//@synthesize upComingShowsScrollView
- (void)dealloc
{
    [trackList release];
    [upComingShowsScrollView release];
     [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    //define colors used in view
    onAirRed = UIColorFromRGB(0x660000);
    [onAirRed retain];
    
    
   // StillStreamReceiverAppDelegate *appDelegate = (StillStreamReceiverAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //set view state flag
    trackListMinimized = NO;
    chatViewMinimized = YES;
    chatView.hidden = YES;
    [self initChatView];    
    [self hideChatViewAnimation];
    
    //background 
    [self switchBackgroundImage];
    [NSTimer scheduledTimerWithTimeInterval:120.0 target:self selector:@selector(switchBackgroundImage) userInfo:nil repeats:YES];
   // [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(timerTrackListHide) userInfo:nil repeats:NO];
    
    
        
    trackList = [[NSMutableArray alloc]init];
    
    [self loadDataFeeds];
    [self updateCurrentStats];
    [self buildUpcomingShowsScrollView:showCalendarReader.shows];
    
    [NSTimer scheduledTimerWithTimeInterval:60.0
                                     target:self
                                   selector:@selector(updateCurrentStats)
                                   userInfo:nil
                                    repeats:YES];
    
    //start stream
    [self initalizeAndStartStream];
    
    //setup interface gestures
    [self setupGestures];
    
}

-(void) setupGestures
{    
    UISwipeGestureRecognizer *swipeGesture = nil;
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tapCycleInterface:)];
	swipeGesture.cancelsTouchesInView = NO; 
    swipeGesture.delaysTouchesEnded = NO; 
    swipeGesture.delegate = self;
	swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; // --page
	[self.view addGestureRecognizer:swipeGesture]; 
    [swipeGesture release];    
}

-(void) initalizeAndStartStream
{
    //[NSThread detachNewThreadSelector:@selector(flashStreamButton) toTarget:self withObject:nil];
    [self flashStreamButton];
    // implicitly initializes your audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
    if (setCategoryError) { /* handle the error condition */ }
    
    NSError *activationError = nil;
    [audioSession setActive:YES error:&activationError];
    if (activationError) { /* handle the error condition */ }
    
    player = [[MPMoviePlayerController alloc] initWithContentURL:
              [NSURL URLWithString:@"http://stillstream.com:8000/listen.pls"]];
    player.movieSourceType = MPMovieSourceTypeStreaming;
    player.allowsAirPlay = YES;
    player.view.hidden = YES;
    
    [player play]; 
    [self.view addSubview:player.view];
    
    volumeControlView.backgroundColor = [UIColor clearColor];  
    
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame:volumeControlView.bounds];
    myVolumeView.alpha = .60;
    [volumeControlView addSubview:myVolumeView];
    [myVolumeView release];
    
}

-(void)loadDataFeeds
{
    showCalendarReader = [[StillStreamUpcomingShowsReader alloc]initWithRSSURL:@"http://www.stillstream.com/rss/calendar.xml"];
    stillLStreamRSSPlaylist = [[StillStreamPlaylistRSSReader alloc]initWithRSSURL:@"http://stillstream.com/rss/playlist.xml"];
    [trackList addObjectsFromArray:stillLStreamRSSPlaylist.tracks];
}

-(void)initChatView
{
    NSLog(@"initing chatview");
    
    NSURL *url = [NSURL URLWithString:@"http://embed.mibbit.com/?server=irc.kacked.com&channel=%23stillstream&settings=aed30108d2b3b9326c0fa3e12ad6728f&nick=StillStream????"];
    
    //NSURL *url = [NSURL URLWithString:@"http://www.cnn.com/"];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
      
    [chatView loadRequest:requestObj];

}
-(void)updateCurrentStats
{
    //bug fix to eliminate duplicate tracks sometimes in track table
    [recentTrackTable reloadData];
    
    //stillStreamJSON = nil;
    stillStreamJSON = [[StillStreamCurrentStatsJSONReader alloc]initWithURLString:@"http://www.stillstream.com/api/currently.playing.json.php"];
    NSURL *coverURL = [NSURL URLWithString:[stillStreamJSON.currentStats objectForKey:@"releasecover"]];
    NSData *coverData = [[NSData alloc]initWithContentsOfURL:coverURL];
    UIImage *cover = [[UIImage alloc]initWithData:coverData];
    coverArtImg.image = cover;
    //[coverData release];
    //[cover release];
    
    playingProgramLbl.text = [NSString stringWithFormat:@"%@",[stillStreamJSON.currentStats objectForKey:@"showname"]];
    playingHostLbl.text = [NSString stringWithFormat:@"Host: %@",[stillStreamJSON.currentStats objectForKey:@"hostname"]];
    
    NSString *wallyIsDJ = [NSString stringWithFormat:@"StillStream All Ambient"];
    
    if (![wallyIsDJ isEqualToString:playingProgramLbl.text])
    {
        playingProgramLbl.textColor = onAirRed;
        playingHostLbl.textColor = onAirRed;
    }
        
    playingArtistLbl.text = [NSString stringWithFormat:@"Artist: %@",[stillStreamJSON.currentStats objectForKey:@"artistname"]];
    playingAlbumLbl.text = [NSString stringWithFormat:@"Album: %@",[stillStreamJSON.currentStats objectForKey:@"releasename"]];
    playingLabelLbl.text = [NSString stringWithFormat:@"Label: %@",[stillStreamJSON.currentStats objectForKey:@"labelname"]];

    playingTrackLbl.text = [NSString stringWithFormat:@"%@",[stillStreamJSON.currentStats objectForKey:@"trackname"]];
    playingReleasedLbl.text = [NSString stringWithFormat:@"Released: %@",[stillStreamJSON.currentStats objectForKey:@"year"]];
    listenerStatsLbl.text = [NSString stringWithFormat:@"You are one of the %@ current listeners in %@ countries on the planet earth.",[stillStreamJSON.currentStats objectForKey:@"listeners"],[stillStreamJSON.currentStats objectForKey:@"listenercountries"]];
    
    // Get a new Playlist
    StillStreamPlaylistRSSReader *updateStillLStreamRSSPlaylist = [[StillStreamPlaylistRSSReader alloc]initWithRSSURL:@"http://stillstream.com/rss/playlist.xml"];
    
    //Move to sets for set logic
    NSMutableArray *newTrackList = [[NSMutableArray alloc]init];
    [newTrackList addObjectsFromArray:updateStillLStreamRSSPlaylist.tracks];
    
    NSSet *existingItems = [NSSet setWithArray:trackList];
    NSSet *newItems = [NSSet setWithArray:newTrackList];
    NSMutableSet *addedItems = [NSMutableSet setWithSet:newItems];
    [addedItems minusSet:existingItems];
    NSLog(@"addedItems: %@",addedItems);
    
    //insert into tracklist at the begininning
    if (addedItems.count > 0)
    {
        for (NSDictionary *addedItem in addedItems) 
        {
    
            //NSMutableIndexSet *index = [NSMutableIndexSet indexSetWithIndex:0];                
            [trackList insertObject:addedItem atIndex:0];
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:FALSE];
            [trackList sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            [sortDescriptor release];
            
            NSMutableArray *insertIndexPath = [[NSMutableArray alloc]init];
            [insertIndexPath addObject:[NSIndexPath indexPathForRow:0  inSection:0]];
            
            [recentTrackTable insertRowsAtIndexPaths:insertIndexPath withRowAnimation:UITableViewRowAnimationTop];
            [insertIndexPath release];
            
        }
    }
    
//    [trackList addObjectsFromArray:addedItems];
    [self buildUpcomingShowsScrollView:showCalendarReader.shows];
    
    [updateStillLStreamRSSPlaylist release];
    [cover release];
    [newTrackList release];
    
}
#pragma mark - View button interaction 

- (IBAction)trackListBtn:(id)sender
{    

    if (!trackListMinimized) 
    {
        [self hideTrackList];
    }
    else
    {
        [self showTrackList];
    } 
}

- (void) tapCycleInterface:(UITapGestureRecognizer *)recognizer
{
    if (!trackListMinimized) 
    {
        [self hideTrackList];
    }
    else
    {
        [self showTrackList];
    }
}



- (void) timerTrackListHide

{
    if (!trackListMinimized) 
    {
        [self hideTrackList];
        trackListMinimized = YES;
    }
}

- (void) hideTrackList
{
   // CGRect playListAndShowsViewFrame = [playlistAndShowsView frame];
    //playListAndShowsViewFrame.origin.x += 768;
    
    //CGRect nowPlayingViewFrame = [nowPlayingView frame];
    //nowPlayingViewFrame.origin.y += 760;
    
    [UIView animateWithDuration:2.0 animations:
     ^{
         //[playlistAndShowsView setFrame:playListAndShowsViewFrame];
         [playlistAndShowsView setAlpha:(0.0)];
         [backgroundTextOverlay setAlpha:(0.0)];
     }
            completion:^(BOOL finished) {
            [UIView animateWithDuration:2.0 animations:
            ^{
                 //[nowPlayingView setFrame:nowPlayingViewFrame];
                [nowPlayingView setAlpha:(0.0)];
             }];
     }];
    
    trackListMinimized = YES;
    
}

- (void) showTrackList 
{
   // CGRect playListAndShowsViewFrame = [playlistAndShowsView frame];
    //playListAndShowsViewFrame.origin.x -= 768;
    
   // CGRect nowPlayingViewFrame = [nowPlayingView frame];
   // nowPlayingViewFrame.origin.y -= 760;
    
    [UIView animateWithDuration:2.0 animations:
     ^{
         //[nowPlayingView setFrame:nowPlayingViewFrame];
         [nowPlayingView setAlpha:(0.9)];
         [backgroundTextOverlay setAlpha:(0.9)];
     }
                     completion:^(BOOL finished) 
     {
         [UIView animateWithDuration:2.0 animations:
          ^{    
              [playlistAndShowsView setAlpha:(0.9)];
            //  [playlistAndShowsView setFrame:playListAndShowsViewFrame];
          }];
     }];
    
    //[NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(hideTrackList) userInfo:nil repeats:NO];
    trackListMinimized = NO;
}

- (IBAction)chatPageBtn:(id)sender
{
    if (trackListMinimized)
    {
        [self showTrackList];
    }
    if (chatViewMinimized)
    {
        [self showChatViewAnimation];
        chatViewMinimized = NO;
    }
    else
    {
        [self hideChatViewAnimation];
        chatViewMinimized = YES;
    }
}

- (IBAction)pauseStream:(id)sender
{

    switch (player.playbackState) {
 
        case MPMoviePlaybackStatePlaying:
            
            NSLog(@"Stop Stream");
            [player stop];
            
            CABasicAnimation *crossFadePause =[CABasicAnimation animationWithKeyPath:@"contents"];
            crossFadePause.duration =1.0;
            
            UIImage *newImage1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StillStreamDark" ofType:@"png"]];
            
            crossFadePause.fromValue = (id)streamStatusImg.image.CGImage;
            crossFadePause.toValue = (id)newImage1.CGImage;
            
            [streamStatusImg.layer addAnimation:crossFadePause forKey:@"animateContents"];
            
            
            //backGroundImage.image = newImage;
            
            streamStatusImg.image = newImage1;
            [newImage1 release];
            
            break;
        
        case MPMoviePlaybackStateStopped:  
            
            NSLog(@"Start Stream");
            [player play];
            
            CABasicAnimation *crossFadeStop =[CABasicAnimation animationWithKeyPath:@"contents"];
            crossFadeStop.duration =1.0;
            
            UIImage *newImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StillStreamLit" ofType:@"png"]];
            
            crossFadeStop.fromValue = (id)streamStatusImg.image.CGImage;
            crossFadeStop.toValue = (id)newImage2.CGImage;
            
            [streamStatusImg.layer addAnimation:crossFadeStop forKey:@"animateContents"];
            
            
            //backGroundImage.image = newImage;
            
            streamStatusImg.image = newImage2;
            [newImage2 release];
            
            
            break;
        default:
            break;
    }

}

-(void) flashStreamButton
{
  //  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
   // for (int y = 0; y < 3; y++)
   // {
        
        CABasicAnimation *crossFadePause =[CABasicAnimation animationWithKeyPath:@"contents"];
        crossFadePause.duration = 1.0;
        
        UIImage *newImage1 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StillStreamLit" ofType:@"png"]];
        
        crossFadePause.fromValue = (id)streamStatusImg.image.CGImage;
        crossFadePause.toValue = (id)newImage1.CGImage;
        
        [streamStatusImg.layer addAnimation:crossFadePause forKey:@"animateContents"];
        
        streamStatusImg.image = newImage1;
        [newImage1 release];
    /*
        sleep(.5); 
        NSLog(@"Flash");
        CABasicAnimation *crossFadeStop =[CABasicAnimation animationWithKeyPath:@"contents"];
        crossFadeStop.duration =.5;
        
        UIImage *newImage2 = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StillStreamLit" ofType:@"png"]];
        
        crossFadeStop.fromValue = (id)streamStatusImg.image.CGImage;
        crossFadeStop.toValue = (id)newImage2.CGImage;
        
        [streamStatusImg.layer addAnimation:crossFadeStop forKey:@"animateContents"];

        streamStatusImg.image = newImage2;
        [newImage2 release];
        sleep(.5); 
    }
    */
    //pool release];
        

}

-(void) hideChatViewAnimation
{
    CGRect chatViewFrame = [chatView frame];
    chatViewFrame.origin.y -= 1024;
    
    [UIWebView animateWithDuration:1.0 animations:
     ^{
         [chatView setFrame:chatViewFrame];
     }];            
}

-(void) showChatViewAnimation
{
    NSLog(@"show chat view");
    chatView.hidden = NO;
    CGRect chatViewFrame = [chatView frame];
    chatViewFrame.origin.y += 1024;
    
    [UIWebView animateWithDuration:1.0 animations:
     ^{
         [chatView setFrame:chatViewFrame];
     }];
}
#pragma mark view managment

-(void) switchBackgroundImage 
{
    BackgroundImageManager *bim = [[BackgroundImageManager alloc]init];
 
    CABasicAnimation *crossFade =[CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.duration =10.0;
    
    UIImage *newImage = [[UIImage alloc]initWithContentsOfFile:[bim nextImage]];
    
    crossFade.fromValue = (id)backGroundImageView.image.CGImage;
    crossFade.toValue = (id)newImage.CGImage;
    
    [backGroundImageView.layer addAnimation:crossFade forKey:@"animateContents"];
    
    
    //backGroundImage.image = newImage;
    
    backGroundImageView.image = newImage;
    [newImage release];
    [bim release];

}

- (void)buildUpcomingShowsScrollView:(NSArray *)shows
{
    
    CGSize scrollSize = CGSizeMake([shows count]*175, 142);    
    
    upComingShowsScrollView.contentSize = scrollSize;
    int pos = 0;
    
    for (id showDict in shows) {
        
        ShowCubeView *showViewCube = [[ShowCubeView alloc]initWithFrame:CGRectMake((pos*175), 0,165, 162)];
        
        NSString *showData = [[NSString alloc]initWithString:[showDict objectForKey:@"title"]];
       // NSLog(showData);
        NSString *titleString = [[NSString alloc]initWithString:[showData substringFromIndex:21]];
        NSString *currentShow = [[NSString alloc]initWithString:[stillStreamJSON.currentStats objectForKey:@"showname"]];
        NSString *trimedTitle = [titleString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
       // NSLog(@"title:%@E current:%@E",trimedTitle,currentShow);
        
        showViewCube.showTitle.text = titleString;

        showViewCube.showTime.text = [showData substringToIndex:16];
        showViewCube.showDescription.text = [self flattenHTML:[showDict objectForKey:@"description"]];
        //on air
        if ([trimedTitle isEqualToString:currentShow])
        {
            //showViewCube.backgroundColor = [UIColor redColor];
            UIImage *showBak = [UIImage imageNamed:@"showBakOnAir.png"];
            [showViewCube.imageV setImage:showBak];
          //  [showViewCube.imageV setNeedsDisplay];
        }
        
        [upComingShowsScrollView addSubview:showViewCube];
        [showViewCube release];
        [titleString release];
        [currentShow release];
        [showData release];
        pos++; 
    }    
    
}


- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL]; 
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text];
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]
                                               withString:@" "];
        
    } // while //
    
    return html;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [trackList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"RecentTrackTableCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
	if (cell == nil) {        
         NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"RecentTrackTableCell" owner:self options:nil];
		for (id currentObject in topLevelObjects )
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (RecentTrackTableCell *) currentObject;
				break;
            }
	}
	
	// Set up the cell
	//int trackIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	//[cell setText:[[tracks objectAtIndex: trackIndex] objectForKey: @"title"]];
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}
- (void)configureCell:(RecentTrackTableCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    
    int trackIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    NSString *trackData = [[NSString alloc]initWithString:(NSString *)[[trackList objectAtIndex: trackIndex] objectForKey: @"title"]];
    cell.trackName.text = [trackData substringFromIndex:21];
    cell.timeCode.text = [trackData substringToIndex:19];
    
   // NSString *htmlDescription = [[NSString alloc]initWithString:(NSString *)[[trackList objectAtIndex: trackIndex] objectForKey: @"description"]];
    //NSLog(@"%@",htmlDescription);
    
    //NSMutableDictionary *trackInfo = [self parsePlayList:htmlDescription];
    
    cell.programInfo.text = [self flattenHTML:[[trackList objectAtIndex: trackIndex]objectForKey:@"Program"]];
  
    NSString *wallyIsDJ = [NSString stringWithFormat:@"Program: StillStream All Ambient "];
    
    if (![wallyIsDJ isEqualToString:cell.programInfo.text])
    {
        
        cell.programInfo.backgroundColor = onAirRed;
        cell.timeCode.backgroundColor = onAirRed;
        
        
    }
    else
    {
        cell.programInfo.backgroundColor = [UIColor grayColor];
        cell.timeCode.backgroundColor = [UIColor grayColor];
    }
    
    cell.trackInfo.text = [NSString stringWithFormat:@"%@ %@ %@",
                           [self flattenHTML:[[trackList objectAtIndex: trackIndex]objectForKey:@"Album"]],
                           [self flattenHTML:[[trackList objectAtIndex: trackIndex] objectForKey:@"Year"]],
                           [self flattenHTML:[[trackList objectAtIndex: trackIndex] objectForKey:@"Label"]]
                           ];
    [trackData release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic
    
    //int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
    
    //NSString * trackInfoLink = [[trackList objectAtIndex: storyIndex] objectForKey: @"link"];
    
    // clean up the link - get rid of spaces, returns, and tabs...
    //trackInfoLink = [trackInfoLink stringByReplacingOccurrencesOfString:@" " withString:@""];
   // trackInfoLink = [trackInfoLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //trackInfoLink = [trackInfoLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
    
    
   // NSLog(@"link: %@", trackInfoLink);
    // open in Safari
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackInfoLink]];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}

@end
