//
//  MemoryMenuController.h
//  LinguKid
//
//  Created by Jeannine Struck on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MemoryMenuDelegate;

@interface MemoryMenuController : UIViewController{
	id<MemoryMenuDelegate> delegate;
	UIButton	*btnOnePlayer;
	UIButton	*btnTwoPlayers;
	UIButton	*btnBack;
	UIImageView *background;
}

@property (nonatomic, assign) id<MemoryMenuDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIButton	*btnOnePlayer;
@property (nonatomic, retain) IBOutlet UIButton	*btnTwoPlayers;
@property (nonatomic, retain) IBOutlet UIButton	*btnBack;
@property (nonatomic, retain) IBOutlet UIImageView *background;

- (IBAction) onButton:(id)sender;

@end

@protocol MemoryMenuDelegate

- (void) memoryMenuController:(MemoryMenuController *)controller selectedNumberOfPlayers:(int)num;

@end
