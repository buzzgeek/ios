//
//  MemoryTileView.h
//  LinguKid
//
//  Created by Jeannine Struck on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

#define MEMTILE_DEF_FRONT_IMG	@"questAlt42x42"
#define MEMTILE_DEF_BACK_IMG	@"btpurple160"
#define EVENT_TILE_FLIP			@"onTileFlip"
#define EVENT_TILE_TAP			@"onTileTap"

@interface MemoryTileView : BaseView {
	id			*parent;
	UIImageView	*frontView;
	UIImageView *backView;
	NSString	*sound;
	NSString	*tapSound;
	NSString	*word;
	NSString	*frontImage;
	NSString	*backImage;
	BOOL		showBack;
	BOOL		flipping;
	BOOL		active;
	CGRect		_frame;
	CGPoint		coords;
	BOOL		pickedByAI;
	BOOL		outOfGame;
}

@property (readonly, nonatomic) NSString *frontImage;
@property (readonly, nonatomic) NSString *backImage;
@property (readwrite, retain) NSString *sound;
@property (readwrite, retain) NSString *tapSound;
@property (readwrite, retain) NSString *word;
@property (readonly, nonatomic)BOOL showBack;
@property (readwrite, nonatomic)BOOL active;
@property (nonatomic, readwrite)CGPoint coords;
@property (nonatomic, readwrite)BOOL pickedByAI;
@property (nonatomic, readwrite)BOOL outOfGame;


- (id) initWithFrame:(CGRect)frame withBackImage:(NSString *)backImg withFrontImage:(NSString *)frontImg;
- (void) startAnimationIsHidden:(BOOL)hide;
- (void) flip:(BOOL)force;
- (void) fade;
- (void) reset;
- (void) resetInTimeInterval:(NSTimeInterval)ti;

@end
