//
//  GameMemoryPlayer.h
//  LinguKid
//
//  Created by Jeannine Struck on 11/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GAME_MEM_PLAYER_AI_NONE		0
#define GAME_MEM_PLAYER_AI_DEFAULT	1
#define GAME_MEM_PLAYER_AI_HARD		2
#define GAME_MEM_PLAYER_AI_EXPERT	3

@class MemoryTileView;
@interface GameMemoryPlayer : NSObject {
	int				ai;
	int				score;
	NSMutableArray	*tiles;
	int				maxMemory;
	BOOL			active;
	NSMutableArray  *prefered;
	NSMutableArray  *picked;
}

@property (nonatomic, readwrite) int ai;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) BOOL active;

- (id) initWithAI:(int)ai_level;
- (void) rememberTile:(MemoryTileView *)tile; 
- (void) forgetTile:(MemoryTileView *)tile;
- (MemoryTileView *) pickTileBasedOn:(MemoryTileView *)tile forSet:(NSMutableArray *)tileSet;
- (void) reset;

@end
