//
//  GameViewController.m
//  XNI
//
//  Created by Matej Jan on 22.7.10.
//  Copyright 2010 Retronator, Razum. All rights reserved.
//

#import "GameViewController.h"

#import "Retronator.Xni.Framework.h"
#import "TouchPanel+Internal.h"
#import "GameView.h"
#import "GameWindow+Internal.h"


@implementation GameViewController

- initWithGameWindow: (GameWindow*)theGameWindow {
    if (self = [super init]) {
        gameWindow = theGameWindow;
		supportedOrientations = [GameViewController getSupportedOrientationsFromPlist];
    }
    return self;
}

@synthesize supportedOrientations;

- (GameView *) gameView {
	return (GameView*)self.view;
}

+ (DisplayOrientation) getDisplayOrientationForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return DisplayOrientationPortrait;
    } else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return DisplayOrientationPortraitUpsideDown;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return DisplayOrientationLandscapeLeft;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return DisplayOrientationLandscapeRight;
    } else{
        return DisplayOrientationDefault;
    }
}

+ (UIInterfaceOrientation) getUIInterfaceOrientationFromString:(NSString*)interfaceOrientation {
	if ([interfaceOrientation isEqual:@"UIInterfaceOrientationPortrait"]) return UIInterfaceOrientationPortrait;
	if ([interfaceOrientation isEqual:@"UIInterfaceOrientationPortraitUpsideDown"]) return UIInterfaceOrientationPortraitUpsideDown;
	if ([interfaceOrientation isEqual:@"UIInterfaceOrientationLandscapeLeft"]) return UIInterfaceOrientationLandscapeLeft;
	if ([interfaceOrientation isEqual:@"UIInterfaceOrientationLandscapeRight"]) return UIInterfaceOrientationLandscapeRight;
	return 0;
}

+ (DisplayOrientation) getSupportedOrientationsFromPlist {
	NSDictionary *properties = [[NSBundle mainBundle] infoDictionary];
	NSArray *supportedOrientations = [properties objectForKey:@"UISupportedInterfaceOrientations"];
	if (supportedOrientations) {
		DisplayOrientation result = 0;
		for (id interfaceOrientationString in supportedOrientations) {
			UIInterfaceOrientation interfaceOrientation = [GameViewController getUIInterfaceOrientationFromString:(NSString*)interfaceOrientationString];
			DisplayOrientation orientation = [GameViewController getDisplayOrientationForInterfaceOrientation:interfaceOrientation];
			result = result | orientation;
		}
		return result;
	} else {
		return DisplayOrientationDefault;
	}
}

+ (BOOL) getIsFullscreenFromPlist {
	NSDictionary *properties = [[NSBundle mainBundle] infoDictionary];
	NSNumber *isStatusBarHidden = [properties objectForKey:@"UIStatusBarHidden"];
	if (isStatusBarHidden) {
		return [isStatusBarHidden boolValue];
	} else {
		return NO;
	}
}

- (void)loadView {
    [super loadView];
    GameView *gameView = [[GameView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = gameView;
	
	TouchPanel *touchPanel = [TouchPanel getInstance];
	touchPanel.displayWidth = self.view.bounds.size.width;
	touchPanel.displayHeight = self.view.bounds.size.height;
	touchPanel.displayOrientation = [GameViewController getDisplayOrientationForInterfaceOrientation:self.interfaceOrientation];
    
    [gameView release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    DisplayOrientation orientation = [GameViewController getDisplayOrientationForInterfaceOrientation:interfaceOrientation];
	BOOL supported = supportedOrientations & orientation;
    return supported;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return supportedOrientations;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


// Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[TouchPanel getInstance] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[TouchPanel getInstance] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[TouchPanel getInstance] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [[TouchPanel getInstance] touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

- (void)dealloc {
    [super dealloc];
}

@end
