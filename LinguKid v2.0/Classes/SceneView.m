//
//  SceneView.m
//  English4Kids
//
//  Created by Jeannine Struck on 4/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <math.h>
#import <QuartzCore/QuartzCore.h>
#import "SceneView.h"
#import "English4KidsAppDelegate.h"
#import "GridView.h"
#import "ActionView.h"
#import "ActionLabel.h"
#import "ResourceManager.h"

#define GAME_STATE_INACTIVE	0
#define GAME_STATE_ACTIVE	1
#define GAME_STATE_WIN		2
#define GAME_STATE_LOSE		4
#define GAME_STATE_IDLE		8
#define GAME_STATE_WAIT		16

#define TIMER_DELAY 2.0


@interface SceneView (private)

- (BOOL) initSceneDict:(NSString*)plist withScene:(NSString *)scene;
- (void) preloadSounds;
- (void) processGameStates:(NSString*)pos;
- (void) askQuestion;
- (void) showRegionInfoDelayed:(NSTimer*)tmr;
- (void) askQuestionDelayed:(NSTimer*)tmr;
- (void) playSoundtrack:(NSTimer*)tmr;

@end


@implementation SceneView

@synthesize isValid;
@synthesize _scene;
@synthesize _nextScene;
@synthesize _prevScene;
@synthesize _landscape;

- (id) initWithFrame:(CGRect)frame loadPlist:(NSString *)plist withScene:(NSString*) scene {
	//_scene = [NSString stringWithString:scene];
	_scene = [scene copy];
	isValid = [self initSceneDict:plist withScene:scene];
	if (isValid) {
		[self preloadSounds];
		sndTrackTimer = NULL;
	}
	return [self initWithFrame:frame loadImage:_img];
}

- (id) initWithFrame:(CGRect)frame loadImage:(NSString*) image {
	
    if ((self = [super initWithFrame:frame])) {
		//English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
		//volSound = delegate.volSound;
		
		CGRect contentSize = frame;

		if(g_ResManager.isLandscape) {
			CGAffineTransform transform = self.transform;
			CGPoint center = CGPointMake(frame.size.height / 2.0, frame.size.width / 2.0);
			
			// Set the center point of the view to the center point of the window's content area.
			self.center = center;
			
			// Rotate the view 90 degrees around its new center point.
			transform = CGAffineTransformRotate(transform, (M_PI / 2.0));
			self.transform = transform;
			contentSize = CGRectMake(frame.origin.x, frame.origin.y, frame.size.height, frame.size.width);
		}


		self.frame = frame;
		
		// create & add the image layer
		img	= [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:image ofType:@"png"]];
		imgView = [[UIImageView alloc] initWithImage:img];
		[img release];
		imgView.frame = contentSize;
		[self.layer addSublayer: imgView.layer];
		
		actionView = [[ActionView alloc] initWithFrame:CGRectMake(0.0, 0.0, 128.0, 32.0)];
		actionView.hidden = YES;
		[self.layer addSublayer:actionView.layer];
		
		for(int i=0; i < 3; ++i){
			if(g_ResManager.isLandscape) {
				posPoints[i] = [[ActionView alloc] initWithFrame:CGRectMake(g_ResManager.heightGrid + (g_ResManager.widthGrid * i), 0.0, g_ResManager.widthGrid, g_ResManager.heightGrid)];
				negPoints[i] = [[ActionView alloc] initWithFrame:CGRectMake([g_ResManager heightPcnt:0.7] + (g_ResManager.widthGrid * i), 0.0, g_ResManager.widthGrid, g_ResManager.heightGrid)];
			} else {
				posPoints[i] = [[ActionView alloc] initWithFrame:CGRectMake(g_ResManager.widthGrid + (g_ResManager.widthGrid * i), 0.0, g_ResManager.widthGrid, g_ResManager.heightGrid)];
				negPoints[i] = [[ActionView alloc] initWithFrame:CGRectMake([g_ResManager widthPcnt:0.7] + (g_ResManager.widthGrid * i), 0.0, g_ResManager.widthGrid, g_ResManager.heightGrid)];
			}
			[posPoints[i] loadImage:@"smiley"];
			[negPoints[i] loadImage:@"sady"];
			posPoints[i].hidden = YES;
			negPoints[i].hidden = YES;
			posPoints[i].snd = @"ding.caf";
			negPoints[i].snd = @"doing.caf";
			
			[self.layer addSublayer:posPoints[i].layer];
			[self.layer addSublayer:negPoints[i].layer];
			
		}
		
		if(g_ResManager.isLandscape) {
			actionLabel = [[ActionLabel alloc] initWithFrame:CGRectMake(0.0, [g_ResManager widthPcnt:0.9], g_ResManager.bounds.size.height, g_ResManager.widthGrid)];
			questionLabel = [[ActionLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, g_ResManager.bounds.size.height, g_ResManager.widthGrid)];
		} else {
			actionLabel = [[ActionLabel alloc] initWithFrame:CGRectMake(0.0, [g_ResManager heightPcnt:0.9], g_ResManager.bounds.size.width, g_ResManager.heightGrid)];
			questionLabel = [[ActionLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, g_ResManager.bounds.size.width, g_ResManager.heightGrid)];
		}
	
		actionLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
		actionLabel.font = [UIFont fontWithName:@"arial" size:32.0];
		actionLabel.textAlignment = UITextAlignmentCenter;
		actionLabel.hidden = YES;
		[self.layer addSublayer:actionLabel.layer];

		questionLabel.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
		questionLabel.font = [UIFont fontWithName:@"arial" size:32.0];
		questionLabel.textAlignment = UITextAlignmentCenter;
		questionLabel.hidden = YES;
		[self.layer addSublayer:questionLabel.layer];
		
		forceSceneChange = NO;
		gameState = GAME_STATE_INACTIVE;
		gameRegion = [NSString stringWithString:@""];
		selectedRegion = [NSString stringWithString:@""];
		scoreGood = 0;
		scoreBad = 0;
		
		
		srandom(time(nil));
    }
    return self;
}

- (BOOL) initSceneDict:(NSString *)plist withScene:(NSString *)scene {
	NSData		*pData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plist ofType:@"plist"]];
	NSString	*error;
	NSPropertyListFormat format;
	
	_sceneDict = [NSPropertyListSerialization 
				 propertyListFromData:pData 
				 mutabilityOption:NSPropertyListImmutable 
				 format:&format 
				 errorDescription:&error];
	if (error != nil) {
#ifdef DEBUG_ALL
		NSLog(@"error - %@", error);
#endif
		return NO;
	}
	_sceneDict = [[_sceneDict objectForKey:scene]retain];
	_img = [_sceneDict objectForKey:SCENE_TAG_IMAGE];
	_regionDict = [[_sceneDict objectForKey:SCENE_TAG_REGIONS] retain];
	_prevScene = [[_sceneDict objectForKey:SCENE_TAG_BACK] retain];
	_landscape = [[_sceneDict objectForKey:SCENE_TAG_LANDSCAPE] retain];
	_xof = [[_sceneDict objectForKey:SCENE_TAG_XOF] retain];
	_yof = [[_sceneDict objectForKey:SCENE_TAG_YOF] retain];
	
	g_ResManager.isLandscape = [_landscape isEqualToString:@"1"];
	CGFloat xof = XOF_PT;
	CGFloat yof = YOF_PT;
	
	if ([_xof length] > 0 && [_yof length] > 0) {
		xof = g_ResManager.isLandscape ? [_yof floatValue]: [_xof floatValue];
		yof = g_ResManager.isLandscape ? [_xof floatValue]: [_yof floatValue];
	}

	g_ResManager.gridXOffsetFactor = xof;
	g_ResManager.gridYOffsetFactor = yof;

	
	return YES;
}

- (BOOL) qnaGameAvailable {
	return ([_regionDict count] > 1);
}

- (void) preloadSounds {
	for (NSDictionary *region in [_regionDict allValues]){
		NSString *sound = [region objectForKey:REGION_TAG_SOUND];
		if ([sound length] > 0) {
			[g_ResManager getSound:sound];
		}
	}
}

- (void) showImg:(NSString *)image playSound:(NSString *)snd  playSound:(BOOL)soundActive {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[actionView loadImage:image];
	if (soundActive && snd.length > 0) {
		[g_ResManager playSound:snd setVolume:delegate.volSound];
	}
	actionView.center = posOrig;
	actionView.hidden = NO;
	[actionView startAnimationIsHidden:NO];
}

- (void) showLabel:(NSString *)txtLabel playSound:(NSString *)snd  playSound:(BOOL)soundActive textColor:(UIColor *)color {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if (soundActive && snd.length > 0) {
		NSRange rng = [snd rangeOfString:@".caf"]; 
		if ( rng.location != NSNotFound ) {
			[g_ResManager playSound:snd setVolume:delegate.volSound];
		} else {
			// note - we're using sound volume here
			[g_ResManager playMusic:snd setVolume:delegate.volSound];
			[g_ResManager stopMusicAtEnd];
			//TODO: implement code to return to original music (or reset on changing scene)
			// start on timer
			if (sndTrackTimer != NULL) {
				[sndTrackTimer invalidate];
			}
			sndTrackTimer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(playSoundtrack:) userInfo:nil repeats:NO];

		}

	}
	if ([txtLabel length] > 0 && delegate.showWords) {
		actionLabel.textColor = color;
		actionLabel.text = txtLabel;
		actionLabel.hidden = NO;
		[actionLabel startAnimation];
	}
}

- (void) playSoundtrack:(NSTimer *)tmr {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	//note - we're using music volume here
	[g_ResManager playMusic:@"English4Kids.mp3" setVolume:delegate.volMusic];
	sndTrackTimer = NULL;
}

- (void) showQuestion:(NSString *)txtLabel playSound:(NSString *)snd  playSound:(BOOL)soundActive {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if (soundActive && snd.length > 0) {
		[g_ResManager playSound:snd setVolume:delegate.volSound];
	}
	if (delegate.showWords) {
		questionLabel.text = txtLabel;
		questionLabel.hidden = NO;
		[questionLabel startAnimation];
	}
}

- (BOOL)pos:(NSString *)position inRegion:(NSDictionary *)region {
	NSString *positions = [region objectForKey:REGION_TAG_POSITIONS];
	if (position != nil) {
		NSRange rng = [positions rangeOfString:position];
		if (rng.location != NSNotFound) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)posInRegions:(NSString *)position playSound:(BOOL)soundActive {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	NSEnumerator *enumerator = [_regionDict keyEnumerator];
	NSString *key;
	UIColor *txtColor = [UIColor blueColor];
	
	while ((key = [enumerator nextObject])) {
		_nextScene = @"";
		NSDictionary *region = [_regionDict objectForKey:key];
		if ([self pos: position inRegion:region]) {
			selectedRegion = [region objectForKey:REGION_TAG_IMAGE];
			NSString *image = [region objectForKey:REGION_TAG_IMAGE];
			NSString *sound = [region objectForKey:REGION_TAG_SOUND];
			_nextScene = [region objectForKey:REGION_TAG_NEXT];
			if (![_nextScene isEqualToString:@""]) {
				txtColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.1 alpha:1.0];
				//txtColor = [UIColor greenColor];
				if (soundActive) {
					[g_ResManager playSound:@"xyl.caf" setVolume:delegate.volSound];
				}
			}

			//[self showImg:image playSound:sound playSound:soundActive];
			[self showLabel:image playSound:sound playSound:soundActive textColor:txtColor];
			
			// single tap for regions next and back
			if ([key isEqualToString:REGION_TAG_NEXT] || [key isEqualToString:SCENE_TAG_BACK]) {
				forceSceneChange = YES;
			}
			
			return YES;
		}
		
	}

	return NO;
}

- (void) onTap:(UITouch *) touch {
	if (gameState == GAME_STATE_WAIT) {
		return;
	}

	posOrig = [touch locationInView:self];

	if(g_ResManager.isLandscape) {	
		pos = [self getLandscapeCoordRelToOrigin:imgView.center forPosition:posOrig];
	} else {
		pos = [self getCoordRelToOrigin:imgView.center forPosition:posOrig];
	}
	
	NSString *position = [NSString stringWithFormat:@"%+i,%+i", (int)pos.x, (int)pos.y];

	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if (!delegate.isGameActive) {
		if (![self posInRegions:position playSound:YES]) {
			// the tapping sound was anoying in this case
			//[g_ResManager playSound:@"tap.caf" setVolume:delegate.volSound];
		}
		
		if (forceSceneChange) {
			forceSceneChange = NO;
		} else {
			_nextScene = @"";
		}
	} else {
		[self processGameStates: position];
	}

}

- (void)onDoubleTap:(UITouch *) touch {

	if (gameState == GAME_STATE_WAIT) {
		return;
	}
	
	posOrig = [touch locationInView:self];
	
	if(g_ResManager.isLandscape) {	
		pos = [self getLandscapeCoordRelToOrigin:imgView.center forPosition:posOrig];
	} else {
		pos = [self getCoordRelToOrigin:imgView.center forPosition:posOrig];
	}

	NSString *position = [NSString stringWithFormat:@"%+i,%+i", (int)pos.x, (int)pos.y];
	
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	if (!delegate.isGameActive) {
		if (![self posInRegions:position playSound:NO]) {
			//[g_ResManager playSound:@"tap.caf" setVolume:delegate.volSound];
		}
	} else {
		[self processGameStates: position];
	}
}

- (void) resetScore {
	gameState = GAME_STATE_LOSE; // should be idle
	// reset the initial data
	gameRegion = [NSString stringWithString:@""];
	scoreGood = 0;
	scoreBad = 0;
	prevQuest = -1;
	
	for(int i=0; i < 3; ++i){
		[posPoints[i] startAnimationIsHidden:YES];
		[negPoints[i] startAnimationIsHidden:YES];
	}	
}

- (void) startGameModeInSecs:(Float32)secs
{
	[self resetScore];
	// ask initial question
	[NSTimer scheduledTimerWithTimeInterval:secs target:self selector:@selector(askQuestionDelayed:) userInfo:nil repeats:NO];
}

- (void) processGameStates:(NSString *) position {
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	if (gameState == GAME_STATE_ACTIVE) {
		if ([self posInRegions:position playSound:NO] &&
			[selectedRegion isEqualToString:gameRegion]) {
			[posPoints[scoreGood] startAnimationIsHidden:NO];
			scoreGood++;
		} else {
			[negPoints[scoreBad] startAnimationIsHidden:NO];
			scoreBad++;
		}

 #ifdef DEBUG_ALL
		NSLog(@"comparing strings: %@ <-> %@", selectedRegion, gameRegion);
#endif /*DEBUG*/
		
		if (scoreBad >= 3) {
			[g_ResManager playSound:@"Aaaah.caf" setVolume:delegate.volSound];
			gameState = GAME_STATE_WIN;
			[self raiseEvent:EVENT_ON_GAME_FINISHED withObject:nil ];
		} else if (scoreGood >= 3) {
			[g_ResManager playSound:@"cheering.caf" setVolume:delegate.volSound];
			gameState = GAME_STATE_LOSE;
			[self raiseEvent:EVENT_ON_GAME_FINISHED withObject:nil ];
		} else {
			gameState = GAME_STATE_WAIT;
			[NSTimer scheduledTimerWithTimeInterval:TIMER_DELAY target:self selector:@selector(askQuestionDelayed:) userInfo:nil repeats:NO];
		}
	}
	_nextScene = @"";
}

- (void)askQuestion {
	// get random region
	NSArray *allRegionKeys = [_regionDict allKeys];
	NSDictionary *region = NULL;
	NSString *sWord = NULL;
	
	int rnd = 0;
	srandom(time(0));
	
	do {
		rnd = (int)(random() % [allRegionKeys count]);
		region = [_regionDict objectForKey: [allRegionKeys objectAtIndex:rnd]];
		sWord = [region objectForKey:REGION_TAG_IMAGE]; 	
	} while ((rnd == prevQuest && [allRegionKeys count] > 1) || [sWord length] == 0);
	prevQuest = rnd;
	
#if DEBUG_ALL
	NSLog(@"%@ - %i",[allRegionKeys objectAtIndex:rnd], rnd);
#endif /*DEBUG*/	

	region = [_regionDict objectForKey: [allRegionKeys objectAtIndex:rnd]];
	NSString *sQuestion = [region objectForKey:REGION_TAG_QUESTION];
	NSString *questSnd = [region objectForKey:REGION_TAG_QUESTSND];
	
	if (sQuestion == NULL || [sQuestion length] == 0) {
		sQuestion = [NSString stringWithString:@"Where is the..."];
	}
	if (questSnd == NULL || [questSnd length] == 0) {
		questSnd = [NSString stringWithString:@"whereisthe.caf"];
	}
	
	[self showQuestion:sQuestion playSound:questSnd playSound:YES];
	
	gameRegion = [region objectForKey:REGION_TAG_IMAGE];
	[NSTimer scheduledTimerWithTimeInterval:TIMER_DELAY target:self selector:@selector(showRegionInfoDelayed:) userInfo:region repeats:NO];
}

- (void) showRegionInfoDelayed:(NSTimer*)tmr; {
	
	UIColor *txtColor = [UIColor blueColor];
	NSDictionary *region = (NSDictionary *)[tmr userInfo];
	
	NSString *sRegion = [NSString stringWithFormat:@"%@?",gameRegion];
	NSString *sSound = [region objectForKey:REGION_TAG_SOUND];
	NSString *next = [region objectForKey:REGION_TAG_NEXT];
	if (![next isEqualToString:@""]) {
		txtColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.1 alpha:1.0];
	}
	
	//	[region release];
	[self showLabel:sRegion playSound:sSound playSound:YES textColor:txtColor];
	gameState = GAME_STATE_ACTIVE;
}

- (void) askQuestionDelayed:(NSTimer*)tmr
{
	[self askQuestion];
}

- (void)dealloc {
	for(int i=0; i < 3; ++i){
		[posPoints[i] release];
		[negPoints[i] release];
	}	
	[_landscape release];
	[_prevScene release];
	[_scene release];
	[_regionDict release];
	[_sceneDict release];
	[_xof release];
	[_yof release];
	[actionLabel release];
	[questionLabel release];
	[actionView release];
	[imgView release];
	//TODO - test purging sound causes a crash on iOS 3.1
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
	[g_ResManager purgeSounds];
#endif
#endif
	
    [super dealloc];
}

@end
