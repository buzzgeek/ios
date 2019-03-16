//
//  SceneView.h
//  English4Kids
//
//  Created by Jeannine Struck on 4/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@class GridView;
@class ActionView;
@class ActionLabel;

@interface SceneView : BaseView {
	BOOL		isValid;			// indicates if the view has been initialized
	NSDictionary *_sceneDict;		// the scene dict
	NSDictionary *_regionDict;		// the scene's region dict
	
	NSString	*_img;				// scene image's name
	UIImage		*img;				// scene's image
	UIImageView *imgView;			// and the related view
	ActionView	*actionView;		// TODO: currently not used but... 
	
	
	ActionView	*posPoints[3];		// the positive score imgs
	ActionView  *negPoints[3];		// the negative score imgs
	
	ActionLabel *questionLabel;		// the view containing the questions
	ActionLabel *actionLabel;		// the view containing the appearing words

	NSString	*_scene;			// the name of the scene
	NSString	*_nextScene;		// the name of the next scene
	NSString	*_prevScene;		// the name of the prev scene
	NSString	*_landscape;		// indicates if landscape mode
	NSString	*_xof;				// grid's x offset of scene
	NSString	*_yof;				// grid's y offset of scene
	NSString	*selectedRegion;	// the tapped-on region
		
	BOOL		forceSceneChange;	// indicates if a scene change is required (e.g. next scene)
	
	int			gameState;			// the current game's state
	NSString	*gameRegion;		// selected region in game mode
	int			scoreGood;			// the 'good' score
	int			scoreBad;			// the 'bad' score
	int			prevQuest;			// the index of the previous question
	NSTimer		*sndTrackTimer;		// timer used for music tracks
}

@property (nonatomic, readonly) BOOL isValid;
@property (nonatomic, readonly) NSString *_scene;
@property (nonatomic, readonly) NSString *_nextScene;
@property (nonatomic, readonly) NSString *_prevScene;
@property (nonatomic, readonly) NSString *_landscape;
@property (nonatomic, readonly) BOOL qnaGameAvailable;	

- (id) initWithFrame:(CGRect)frame loadPlist:(NSString *)plist withScene:(NSString*) scene;
- (id) initWithFrame:(CGRect)frame loadImage:(NSString *) image;
- (void) onTap:(UITouch *) touch;
- (void) onDoubleTap:(UITouch *) touch;
- (BOOL) posInRegions:(NSString *)position playSound:(BOOL)soundActive;
- (void) startGameModeInSecs:(Float32) secs;
- (void) resetScore;
	
@end
