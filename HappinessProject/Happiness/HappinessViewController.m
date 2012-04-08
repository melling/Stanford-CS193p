//
//  HappinessViewController.m
//  Happiness
//
//  Created by Michael Mellinger on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HappinessViewController.h"
#import "FaceView.h"

@interface HappinessViewController () <FaceViewDataSource>

@property (nonatomic, weak) IBOutlet FaceView *faceView;

@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;

// Implement our own setter so we can add the gesture recognizer

-(void)setFaceView:(FaceView *)faceView {
    _faceView = faceView;
    
    // The handler is the view
    [self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
    
    // Handler is the controller
    [self.faceView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHappinessGesture:)]];
    
    self.faceView.dataSource = self;
                                                                                                                        
}

-(void)handleHappinessGesture: (UIPanGestureRecognizer *)gesture {
    
    if ((gesture.state == UIGestureRecognizerStateChanged) || 
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.faceView];
        self.happiness -= translation.y / 2; // Don't make it too sensitive
        [gesture setTranslation:CGPointZero inView:self.faceView]; // reset
    }
}


-(float)smileForFaceView:(FaceView *)sender {

    return (self.happiness - 50)/ 50.0;
}

-(void) setHappiness:(int)happiness {
    _happiness = happiness;
    [self.faceView setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return YES;
}

@end
