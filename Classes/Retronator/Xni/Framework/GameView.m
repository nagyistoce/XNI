//
//  GameView.m
//  XNI
//
//  Created by Matej Jan on 22.7.10.
//  Copyright 2010 Retronator, Razum. All rights reserved.
//

#import "GameView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GameView

- (id) initWithFrame:(CGRect)frame {	
    if (self = [super initWithFrame:frame]) {
        
        viewSizeChanged = [[Event alloc] init];
		
        CAEAGLLayer *eaglLayer = (CAEAGLLayer*)self.layer;
        		
        eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking,
                                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
		self.multipleTouchEnabled = YES;
    }
    return self;
}

@synthesize viewSizeChanged;

- (float) scale {
	CAEAGLLayer *eaglLayer = (CAEAGLLayer*)self.layer;
	return eaglLayer.contentsScale;
}

- (void) setScale:(float)value {
	CAEAGLLayer *eaglLayer = (CAEAGLLayer*)self.layer;	
	eaglLayer.contentsScale = value;
}

+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

- (void) layoutSubviews
{
    [viewSizeChanged raiseWithSender:self];
}

- (void) dealloc
{
    [viewSizeChanged release];
    [super dealloc];
}

@end
