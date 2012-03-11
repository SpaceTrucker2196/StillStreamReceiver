//
//  ShowCubeViewController.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowCubeViewController : UIView {
    
    IBOutlet UILabel *showTitle;
    IBOutlet UILabel *showTime;
    IBOutlet UITextView *showDescription;
}
@property (nonatomic, retain) IBOutlet UILabel *showTitle;
@property (nonatomic, retain) IBOutlet UILabel *showTime;
@property (nonatomic, retain) IBOutlet UITextView *showDescription;

@end
