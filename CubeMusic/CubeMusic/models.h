//
//  models.h
//  CubeMusic
//
//  Created by Yuli Levtov on 22/01/2013.
//
//

#import "CC3Node.h"
#import "CCActionManager.h"
#import "CC3PODLight.h"
#import "CC3PointParticles.h"
#import "CC3MeshParticleSamples.h"
#import "CC3BitmapLabelNode.h"

@interface models : NSObject

@end


typedef struct {
	CGFloat heading;		/**< The angular heading in degrees. */
	CGFloat radius;			/**< The radial distance. */
} AngularPoint;

/** A constant representing a zero angular point, with both angle and radius set to zero. */
static const AngularPoint AngularPointZero = {0.0, 0.0};


@interface Joystick : CCLayer {
	CCNode *thumbNode;
	BOOL isTracking;
	CGPoint velocity;
	//AngularPoint angularVelocity;
	CGPoint travelLimit;
}

/**
 * The current velocity of the Joystick in terms of cartesian X-Y coordinates, as measured
 * by the current position of the thumb proportionally relative to its resting position
 * (the anchorPoint of the Joystick) and the contentSize of the Joystick. The individual
 * X and Y values may be either positive (up an right) or negative (down and left).
 * The magnitude of the X-Y vector is clamped to unit length, even if the user drags the finger
 * outside the bounds of the Joystick. The set of possible points returned by this property
 * therefore covers the area of a circle of unit radius, centered on the origin of an X-Y plane.
 */
@property(nonatomic, readonly) CGPoint velocity;

/**
 * The velocity of the joystick in terms of angular coordinates. The returned heading
 * is measured in degrees from the vertical axis, with positive angles growing clockwise.
 * The radius is clamped to a maximum of unit length. The set of possible points
 * returned by this method therefore covers the area of a circle of unit radius.
 */
@property(nonatomic, readonly) AngularPoint angularVelocity;

/**
 * Initializes this Joystick to have the specified contentSize
 * and to use the specified CCNode as the thumb "stick".
 */
-(id) initWithThumb: (CCNode*) aNode andSize: (CGSize) size;

/**
 * Allocates and initializes an autoreleased Joystick to have the specified
 * contentSize and to use the specified CCNode as the thumb "stick".
 */
+(id) joystickWithThumb: (CCNode*) aNode andSize: (CGSize) size;

/**
 * Initialize this Joystick to use the specified CCNodes to draw the thumb (the "stick")
 * and background behind the "stick". The contentSize of the Joystick will be
 * set to that of the backgroundNode.
 */
-(id) initWithThumb: (CCNode*) thumbNode andBackdrop: (CCNode*) backgroundNode;

/**
 * Allocates and initializes an autoreleased Joystick to use the specified nodes
 * to draw the thumb (the "stick") and background behind the "stick". The contentSize
 * of the Joystick will be set to that of the backgroundNode.
 */
+(id) joystickWithThumb: (CCNode*) thumbNode andBackdrop: (CCNode*) backgroundNode;

@end

@interface PointParticle : CC3PointParticle
{
    GLfloat lifetime;
    GLfloat scalingFactor;
}

@end



@interface SpinningNode : CC3Node {
	CC3Vector spinAxis;
	GLfloat spinSpeed;
	GLfloat friction;
	BOOL isFreeWheeling;
}

/**
 * The axis that the cube spins around.
 *
 * This is different than the rotationAxis property, because this is the axis around which
 * a CHANGE in rotation will occur. Depending on how the node is already rotated, this may
 * be very different than the rotationAxis.
 */
@property(nonatomic, assign) CC3Vector spinAxis;

/**
 * The speed of rotation. This value can be directly updated, and then will automatically
 * be slowed down over time according to the value of the friction property.
 */
@property(nonatomic, assign) GLfloat spinSpeed;

/**
 * The friction value that is applied to the spinSpeed to slow it down over time.
 *
 * A value of zero will not slow rotation down at all and the node will continue
 * spinning indefinitely.
 */
@property(nonatomic, assign) GLfloat friction;

/** Indicates whether the node is spinning without direct control by touch events. */
@property(nonatomic, assign) BOOL isFreeWheeling;

@end
