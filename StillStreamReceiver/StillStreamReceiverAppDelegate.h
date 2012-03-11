//
//  StillStreamReceiverAppDelegate.h
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class StillStreamReceiverViewController;
//@class ChatViewDelegate;

@interface StillStreamReceiverAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet StillStreamReceiverViewController *viewController;
//@property (nonatomic, retain) ChatViewDelegate *chatViewDelegate;

@end
