//
//  Scenario.h
//  English4Kids
//
//  Created by Jeannine Struck on 5/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseView.h"

@class SceneView;
@class GridView;
@class GameBar;

@interface Scenario : BaseView {
	BOOL				animIsActive;		// indicates if a view animation is in progress
	GridView			*viewEvents;		// the event view of the controller that will capture all touch events
	SceneView			*viewActive;		// the active view containing the scene
	SceneView			*viewNext;			// will hold the view of the next desired scene to be transitioned
	GameBar				*viewGameBar;
	NSString			*noGameScene;
	NSString			*music;
	
	NSString	*_plist;
	
}

- (id) initWithFrame:(CGRect)frame loadPlist:(NSString *)plist;
- (void) onTap:(UITouch *) touch;
- (void) onDoubleTap:(UITouch *) touch;
- (void) hideButtons;

@end
