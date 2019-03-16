//
//  GameMemoryPlayer.m
//  LinguKid
//
//  Created by Jeannine Struck on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameMemoryPlayer.h"
#import "MemoryTileView.h"

@implementation GameMemoryPlayer

@synthesize ai;
@synthesize score;
@synthesize active;

- (id) initWithAI:(int) ai_level {
	if ((self = [super init])) {
		tiles = [[NSMutableArray alloc] initWithCapacity:10];
		prefered = [[NSMutableArray alloc] initWithCapacity:10];
		picked = [[NSMutableArray alloc] initWithCapacity:2];
		ai = ai_level;
		[self reset];
	}
	return self;
}

- (void) reset {
	srandom(time(0));
	active = NO;
	score = 0;
	[tiles removeAllObjects];
	[prefered removeAllObjects];
	[picked removeAllObjects];

	switch (ai) {
		case GAME_MEM_PLAYER_AI_DEFAULT:
			maxMemory = 4;
			break;
		case GAME_MEM_PLAYER_AI_HARD:
			maxMemory = 10;
			break;
		case GAME_MEM_PLAYER_AI_EXPERT:
			maxMemory = 20;
			break;
		default:
			maxMemory = 4;
			break;
	}
}


- (void) rememberTile:(MemoryTileView *)tile {
	
	if (![prefered containsObject:tile]) {
		for (int i =0; i < [tiles count]; ++i) {
			MemoryTileView *oldTile = [tiles objectAtIndex:i];
			if (![tile isEqual:oldTile]) {
				if ([oldTile.frontImage isEqualToString:tile.frontImage]) {
					[prefered addObject:tile];
					break;
				}
			}
		}
	}
	
	if ([tiles containsObject:tile]) {
		return;
	}
	
	if ([tiles count] >= maxMemory) {
		int rnd = (int)(rand() % [tiles count]);
		[tiles removeObjectAtIndex:rnd];
	}

	[tiles addObject:tile];
}

- (void) forgetTile:(MemoryTileView *)tile {
	if ([tiles containsObject:tile]) {
		[tiles removeObject:tile];
	}
	if ([prefered containsObject:tile]) {
		[prefered removeObject:tile];
	}
}



- (MemoryTileView *) pickTileBasedOn:(MemoryTileView *)tile forSet:(NSMutableArray *)tileSet {
	MemoryTileView	*pick = nil;
	
	if (!tileSet) {
		return nil;
	}
	
	if (!tile) {
		// first tile
		[picked removeAllObjects];
		// make this one smarter to find the first pick
		if ([prefered count]>0) {
			pick = [prefered lastObject];
		}
	} else {
		for (int i = 0; i < [tiles count]; ++i) {
			pick = [tiles objectAtIndex:i];
			
			if ([tile isEqual: pick] || pick.outOfGame || [picked containsObject:pick]) {
				pick = nil;
				continue;
			} else if ([pick.frontImage isEqualToString:tile.frontImage]) {
				// found a match 
				pick.pickedByAI = YES;
				break;
			}
			pick = nil;
		}
	}

	while (!pick || pick.outOfGame || [picked containsObject:pick]) {
		int rnd = (int)(random() % [tileSet count]);
		pick = [tileSet objectAtIndex:rnd]; 
	}

	[picked addObject: pick];
	
	pick.pickedByAI = YES;
	
	return pick;
}

- (void)dealloc {
	[prefered release];
	[tiles release];
	[picked release];
	[super dealloc];
}

@end
