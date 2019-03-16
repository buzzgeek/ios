//
//  IntroView.m
//  English4Kids
//
//  Created by Jeannine Struck on 10/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IntroView.h"


@implementation IntroView

@synthesize viewImg;
@synthesize webIntro;
@synthesize toolbar;
@synthesize btnBack;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

 - (void) loadDocument:(NSString*)documentName 
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webIntro loadRequest:request];
	webIntro.scalesPageToFit = NO;
}

- (void) dealloc {
	[viewImg release];
	[webIntro release];
	[toolbar release];
	[btnBack release];
    [super dealloc];
}


@end
