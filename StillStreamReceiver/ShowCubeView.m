//
//  ShowCubeView.m
//  StillStreamReceiver
//
//  Created by Jeff Kunzelman on 3/13/11.
//  Copyright 2011 ~river.io~. All rights reserved.
//

#import "ShowCubeView.h"


@implementation ShowCubeView

@synthesize showTime;
@synthesize showTitle;
@synthesize showDescription;
@synthesize imageV;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
    
   // NSLog(@"ShowCubeView did load \n");
    
    self.alpha = .55;
    self.backgroundColor = [UIColor clearColor];
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"showBak.png"]];
    self.imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"showBak.png"]];
    self.showTitle = [[UILabel alloc ]initWithFrame:CGRectMake(6, 2, 160, 20)];
    self.showTitle.backgroundColor = [UIColor clearColor];
    self.showTitle.textColor = [UIColor whiteColor];
    self.showTitle.font = [UIFont boldSystemFontOfSize:14];
    self.showTitle.text = @"Title Label";
    
    self.showTime = [[UILabel alloc ]initWithFrame:CGRectMake(6, 23, 165, 20)];
    self.showTime.backgroundColor = [UIColor clearColor];
    self.showTime.textColor = [UIColor whiteColor];
    self.showTime.font = [UIFont systemFontOfSize:14];
    self.showTime.text = @"Time Label";
    
    self.showDescription = [[UITextView alloc]initWithFrame:CGRectMake(0,42, 160, 95)];
    self.showDescription.textColor = [UIColor whiteColor];
    self.showDescription.backgroundColor = [UIColor clearColor];
    self.showDescription.editable = NO;
    //showDescription.userInteractionEnabled = NO;

    //showDescription.font = [UIFont systemFontSize:10];
    self.showDescription.text = @"Text";
    

    
    [self addSubview:imageV];
    [self addSubview:showTitle];
    [self addSubview:showTime];
    [self addSubview:showDescription];
    
    [imageV release];
    [showTitle release];
    [showTime release];
    [showDescription release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
