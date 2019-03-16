//
//  AboutView.m
//  English4Kids
//
//  Created by Jeannine Struck on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AboutView.h"


@implementation AboutView

@synthesize lblAbout;
@synthesize btnDone;
@synthesize viewImg;
@synthesize tvwAbout;
@synthesize toolbar;
@synthesize btnBack;
@synthesize webAbout;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
//		[self loadDocument:@"about.html" inView:self.webAbout];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void) loadDocument:(NSString*)documentName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webAbout loadRequest:request];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[lblAbout release];
	[tvwAbout release];
	[webAbout release];
	[btnDone release];
	[viewImg release];
	[btnBack release];
	[toolbar release];
    [super dealloc];
}


@end
