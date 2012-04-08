//
//  RotableViewController.m
//  Psychologist
//
//  Created by Michael Mellinger on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RotableViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface RotableViewController ()

@end

/*
 Going to make this the delegate because it's always on screen.  @56m 30s
 */

@implementation RotableViewController

-(void)awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

-(id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter {
    id detailVC = [self.splitViewController.viewControllers lastObject];
    
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc
                inOrientation:(UIInterfaceOrientation)orientation
{
//    return NO; // Simply return NO if you want the left Nav to always show
    // Only do "button dance" in portrait
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
    
}


-(void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.navigationItem.title;
    NSLog(@"Title: %@", self.navigationItem.title);
    NSLog(@"Obj: %@", self);

    // tell detail view to put the button up
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}


-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController
    invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // tell the detail view to take the button away
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
