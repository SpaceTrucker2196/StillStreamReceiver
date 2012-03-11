//
//  ShowCubeView.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowCubeView : UIView {
    
     UILabel *showTitle;
     UILabel *showTime;
     UITextView *showDescription;
    UIImageView *imageV;

}

@property (nonatomic, retain) UILabel *showTitle;
@property (nonatomic, retain) UILabel *showTime;
@property (nonatomic, retain) UITextView *showDescription;
@property (nonatomic, retain) UIImageView *imageV;


@end
