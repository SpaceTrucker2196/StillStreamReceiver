//
//  RecentTrackTableCellController.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecentTrackTableCell : UITableViewCell {
 
    IBOutlet UILabel *timeCode;
    IBOutlet UILabel *programInfo;
    IBOutlet UILabel *trackName;
    IBOutlet UILabel *trackInfo;
    
}

@property (nonatomic,retain) IBOutlet UILabel *timeCode;
@property (nonatomic,retain) IBOutlet UILabel *programInfo;
@property (nonatomic,retain) IBOutlet UILabel *trackName;
@property (nonatomic,retain) IBOutlet UILabel *trackInfo;
    
@end
