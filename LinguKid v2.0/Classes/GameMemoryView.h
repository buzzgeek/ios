//
//  GameMemoryView.h
//  LinguKid
//
//  Created by Jeannine Struck on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneView.h"
#import "MemoryScoreView.h"

#define TILE_COL_COUNT		4
#define TILE_ROW_COUNT		5
#define TILE_SIZE			0.25 
#define TILE_SHUFFLE_COUNT  142

@class MemoryTileView;
@class GameMemoryController;

@interface GameMemoryView : UIView {
	GameMemoryController	*parent;
	NSMutableArray			*tiles;
	NSMutableArray			*allTiles;
}

- (void) startWithParent:(id)controller withScenario:(NSString *)scenario;
- (NSMutableArray *)getTiles; 

@end
