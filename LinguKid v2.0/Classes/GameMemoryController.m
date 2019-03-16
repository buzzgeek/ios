//
//  GameMemoryController.m
//  LinguKid
//
//  Created by Jeannine Struck on 10/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameMemoryController.h"
#import "GameMemoryView.h"
#import "English4KidsAppDelegate.h"
#import "ResourceManager.h"
#import "GameMemoryView.h"
#import	"MemoryTileView.h"
#import "GameMemoryPlayer.h"


@interface GameMemoryController (private)

- (void) showMenuDelayed:(NSTimer*)timer;
- (void) playTileSound:(NSTimer*)timer;
- (void) processTiles:(NSTimer*)timer;
- (void) processAI:(NSTimer*)timer;
- (void) pickAITile:(NSTimer*)timer;
- (void) rememberTile:(MemoryTileView *)tile;
- (void) forgetTile:(MemoryTileView *)tile;
- (void) enableUserEvents:(NSTimer*)timer;
- (BOOL) winSituation;
- (void) showMenu;

@end


@implementation GameMemoryController

@synthesize players;
@synthesize viewGame;
@synthesize viewHeader;
@synthesize score1;
@synthesize score2;
@synthesize background;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.plistScenario = @"memory";
		flippedTiles = [[NSMutableArray alloc] initWithCapacity:2];
		players = [[NSMutableArray alloc] initWithCapacity:GAME_MEM_NUM_PLAYERS];
		for (int i=0; i<GAME_MEM_NUM_PLAYERS; ++i) {
			//GameMemoryPlayer *player = [[GameMemoryPlayer alloc] initWithAI: GAME_MEM_PLAYER_AI_EXPERT];
			GameMemoryPlayer *player = [[GameMemoryPlayer alloc] initWithAI:i];

			if (i==0) {
				player.active = YES;
				score1.active = YES;
			}

			[players addObject:player];
			[player release];
		}
		currentPlayer = 0;
    }
    return self;
}

- (void)dealloc {
	[viewGame release];
	[viewHeader release];
	[score1 release];
	[score2 release];
	[players release];
	[flippedTiles release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	score2.textColor = [UIColor redColor];
	[self showMenu];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)showMenu {
	MemoryMenuController *menu = [[MemoryMenuController alloc] initWithNibName:@"MemoryMenuController" bundle:nil];
	menu.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: menu];
	[nav setToolbarHidden:YES];
	[nav setNavigationBarHidden:YES]; 
	nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	
	[self presentModalViewController:nav animated:YES];
	[nav release];
	[menu release];
}

- (void) showMenuDelayed:(NSTimer*)timer
{	
	[self showMenu];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) resetPlayers {
	for (int i = 0; i < [players count]; ++i) {
		GameMemoryPlayer *player = [players objectAtIndex:i];
		[player reset];
	}
	
}

- (void) onTileTap:(id)data
{
	GameMemoryPlayer *player = [players objectAtIndex:currentPlayer];
	MemoryTileView *tile = (MemoryTileView *) data;
	
	//block user interaction if ai is active
	if (player.ai != GAME_MEM_PLAYER_AI_NONE) {
		tile.active = NO;
	} else {
		tile.active = YES;
	}
}

- (void) onTileFlip:(id)data
{
	GameMemoryPlayer *player = [players objectAtIndex:currentPlayer];
	MemoryTileView *tile = (MemoryTileView *) data;

	if (player.ai != GAME_MEM_PLAYER_AI_NONE) {
		[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(processAI:) userInfo:tile repeats:NO];
		return;
	}
	
	
	if (!tile.showBack) {	// picking tiles
		switch ([flippedTiles count]) {
			case 0:		// picked first tile
				tile.active = YES;
				tile.tapSound = @"tap.caf";
				[flippedTiles addObject:tile];
				break;
			case 1:		// picked second tile
				tile.active = YES;
				// no more user interaction allowed at this point
				[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
				[flippedTiles addObject:tile];
				tile.tapSound = @"tap2.caf";
				MemoryTileView *tile1 = [flippedTiles objectAtIndex:0];
				MemoryTileView *tile2 = [flippedTiles objectAtIndex:1];
				if ([tile1.frontImage isEqualToString:tile2.frontImage]) {
					[NSTimer scheduledTimerWithTimeInterval:GAME_MEM_WAIT_TIME / 2.0 target:self selector:@selector(playTileSound:) userInfo:nil repeats:NO];				
				}		
				[NSTimer scheduledTimerWithTimeInterval:GAME_MEM_WAIT_TIME target:self selector:@selector(processTiles:) userInfo:nil repeats:NO];				
				break;
			default:	// no more picking allowed
				[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
				tile.active = NO;
				break;
		}
	} else { // flipp to backside - not allowed in this game
		tile.active = NO;
	}
	[self rememberTile:tile];
}

- (void) rememberTile:(MemoryTileView *)tile {
	for (int i = 0; i < [players count]; ++i) {
		GameMemoryPlayer *player = [players objectAtIndex:i];
		if (player.ai != GAME_MEM_PLAYER_AI_NONE) {
			[player rememberTile: tile];
		}
	}
}

- (void) forgetTile:(MemoryTileView *)tile {
	for (int i = 0; i < [players count]; ++i) {
		GameMemoryPlayer *player = [players objectAtIndex:i];
		if (player.ai != GAME_MEM_PLAYER_AI_NONE) {
			[player forgetTile: tile];
		}
	}
}

- (void) processAI:(NSTimer*)timer {
	GameMemoryPlayer *player = [players objectAtIndex:currentPlayer];
	MemoryTileView *tile = (MemoryTileView *) [timer userInfo];
	
	if (tile) {
		switch ([flippedTiles count]) {
			case 0:		// picked first tile
				tile.active = YES;
				tile.tapSound = @"tap.caf";
				[flippedTiles addObject:tile];
				MemoryTileView *pick = [player pickTileBasedOn:tile forSet:[viewGame getTiles]];
				//[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pickAITile:) userInfo:pick repeats:NO];		
				[pick flip:NO];
				[self rememberTile:pick];
				break;
			case 1:		// picked second tile
				tile.active = YES;
				tile.tapSound = @"tap2.caf";
				[flippedTiles addObject:tile];
				MemoryTileView *tile1 = [flippedTiles objectAtIndex:0];
				MemoryTileView *tile2 = [flippedTiles objectAtIndex:1];
				if ([tile1.frontImage isEqualToString:tile2.frontImage]) {
					[NSTimer scheduledTimerWithTimeInterval:GAME_MEM_WAIT_TIME / 2.0 target:self selector:@selector(playTileSound:) userInfo:nil repeats:NO];				
				}		
				[NSTimer scheduledTimerWithTimeInterval:GAME_MEM_WAIT_TIME target:self selector:@selector(processTiles:) userInfo:nil repeats:NO];				
				break;
			default:	// no more picking allowed
				tile.active = NO;
				break;
		}
	} else {
		MemoryTileView *pick = [player pickTileBasedOn:tile forSet:[viewGame getTiles]];
		[NSTimer scheduledTimerWithTimeInterval:GAME_MEM_AI_TIME target:self selector:@selector(pickAITile:) userInfo:pick repeats:NO];		
		[self rememberTile:pick];
	}
}

- (void) pickAITile:(NSTimer*)timer {
	MemoryTileView *pick = (MemoryTileView *)[timer userInfo];
	[pick flip:NO];
}


- (void) playTileSound:(NSTimer*)timer {
	MemoryTileView *tile1 = [flippedTiles objectAtIndex:0];
	[g_ResManager playSound:tile1.sound];
}

- (void) processTiles:(NSTimer*)timer
{
	GameMemoryPlayer *player = [players objectAtIndex:currentPlayer];
	player.active = NO;
	MemoryTileView *tile1 = [flippedTiles objectAtIndex:0];
	MemoryTileView *tile2 = [flippedTiles objectAtIndex:1];
	
	if ([tile1.frontImage isEqualToString:tile2.frontImage]) {
		// we have a winner
		[g_ResManager playSound:@"ding.caf"];
		//[g_ResManager playSound:tile1.sound];
		player.score++;
		if (currentPlayer == 0) {
			score1.score = player.score;
		} else {
			score2.score = player.score;
		}

		[tile1 fade];
		[tile2 fade];
		tile1.pickedByAI = NO;
		tile2.pickedByAI = NO;
		[self forgetTile: tile1];
		[self forgetTile: tile2];

#if DEBUG
		if(currentPlayer==0)
			NSLog(@"player1 score: %d", player.score);
		else {
			NSLog(@"player2 score: %d", player.score);
		}
#endif
		player.active = YES;
		
		if ([self winSituation]) {
			[NSTimer scheduledTimerWithTimeInterval:GAME_MEM_WAIT_TIME target:self selector:@selector(showMenuDelayed:) userInfo:nil repeats:NO];				
			return;
		}
		
	} else {
		// nope
		tile1.pickedByAI = NO;
		tile2.pickedByAI = NO;
		[tile1 flip:YES];
		[tile2 flip:YES];
		currentPlayer++;
		currentPlayer = currentPlayer == [players count] ? 0 : currentPlayer;
		if (currentPlayer == 0) {
			score1.active = YES;
			score2.active = NO;
		} else {
			score1.active = NO;
			score2.active = YES;
		}
		
	}
	
	[flippedTiles removeAllObjects];	

	player = [players objectAtIndex:currentPlayer];
	player.active = YES;
	
	if (player.ai != GAME_MEM_PLAYER_AI_NONE) {
		[NSTimer scheduledTimerWithTimeInterval:GAME_MEM_AI_TIME target:self selector:@selector(processAI:) userInfo:nil repeats:NO];
	} else {
		[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(enableUserEvents:) userInfo:nil repeats:NO];
	}
}

- (BOOL) winSituation {
	
	// check for win situation
	GameMemoryPlayer *p1 = [players objectAtIndex:0];
	GameMemoryPlayer *p2 = [players objectAtIndex:1];
	int scoreSum = score1.score + score2.score;
	if (scoreSum >= TILE_COL_COUNT * TILE_ROW_COUNT * 0.5) {
		// game over
		[[UIApplication sharedApplication] endIgnoringInteractionEvents];
		if ((score1.score >= score2.score && !p1.ai) || !p2.ai) {
			[g_ResManager playSound:@"cheering.caf"];
		} else {
			[g_ResManager playSound:@"Aaaah.caf"];
		}
		
		return YES;
	}
	return NO;
}

- (void) enableUserEvents:(NSTimer*)timer
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

-(void) memoryMenuController:(MemoryMenuController *)controller selectedNumberOfPlayers:(int)num 
{
	English4KidsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	GameMemoryPlayer *player1 = [players objectAtIndex:0];
	GameMemoryPlayer *player2 = [players objectAtIndex:1];

	switch (num) {
		case 0:
			[delegate popController];
			return;
		case 1:
			player1.ai = GAME_MEM_PLAYER_AI_NONE;
			player2.ai = GAME_MEM_PLAYER_AI_DEFAULT;
			break;
		case 2:
			player1.ai = GAME_MEM_PLAYER_AI_NONE;
			player2.ai = GAME_MEM_PLAYER_AI_NONE;
			break;
		default:
			player1.ai = GAME_MEM_PLAYER_AI_EXPERT;
			player2.ai = GAME_MEM_PLAYER_AI_EXPERT;
			break;
	}
	
	[flippedTiles removeAllObjects];
	currentPlayer = 0;
	[self resetPlayers];
	score1.score = 0;
	score2.score  = 0;
	score2.textColor = [UIColor redColor];
	[viewGame startWithParent:self withScenario:self.plistScenario];
	//[[UIApplication sharedApplication] endIgnoringInteractionEvents];
	
	GameMemoryPlayer *player = [players objectAtIndex:0];
	player.active = YES;
	score1.active = 1;
	
	
	if (player.ai != GAME_MEM_PLAYER_AI_NONE) {
		[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
		[NSTimer scheduledTimerWithTimeInterval:GAME_MEM_AI_TIME target:self selector:@selector(processAI:) userInfo:nil repeats:NO];
	}
}


@end
