//
//  BaseView.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "English4KidsAppDelegate.h"
#import "BaseView.h"
#import "ResourceManager.h"

@implementation NotificationClient

- (void) setParent:(id)a_parent withSelector:(SEL)a_sel {
	parent = a_parent;
	selector = a_sel;
}

- (void) notify {
	[parent performSelector:selector];
	
}

- (void) notifyWithObject:(id)data {
	[parent performSelector:selector withObject:data];
}
	
@end

@implementation BaseView

- (id) initWithFrame:(CGRect)frame loadPlist:(NSString *)plist {
	if ((self = [self initWithFrame:frame])) {
		// TODO
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		notifyClientsDict = [NSMutableDictionary new];

		// create the spin view
		spinView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0,0.0, g_ResManager.widthGrid, g_ResManager.widthGrid)];
		spinView.center = CGPointMake([g_ResManager widthPcnt:0.5], [g_ResManager heightPcnt:0.5]);
		spinView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
		[self.layer addSublayer:spinView.layer];
		[spinView release];
    }
    return self;
}

- (void) setNotificationDelegate:(id)delegate forEvent:(NSString *)event withSelector:(SEL)selector {
	
	NSMutableSet *clientSet = [notifyClientsDict objectForKey:(id)event];
	
	NotificationClient *client = [NotificationClient alloc];

	if (clientSet == nil) {
		clientSet = [NSMutableSet new];
		[client setParent:delegate withSelector:selector];
		[clientSet addObject:client];
		[client release];
		[notifyClientsDict setObject:clientSet forKey:(id)event];
		[clientSet release];
	} else {
		[client setParent:delegate withSelector:selector];
		[clientSet addObject:client];
		[client release];
	}
}

- (void) raiseEvent:(NSString *)event withObject:(id)data{
	NSMutableSet *clientSet = [notifyClientsDict objectForKey:(id)event];
	if (clientSet != nil) {
		for (NotificationClient *client in [clientSet allObjects]) {
			[client notifyWithObject:data];
		}
	}
}

//set the device cooridinates
- (void) setPosition:(CGPoint) _pos {
	posOrig = _pos;
	pos = _pos;

	pos.x = _pos.x - (CGFloat)((int)(_pos.x + g_ResManager.tgtXOffset) % (int)g_ResManager.widthGrid);
	pos.y = _pos.y - (CGFloat)((int)(_pos.y + g_ResManager.tgtYOffset) % (int)g_ResManager.heightGrid);
	// add offset for center
	pos.x += g_ResManager.widthGrid * .5;
	pos.y += g_ResManager.heightGrid * .5;
 }

- (CGPoint) getCoordRelToOrigin:(CGPoint)origin {
	CGPoint result;
	
	result.x = (pos.x - origin.x) / g_ResManager.widthGrid;
	result.y = (pos.y - origin.y) / g_ResManager.heightGrid;
	
	return result;
}

- (CGPoint) getCoordRelToOrigin:(CGPoint)origin forPosition:(CGPoint)position {
	CGPoint result;

	result.x = ((int)(position.x + g_ResManager.tgtXOffset) / (int)g_ResManager.widthGrid) - g_ResManager.xOffset;
	result.y = ((int)(position.y + g_ResManager.tgtYOffset) / (int)g_ResManager.heightGrid) - g_ResManager.yOffset;

	return result;
}

- (CGPoint) getLandscapeCoordRelToOrigin:(CGPoint)origin forPosition:(CGPoint)position {
	CGPoint result;

	result.x = g_ResManager.xOffset - ((int)(position.y + g_ResManager.tgtXOffset)/(int)g_ResManager.widthGrid);
	result.y = ((int)(position.x + g_ResManager.tgtYOffset)/(int)g_ResManager.heightGrid) - g_ResManager.yOffset;

#if DEBUG
	NSLog(@"%+f:%+f", result.x, result.y);
#endif
	
	return result;
}


- (void) showProgress:(BOOL)isActive{
	if (isActive) {
		[spinView startAnimating];
	} else {
		[spinView stopAnimating];
	}
}

- (void)dealloc {
	for (NSMutableSet *clientSet in [notifyClientsDict allValues] ) {
		[clientSet removeAllObjects];
	}
	
	[notifyClientsDict removeAllObjects];
	[notifyClientsDict release];
 
	[super dealloc];
}


@end
