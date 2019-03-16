//
//  GameMemoryController.h
//  LinguKid
//
//  Created by Jeannine Struck on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameMemoryView.h"
#import "MemoryHeaderView.h"
#import "MemoryMenuController.h"
#import "BaseController.h"

#define GAME_MEM_NUM_PLAYERS	2
#define GAME_MEM_WAIT_TIME		2.0
#define GAME_MEM_AI_TIME		1.0

@class GameMemoryPlayer;


@interface GameMemoryController : BaseController <MemoryMenuDelegate> {
	int					currentPlayer;
	NSMutableArray		*players;
	NSMutableArray		*flippedTiles;
	GameMemoryView		*viewGame;
	MemoryHeaderView	*viewHeader;
	MemoryScoreView		*score1;
	MemoryScoreView		*score2;
	UIImageView			*background;
}

@property (nonatomic, retain) IBOutlet GameMemoryView *viewGame;
@property (nonatomic, retain) IBOutlet MemoryHeaderView	*viewHeader;
@property (nonatomic, retain) IBOutlet MemoryScoreView *score1;
@property (nonatomic, retain) IBOutlet MemoryScoreView *score2;
@property (nonatomic, retain) IBOutlet UIImageView *background;

@property (nonatomic, readonly) NSMutableArray *players;

- (void) onTileFlip:(id)data;
- (void) onTileTap:(id)data;
- (void) resetPlayers;

@end
