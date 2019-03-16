//
//  BaseWindow.m
//  English4Kids
//
//  Created by Jeannine Struck on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseWindow.h"


@implementation BaseWindow

- (void)sendEvent:(UIEvent *)event
{
#ifdef DEBUG_ALL
	NSLog(@"sending event: %@", [event class]);
#endif
    [super sendEvent:event];
}

@end
