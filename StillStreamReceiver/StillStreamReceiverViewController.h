//
//  StillStreamReceiverViewController.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 2/27/11.
//  Copyright 2011 ~river.io~. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StillStreamCurrentStatsJSONReader.h"
#import "StillStreamUpcomingShowsReader.h"
#import "StillStreamPlaylistRSSReader.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface StillStreamReceiverViewController : UIViewController <UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate>{
    
    IBOutlet UITableView *recentTrackTable;
    IBOutlet UIScrollView *upComingShowsScrollView;
    IBOutlet UIImageView *backgroundTextOverlay;
    IBOutlet UIImageView *backGroundImageView;
    IBOutlet UIWebView *chatView;
    
	IBOutlet UIView *volumeControlView;
    IBOutlet UIView *playlistAndShowsView;
    IBOutlet UIView *nowPlayingView;
    IBOutlet UIImageView *coverArtImg;
    IBOutlet UIImageView *streamStatusImg;
    
    IBOutlet UILabel *playingProgramLbl;
    IBOutlet UILabel *playingArtistLbl;
    IBOutlet UILabel *playingAlbumLbl;
    IBOutlet UILabel *playingLabelLbl;
    IBOutlet UILabel *playingHostLbl;
    IBOutlet UILabel *playingTrackLbl;
    IBOutlet UILabel *playingReleasedLbl;
    IBOutlet UILabel *listenerStatsLbl;
    
    IBOutlet UIButton *pauseBtn;
    
    MPMoviePlayerController *player;
    
    BOOL trackListMinimized;
    BOOL chatViewMinimized;
    
    UIColor *onAirRed;
    
	UIActivityIndicatorView *activityIndicator;
	
//	CGSize cellSize;
	
    NSMutableArray *trackList;
	
	StillStreamCurrentStatsJSONReader *stillStreamJSON; 
    StillStreamUpcomingShowsReader *showCalendarReader;
    StillStreamPlaylistRSSReader *stillLStreamRSSPlaylist;    
    
}

@property (nonatomic, retain) UITableView *recentTrackTable;
@property (nonatomic, retain) UIScrollView *upComingShowsScrollView;
@property (nonatomic, retain) IBOutlet UIView *volumeControlView;
@property (nonatomic, retain) IBOutlet UIImageView *coverArtImg;
@property (nonatomic, retain) IBOutlet UIImageView *streamStatusImg;
@property (nonatomic, retain) IBOutlet UIWebView *chatView;
@property (nonatomic, retain) IBOutlet UIButton *pauseBtn;
@property (nonatomic, retain) MPMoviePlayerController *player;


- (void)updateCurrentStats;
- (void)loadDataFeeds;
- (void)buildUpcomingShowsScrollView:(NSArray *)shows;
- (NSString *)flattenHTML:(NSString *)html;
- (IBAction)trackListBtn:(id)sender;
- (void) showTrackList; 
- (void) hideTrackList;
- (IBAction)chatPageBtn:(id)sender;
- (IBAction)pauseStream:(id)sender;
- (void) hideChatViewAnimation;
- (void) showChatViewAnimation;
- (void) initChatView;
- (void) switchBackgroundImage;
- (void) flashStreamButton;



@end
