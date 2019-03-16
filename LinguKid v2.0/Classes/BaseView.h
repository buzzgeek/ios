//
//  BaseView.h
//  English4Kids
//
//  Created by Jeannine Struck on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define GRD_SIZE 32
//#define GRD_SIZE_HALF 16
//#define GRD_X_OFFSET 16
//#define GRD_Y_OFFSET 0

#define EVENT_ON_TAP @"onTap"
#define EVENT_ON_DOUBLETAP @"onDoubleTap"
#define EVENT_ON_CHANGE_SCENE @"onChangeScene"
#define EVENT_ON_BTN_PLAY @"onBtnPlay"
#define EVENT_ON_BTN_GAME @"onBtnGame"
#define EVENT_ON_BTN_BACK @"onBtnBack"
#define EVENT_ON_BTN_HOME @"onBtnHome"
#define EVENT_ON_BTN_GAMEBAR @"onBtnGameBar"
#define EVENT_ON_BTN_PREFS @"onBtnPrefs"
#define EVENT_ON_BTN_ABOUT @"onBtnAbout"
#define EVENT_ON_GAME_FINISHED @"onGameFinished"

@class English4KidsViewController;

@interface NotificationClient : NSObject
{
		id	parent;
		SEL selector;
}

- (void) setParent:(id)a_parent withSelector:(SEL)a_sel;
- (void) notify;
- (void) notifyWithObject:(id)data;


@end


@interface BaseView : UIView {
	CGPoint		pos;
	CGPoint		posOrig;
	//CGFloat		xOffset;
	//CGFloat		yOffset;

	NSMutableDictionary *notifyClientsDict;
	UIActivityIndicatorView *spinView;
}

- (id) initWithFrame:(CGRect)frame loadPlist:(NSString *)plist;
- (void) setNotificationDelegate:(id)delegate forEvent:(NSString *)event withSelector:(SEL)selector;
- (void) raiseEvent:(NSString *)event withObject:(id)data;
- (void) setPosition:(CGPoint) _pos;
- (CGPoint) getCoordRelToOrigin:(CGPoint)origin;
- (CGPoint) getCoordRelToOrigin:(CGPoint)origin forPosition:(CGPoint)position;
- (CGPoint) getLandscapeCoordRelToOrigin:(CGPoint)origin forPosition:(CGPoint)position;
- (void) showProgress:(BOOL)isActive;


@end
