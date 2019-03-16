//
//  GameMemoryView.m
//  LinguKid
//
//  Created by Jeannine Struck on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameMemoryView.h"
#import "ResourceManager.h"
#import	"MemoryTileView.h"
#import "English4KidsAppDelegate.h"
#import "GameMemoryController.h"

@interface GameMemoryView (private)

- (void) initBase;
- (void) onTileFlip:(id)data;
- (void) onTileTap:(id)data;
- (BOOL) setupAllTiles:(NSString *)plist;
- (void) setupGameTiles;
- (void) shuffleTiles;
- (void) placeTiles:(BOOL)reset;
- (CGFloat) widthPcnt:(CGFloat) pcnt;
- (CGFloat) heightPcnt:(CGFloat) pcnt;

@end

@implementation GameMemoryView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
        // Initialization code
		[self initBase];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		[self initBase];
    }
    return self;
}

- (void) initBase {
	parent = nil;
	tiles = [[NSMutableArray alloc] initWithCapacity:(TILE_ROW_COUNT * TILE_COL_COUNT)];
	allTiles = [[NSMutableArray alloc] initWithCapacity:20];
}

- (void) startWithParent:(id)controller withScenario:(NSString *)scenario {

	if (parent) {
		[self shuffleTiles];
		[self placeTiles: YES];
		return;
	}
	
	parent = (GameMemoryController *)controller;
	[parent retain];
	
	[self setupAllTiles:scenario];
	
	[self setupGameTiles];
	[self shuffleTiles];
	[self placeTiles: NO];
} 

- (CGFloat) widthPcnt:(CGFloat) pcnt {
	CGFloat res = [self frame].size.width * pcnt; 
	return res;
}

- (CGFloat) heightPcnt:(CGFloat) pcnt {
	CGFloat res = [self frame].size.height * pcnt; 
	return res;
}


- (void) setupGameTiles {
	int rnd = 0;
	
	for (int i=0; i<TILE_ROW_COUNT * TILE_COL_COUNT; i+=2) 
	{
		if (![allTiles count]) {
				return;
		}
		srandom(time(0));
		rnd = (int)(random() % [allTiles count]);

		MemoryTileView *tile = [[allTiles objectAtIndex:rnd] retain];
		
		MemoryTileView *tile2 =[[MemoryTileView alloc] initWithFrame:tile.frame withBackImage:tile.backImage withFrontImage:tile.frontImage];
		tile2.sound = tile.sound;

#ifdef DEBUG
		NSLog(@"image: %@", tile.frontImage); 
#endif
		
		[allTiles removeObjectAtIndex:rnd];
			
		[tile setNotificationDelegate:self forEvent:EVENT_TILE_FLIP withSelector:@selector(onTileFlip:)];
		[tile2 setNotificationDelegate:self forEvent:EVENT_TILE_FLIP withSelector:@selector(onTileFlip:)];
		[tile setNotificationDelegate:self forEvent:EVENT_TILE_TAP withSelector:@selector(onTileTap:)];
		[tile2 setNotificationDelegate:self forEvent:EVENT_TILE_TAP withSelector:@selector(onTileTap:)];
		[tiles addObject:tile];
		[tiles addObject:tile2];
		
		[tile release];
		[tile2 release];
			
	}
}

- (void) shuffleTiles {
	if (![tiles count]) {
		return;
	}
	
	int rnd = 0;
	
	for (int i = 0; i < TILE_SHUFFLE_COUNT; ++i) {
		rnd = (int)(random() % [tiles count]);
		[tiles exchangeObjectAtIndex:0 withObjectAtIndex:rnd];
	} 
}

- (void) placeTiles:(BOOL)reset {
	int i = 0;
	for (int r=0; r<TILE_ROW_COUNT; ++r) {
		for (int c=0; c<TILE_COL_COUNT; ++c) {
			if (i >= [tiles count]) {
				return;
			}
			CGFloat size = [self widthPcnt:TILE_SIZE];
			CGFloat sizeHalf = size * 0.5;
			
			MemoryTileView *tile = [tiles objectAtIndex:i++];
			tile.center = CGPointMake((size * c) + sizeHalf, (size * r) + sizeHalf);

			if (reset) {
				tile.tapSound = @"tap.caf";
				//[tile reset];
				NSTimeInterval ti = i / 5.0;
				[tile resetInTimeInterval:ti];
			}
			
			[self addSubview:tile];
		}
	}
}

- (void) onTileFlip:(id)data
{
	if (parent) {
		[parent onTileFlip:data];
	}
}

- (void) onTileTap:(id)data
{
	if (parent) {
		[parent onTileTap:data];
	}
}

- (BOOL) setupAllTiles:(NSString *)plist {
	NSData		*pData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plist ofType:@"plist"]];
	NSString	*error;
	NSPropertyListFormat format;
	
	NSDictionary *dicScenario = [NSPropertyListSerialization 
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
	
	NSEnumerator *enumScene = [dicScenario objectEnumerator];
	id scene;
	CGFloat size = [self widthPcnt:TILE_SIZE];
	CGRect frame = CGRectMake(0, 0, size, size);
	NSString *image = nil;
	NSString *sound = nil;
	NSEnumerator *enumRegions = nil;
	NSDictionary *regions = nil;
	NSDictionary *region = nil;
	
	while ((scene = [enumScene nextObject])) {
		if ([scene isKindOfClass:[NSDictionary class]]) {
			regions = [(NSDictionary *)scene objectForKey:SCENE_TAG_REGIONS];
			enumRegions = [regions objectEnumerator];
			while ((region = [enumRegions nextObject])) {
				image = [region objectForKey:REGION_TAG_TILE];
				if (image && [image length] > 0) {
					sound = [region objectForKey:REGION_TAG_SOUND];
					if (sound && [sound length] > 0) {
						MemoryTileView *tile = [[MemoryTileView alloc] 
												initWithFrame:frame 
												withBackImage:MEMTILE_DEF_BACK_IMG 
												withFrontImage:image];
						tile.sound = sound;
						
						[allTiles addObject:tile];
						[tile release];
					}
				}
			}
		}
	}

	return YES;
}

- (NSMutableArray *)getTiles {
	return tiles;
}

- (void)dealloc {
	[parent release];
	[allTiles release];
	[tiles release];
    [super dealloc];
}


@end
