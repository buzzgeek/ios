//
//  ResourceManager.h
//  Test_Framework
//
//  Created by Joe Hogue on 4/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <Foundation/Foundation.h>
#import "GLTexture.h"
#import "GLFont.h"
@class ResourceManager;
@class English4KidsAppDelegate;

#define STORAGE_FILENAME		@"appstorage"
#define REGION_DEF_STARTDATE	@"20100101"
#define SCENE_MAIN_SCENE		@"mainScene"
#define SCENE_TAG_LANDSCAPE		@"landscape"
#define SCENE_TAG_BACK			@"back"
#define SCENE_TAG_IMAGE			@"image"
#define SCENE_TAG_REGIONS		@"regions"
#define SCENE_TAG_XOF			@"xof"
#define SCENE_TAG_YOF			@"yof"
#define REGION_TAG_NEXT			@"next"
#define REGION_TAG_IMAGE		@"image"
#define REGION_TAG_TILE			@"tile"
#define REGION_TAG_SOUND		@"sound"
#define REGION_TAG_POSITIONS	@"positions"
#define REGION_TAG_QUESTION		@"question"
#define REGION_TAG_QUESTSND		@"questSnd"
#define REGION_TAG_STARTDATE	@"startDate"
#define TAG_TYPE_DICT			@"dict"
#define TAG_TYPE_STRING			@"string"
#define SENARIO_NO_GAME_SCENE	@"noGameScene"
#define SENARIO_MUSIC			@"music"

#define	XOF_PT 0.5f
#define	YOF_PT 1.0f
#define	XOF_LS 1.0f
#define	YOF_LS 0.5f

//some helper methods.  These don't really belong in this class.
//returns the distance between two points.
CGFloat distsquared(CGPoint a, CGPoint b);
//returns a unit vector pointing from a to b.
CGPoint toward(CGPoint a, CGPoint b);

extern ResourceManager *g_ResManager; //paul <3's camel caps, hungarian notation, and underscores.

@interface ResourceManager : NSObject {
	//used to allocate and manage GLTexture instances.  Needs to be cleared in dealloc.
	NSMutableDictionary*	textures;
	
	//used to track sound allocations.  The actual sound data is buffered in SoundEngine; 'sounds' here only tracks the openAL ids of the loaded sounds.
	NSMutableDictionary*	sounds;

	NSMutableDictionary*	storage;
	BOOL storage_dirty;
	NSString* storage_path;
	GLFont* default_font;
	
	English4KidsAppDelegate *appDelegate;

	CGRect	bounds;
	CGFloat widthGrid;
	CGFloat heightGrid;
	int		xOffset;
	int		yOffset;

	BOOL	isLandscape;
	CGFloat gridXOffset;
	CGFloat gridYOffset;
	CGFloat gridXOffsetFactor;
	CGFloat gridYOffsetFactor;
	
	
}
@property (readonly, nonatomic) CGRect bounds;
@property (readonly, nonatomic) CGFloat widthGrid;
@property (readonly, nonatomic) CGFloat heightGrid;
@property (readonly, nonatomic) int xOffset;
@property (readonly, nonatomic) int yOffset;

@property (readwrite, nonatomic) BOOL isLandscape;
@property (readonly, nonatomic) BOOL isIPad;
@property (readwrite, nonatomic) CGFloat gridXOffset;
@property (readwrite, nonatomic) CGFloat gridYOffset;
@property (readwrite, nonatomic) CGFloat gridXOffsetFactor;
@property (readwrite, nonatomic) CGFloat gridYOffsetFactor;
@property (readonly, nonatomic)	CGFloat tgtXOffset;
@property (readonly, nonatomic) CGFloat tgtYOffset;

+ (ResourceManager *)instance;

- (void) shutdown;

//loads and buffers images as 2d opengles textures.
- (GLTexture*) getTexture: (NSString*) filename;
- (void) purgeTextures;
- (void) setupSound; //intialize the sound device.  Takes a non-trivial amount of time, and should be called during initialization.
- (UInt32) getSound:(NSString*) filename; //useful for preloading sounds; called automatically by playSound.  Buffers sounds.
- (void) purgeSounds;
- (void) stopSounds;
- (void) playSound:(NSString*) filename; //play a sound.  Loads and buffers the sound if needed.
-(void) playMusic:(NSString*)filename; //play and loop a music file in the background.  streams the file.
// buzz change
- (void) playMusic:(NSString*)filename setVolume:(Float32)vol; //play and loop a music file in the background.  streams the file.
- (void) setMusicVolume:(Float32)vol;
- (void) playSound:(NSString*)filename setVolume:(Float32)vol;
- (void) setSoundVolume:(Float32)vol;
- (void) stopMusic; //stop the music.  unloads the currently playing music file.
- (void) stopMusicAtEnd; //stop the music.  unloads the currently playing music file.
//useful for loading binary files that you include in the program bundle, such as game level data
- (NSData*) getBundleData:(NSString*) filename;
//for saving preferences or other game data.  This is stored in the documents directory, and may persist between app version updates.
- (BOOL) storeUserData:(id) data toFile:(NSString*) filename;
//for loading prefs or other data saved with storeData.  Returns nil if the file does not exist.
- (id) getUserData:(NSString*) filename;
- (BOOL) userDataExists:(NSString*) filename;
+ (NSString*) appendStorePath:(NSString*) filename;

- (GLFont *) defaultFont;
- (void) setDefaultFont: (GLFont *) newValue;

- (CGFloat) widthPcnt:(CGFloat) pcnt;
- (CGFloat) heightPcnt:(CGFloat) pcnt;

@end
