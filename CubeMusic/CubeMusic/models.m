//
//  models.m
//  CubeMusic
//
//  Created by Yuli Levtov on 22/01/2013.
//
//

#import "models.h"
#import "CC3ActionInterval.h"
#import "CCActionInstant.h"
#import "CC3IOSExtensions.h"
#import "CC3CC2Extensions.h"


@implementation SpinningNode

@synthesize spinAxis, spinSpeed, friction, isFreeWheeling;

-(id) initWithTag: (GLuint) aTag withName: (NSString*) aName {
	if ( (self = [super initWithTag: aTag withName: aName]) ) {
		spinAxis = kCC3VectorZero;
		spinSpeed = 0.0f;
		friction = 0.0f;
		isFreeWheeling = NO;
	}
	return self;
}

// Template method that populates this instance from the specified other instance.
// This method is invoked automatically during object copying via the copyWithZone: method.
-(void) populateFrom: (CC3Node*) another {
	[super populateFrom: another];
	
	// Only copy these properties if the original is of the same class
	if ( [another isKindOfClass: [SpinningNode class]] ) {
		SpinningNode* anotherSpinningNode = (SpinningNode*)another;
		spinAxis = anotherSpinningNode.spinAxis;
		spinSpeed = anotherSpinningNode.spinSpeed;
		friction = anotherSpinningNode.friction;
		isFreeWheeling = anotherSpinningNode.isFreeWheeling;
	}
}

// Don't bother continuing to rotate once below this speed (in degrees per second)
#define kSpinningMinSpeed	6.0

/**
 * On each update, if freewheeling, rotate the node around the spinAxis, by an
 * angle determined by the spinSpeed. Then slow the spinSpeed down based on the
 * friction value and how long the friction has been applied since the last update.
 * Stop rotating altogether once the speed is low enough to be unnoticable, so that
 * we don't continue to perform transforms (and rebuilding shadows) unnecessarily.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {
	GLfloat dt = visitor.deltaTime;
	if (isFreeWheeling && spinSpeed > kSpinningMinSpeed) {
		GLfloat deltaAngle = spinSpeed * dt;
		[self rotateByAngle: deltaAngle aroundAxis: spinAxis];
		spinSpeed -= (deltaAngle * friction);
		LogTrace(@"Spinning %@ by %.3f at speed %.3f", self, deltaAngle, spinSpeed);
	}
}

@end

