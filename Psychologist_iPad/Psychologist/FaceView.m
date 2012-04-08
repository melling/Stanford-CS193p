//
//  FaceView.m
//  Happiness
//
//  Created by Michael Mellinger on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FaceView.h"

// 90%
#define DEFAULT_SCALE 0.90


@implementation FaceView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;

-(CGFloat)scale {
    if (!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}


-(void)setScale:(CGFloat)scale {
    if (_scale != scale) {
        _scale = scale;
        [self setNeedsDisplay]; // Redraw
    }
}

-(void)pinch:(UIPinchGestureRecognizer *)gesture {
    
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
    
        self.scale *= gesture.scale;
        gesture.scale = 1; // Reset
    }
}


-(void)setup {
    // Can set this Xcode!!! Mode: Redraw
    self.contentMode = UIViewContentModeRedraw; // Redraws with rotation
}

-(void) awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup]; // Not called when we come out of storyboard
    }
    return self;
}


-(void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context {
    
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    
    CGContextAddArc(context, p.x, p.y, radius, 0, 2 *M_PI, YES);
    CGContextStrokePath(context);
    
    UIGraphicsPopContext();
}



- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // draw face (circle)
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width / 2;
    // Look for shorter of two sides.  Rotation...
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height / 2;
//    size *= DEFAULT_SCALE;
    size *= self.scale;
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
    // draw eyes (2 circles)
    
#define EYE_H 0.35
#define EYE_V 0.35
#define EYE_RADIUS 0.10
    
    // Video: @1h
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_V;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    eyePoint.x += size * EYE_H * 2;  // Move over to right eye
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    // no nose
    
    // draw mouth
    
#define MOUTH_H 0.45
#define MOUTH_V 0.4
#define MOUTH_SMILE 0.25
    
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_V * size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x += MOUTH_H * size * 2/3.0;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -= MOUTH_H * size * 2/3.0;
    
//    float smile = 0; // 1.0 is full smile, -1.0 is a full frown
//    smile = 1.0;
//    smile = -1.0;
    float smile = [self.dataSource smileForFaceView:self];
    if (smile < -1) smile = -1;
    if (smile > 1) smile = 1;
        
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
}


@end
