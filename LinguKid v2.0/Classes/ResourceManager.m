//
//  ResourceManager.m
//  Test_Framework
//
//  Created by Joe Hogue on 4/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ResourceManager.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
#import "English4KidsAppDelegate.h"
#import "SoundEngine.h"

const int		X_OFFSET	= 5;	// x offset of grid's origin (plist) 
const int		Y_OFFSET	= 7;	// y offset of grid's origin (plist)
const CGFloat	X_TOT_NUM	= 10.0;	//
const CGFloat	Y_TOT_NUM	= 15.0;	

/*
 private static int grdOffsetX = (int)(GRID_XSIZE * XOF_PT);
 private static int grdOffsetY = (int)(GRID_YSIZE * YOF_PT);
 private static double grdOffsetXfactor = XOF_PT;
 private static double grdOffsetYfactor = YOF_PT;
 */


//sound stuff leaks memory in the simulator, which is distracting when looking for real leaks.  use this to hack out SoundEngine calls.
#define DEBUG_SOUND_ENABLED true

ResourceManager *g_ResManager;

@implementation ResourceManager

@synthesize isLandscape;
@synthesize xOffset;
@synthesize yOffset;
@synthesize gridXOffset;
@synthesize gridYOffset;


- (BOOL) isIPad {
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES; 
    else
        return NO; 

#endif
#endif
	return NO;
}

- (CGFloat) gridXOffsetFactor {
	return gridXOffsetFactor;
}

- (CGFloat) gridYOffsetFactor {
	return gridYOffsetFactor;
}

- (void) setGridXOffsetFactor:(CGFloat)value {
	if (value > 1.0) {
		value = 1.0;
	}
	if (value < 0.0) {
		value = 0.0;
	}
	gridXOffsetFactor = value;
	gridXOffset = self.widthGrid * value;
}

- (void) setGridYOffsetFactor:(CGFloat)value {
	if (value > 1.0) {
		value = 1.0;
	}
	if (value < 0.0) {
		value = 0.0;
	}
	gridYOffsetFactor = value;
	gridYOffset = self.heightGrid * value;
}

- (CGFloat) tgtXOffset {
	CGFloat ret = gridXOffset <= 0.01 ? self.widthGrid : (CGFloat)((int)(self.widthGrid - self.gridXOffset) % (int)self.widthGrid);
	return ret;
}

- (CGFloat) tgtYOffset {
	CGFloat ret = gridYOffset <= 0.01 ? self.heightGrid : (CGFloat)((int)(self.heightGrid - self.gridYOffset) % (int)self.heightGrid);
	return ret;
}

- (CGRect) bounds {
	CGRect res = [[[UIApplication sharedApplication] keyWindow] bounds];
#ifdef DEBUG_ALL
	NSLog(@"bounds (x:%f,y;%f) (w:%f,h:%f)", res.origin.x, res.origin.y, res.size.width, res.size.height);
#endif
	return res;
}

- (CGFloat) widthGrid {
	if(widthGrid <= 0.1)
		widthGrid = [self bounds].size.width / X_TOT_NUM;

	return widthGrid;
}

- (CGFloat) heightGrid {
	if (heightGrid <= 0.1) 
		heightGrid = [self bounds].size.height / Y_TOT_NUM;

	return heightGrid;
}

- (CGFloat) widthPcnt:(CGFloat) pcnt {
	CGFloat res = [self bounds].size.width * pcnt; 
	return res;
}

- (CGFloat) heightPcnt:(CGFloat) pcnt {
	CGFloat res = [self bounds].size.height * pcnt; 
	return res;
}

//initialize is called automatically before the class gets any other message, per from http://stackoverflow.com/questions/145154/what-does-your-objective-c-singleton-look-like
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        g_ResManager = [[ResourceManager alloc] init];
    }
}

+ (ResourceManager *)instance
{
	return(g_ResManager);
}

- (ResourceManager*) init
{
	if(self = [super init]) {
		appDelegate = [[UIApplication sharedApplication]delegate];
		textures = [[NSMutableDictionary dictionary] retain];
		sounds = [[NSMutableDictionary dictionary] retain];
		[self setupSound];
	
		storage_path = [[ResourceManager appendStorePath:STORAGE_FILENAME] retain];
		storage_dirty = FALSE;
		storage = [[NSMutableDictionary alloc] init];
		[storage setDictionary:[NSDictionary dictionaryWithContentsOfFile:storage_path]];
		if(storage == nil){
			//NSLog(@"creating empty storage.");
			storage = [[NSMutableDictionary alloc] init];
			storage_dirty = TRUE;
		}

		// calculate frequently required data
		widthGrid = 0.0;
		heightGrid = 0.0;
	
		isLandscape = NO;
		xOffset = X_OFFSET;
		yOffset = Y_OFFSET;
		self.gridXOffsetFactor = XOF_PT;
		self.gridYOffsetFactor = YOF_PT;
		
	}
	return self;
}

- (void) shutdown {
	[self purgeSounds];
	[self purgeTextures];
	if(DEBUG_SOUND_ENABLED)
		SoundEngine_Teardown();
	if(storage_dirty){
		[storage writeToFile:storage_path atomically:YES];
	}
	[storage_path release];
	[storage release];
	[default_font release];
}

#pragma mark image cache

//creates and returns a texture for the given image file.  The texture is buffered,
//so the first call to getTexture will create the texture, and subsequent calls will
//simply return the same texture object.
//todo: catch allocation failures here, purge enough textures to make it work, and retry loading the texture.
- (GLTexture*) getTexture: (NSString*) filename
{
	//lookup is .00001 (seconds) to .00003 on simulator, and consistently .00003 on device.  tested average over 1000 cycles, compared against using a local cache (e.g. not calling gettexture).  If you are drawing over a thousand instances per frame, you should use a local cache.
	GLTexture* retval = [textures valueForKey:filename];
	if(retval != nil)
		return retval;

	//load time seems to correlate with image complexity with png files.  Images loaded later in the app were quicker as well.  Ranged 0.075 (seconds) to 0.288 in test app.  Tested once per image, on device, with varying load order.
	NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	UIImage *loadImage = [UIImage imageWithContentsOfFile:fullpath];
	retval = [[GLTexture alloc] initWithImage: loadImage];
	[textures setValue:[retval autorelease] forKey:filename];
	return retval;
}

- (void) purgeTextures
{
	/*NSEnumerator* e = [textures objectEnumerator];
	GLTexture* tex;
	while(tex = [e nextObject]){
		[tex release];
	}*/ //if we didn't autorelease the textures (in getTexture), we would have to do something like this code block.
	[textures removeAllObjects];
}

#pragma mark sound code

//load and buffer the specified sound.  File should preferably be in core-audio format (.caf).  Not sure if other formats work, todo: test.
-(UInt32) getSound:(NSString*)filename{
	NSNumber* retval = [sounds valueForKey:filename];
	if(retval != nil) {
		return [retval intValue];
	}
	NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	UInt32 loadedsound;
	SoundEngine_LoadEffect([fullpath UTF8String], &loadedsound);
	[sounds setValue:[NSNumber numberWithInt:loadedsound] forKey:filename];
#ifdef DEBUG_ALL 
	NSLog(@"loaded %@", filename);
#endif
	return loadedsound;
}

- (void) purgeSounds
{
	[self stopSounds];
	NSEnumerator* e = [sounds objectEnumerator];
	NSNumber* snd;
	while(snd = [e nextObject]){
		SoundEngine_UnloadEffect([snd intValue]);
	}
	[sounds removeAllObjects];
}

- (void) stopSounds
{
	NSEnumerator* e = [sounds objectEnumerator];
	NSNumber* snd;
	while(snd = [e nextObject]){
		SoundEngine_StopEffect([snd intValue], YES);
	}
}

//play specified file.  File is loaded and buffered as necessary.
-(void) playSound:(NSString*)filename{
	//if(!soundOn)return;
	if(DEBUG_SOUND_ENABLED)
		SoundEngine_StartEffect([self getSound:filename]);
}

//works with mp3 files.
//works with caf files.
//works with wav files.
//does not work with midi files.
-(void) playMusic:(NSString*)filename{	
	NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	SoundEngine_StopBackgroundMusic(FALSE);
	SoundEngine_UnloadBackgroundMusicTrack();
	SoundEngine_LoadBackgroundMusicTrack([fullpath UTF8String], false, false);
	SoundEngine_StartBackgroundMusic();
}

//works with mp3 files.
//works with caf files.
//works with wav files.
//does not work with midi files.
-(void) playMusic:(NSString*)filename setVolume:(Float32)vol{	
	NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	SoundEngine_StopBackgroundMusic(FALSE);
	SoundEngine_UnloadBackgroundMusicTrack();
	SoundEngine_LoadBackgroundMusicTrack([fullpath UTF8String], false, false);
	//buzz changes
	SoundEngine_SetBackgroundMusicVolume(vol);
	
	SoundEngine_StartBackgroundMusic();
}

-(void) setMusicVolume:(Float32)vol {
	SoundEngine_SetBackgroundMusicVolume(vol);
}

//play specified file.  File is loaded and buffered as necessary.
-(void) playSound:(NSString*)filename setVolume:(Float32)vol{
	if(DEBUG_SOUND_ENABLED) {
		SoundEngine_SetEffectsVolume(vol);
		SoundEngine_StartEffect([self getSound:filename]);
	}
}

-(void) setSoundVolume:(Float32)vol {
	SoundEngine_SetEffectsVolume(vol);
}

-(void) stopMusic {
	SoundEngine_StopBackgroundMusic(FALSE);
	SoundEngine_UnloadBackgroundMusicTrack();
}

-(void) stopMusicAtEnd {
	SoundEngine_StopBackgroundMusic(TRUE);
	//SoundEngine_UnloadBackgroundMusicTrack();
}

-(void) setupSound{
	if(DEBUG_SOUND_ENABLED){
		SoundEngine_Initialize(44100);
		SoundEngine_SetListenerPosition(0.0, 0.0, 1.0);	
	}
}

//For loading data files from your application bundle.  You should retain and release the return value that you get from getData if you plan on keeping it around.
-(NSData*) getBundleData:(NSString*) filename{
	NSString *fullpath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	NSData* data = [NSData dataWithContentsOfFile:fullpath];
	return data;
}


#pragma mark data storage

//for saving preferences or other game data.  This is stored in the documents directory, and may persist between app version updates.
- (BOOL) storeUserData:(id) data toFile:(NSString*) filename {
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:filename];
	return YES;
}

//for loading prefs or other data saved with storeData.
- (id) getUserData:(NSString*) filename {
	return [[NSUserDefaults standardUserDefaults] objectForKey:filename];
}

- (BOOL) userDataExists:(NSString*) filename{
	return [self getUserData:filename] != nil;
}

#pragma mark default font helpers

- (GLFont *) defaultFont {
	if(default_font == nil){
		default_font = [[GLFont alloc] initWithString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,.?!@/: " 
			fontName:@"Helvetica" 
			fontSize:24.0f
			strokeWidth:1.0f
			fillColor:[UIColor whiteColor]
			strokeColor:[UIColor grayColor]];
	}
	return default_font;
}

- (void) setDefaultFont: (GLFont *) newValue {
	[default_font autorelease];
	default_font = [newValue retain];
}

#pragma mark unsupported features and generally abusive functions.

+ (NSString*) appendStorePath:(NSString*) filename
{
	//find the user's document directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	//there should be only one directory returned
    NSString *documentsDirectory = [paths objectAtIndex:0];
	//make the full path name.  stringByAppendingPathComponent adds slashies as needed.
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
	return filePath;	
	
	//return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename]; //will read but not write on simulator or device. 
	//return filename; //doing this saves to '/' on the simulator.  does not save on device.
}

+ (void) scrapeData {
	//so there is a bunch of unexpected interesting stuff in here, including language settings and the user's phone number.
	//stuff that we add in storeUserData is not accessible to other apps, so it is a local storage.  The global ones are something else.
#ifdef DEBUG_ALL
	NSDictionary* datas = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
	NSArray* keys = [datas allKeys];
	for(int i=0;i<keys.count;i++){
		NSLog(@"key %@ val %@", [keys objectAtIndex:i], [datas objectForKey:[keys objectAtIndex:i]]);
	}
#endif
}

@end