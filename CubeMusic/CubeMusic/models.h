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

#pragma mark -
#pragma mark SpinningNode

/**
 * A customized node that automatically rotates by adjusting its rotational aspects on
 * each update pass, and can slow the rotation speed over time based on a friction property.
 *
 * To rotate a node using changes in rotation using the rotateBy... family of methods,
 * as is done to this node, does NOT requre a specialized class. This specialized class
 * is required to handle the freewheeling and friction nature of the behaviour after the
 * rotation has begun.
 */

#pragma mark -
#pragma mark HangingPointParticle

/**
 * A point particle type that simply hangs where it is located. When the particle is initialized,
 * the location is set from the index, so that the particles are laid out in a simple rectangular
 * grid in the X-Z plane, with kParticlesPerSide particles on each side of the grid. This particle
 * type contains no additional state information.
 */
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
