//
//  PsychologistViewController.m
//  Psychologist
//
//  Created by Michael Mellinger on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PsychologistViewController.h"
#import "HappinessViewController.h"

@interface PsychologistViewController ()
@property (nonatomic) int diagnosis;

@end

@implementation PsychologistViewController

@synthesize diagnosis = _diagnosis;




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowDiagnosis"]) {
        // segue.destinationViewController is of type id
        // embed in Navigation Controller @ 58m
        // @ 1hr 2m for multiple ViewControllers
        [segue.destinationViewController setHappiness:self.diagnosis];
        
    } else if ([segue.identifier isEqualToString:@"Celebrity"]) {
        [segue.destinationViewController setHappiness:100];

    } else if ([segue.identifier isEqualToString:@"Serious"]) {
        [segue.destinationViewController setHappiness:20];

    } else if ([segue.identifier isEqualToString:@"TV Kook"]) {
        [segue.destinationViewController setHappiness:50];

    }
}

/* If Detail view controller of Splitview controller is a HappinessViewController, return its id, otherwise return nil
 */

-(HappinessViewController *)splitViewHappinessViewController {
    
    id hvc = [self.splitViewController.viewControllers lastObject];
    // assert: hvc == nil on iPhone

    // Let's be extra safe
    if (![hvc isKindOfClass:[HappinessViewController class]]) {
        hvc = nil;
    }
    return hvc;
}


/*
  Target/Action way to handle segues
 */
-(void)setAndShowDiagnosis:(int)diagnosis {
    self.diagnosis = diagnosis;

    // @ 53m Fall 2011
    if ([self splitViewHappinessViewController]) {

        [self splitViewHappinessViewController].happiness = diagnosis;
    
    } else { // Only doing this on the iPad
        [self performSegueWithIdentifier:@"ShowDiagnosis" sender:self];
        
    }
}

- (IBAction)flying {
    [self setAndShowDiagnosis: 85];
}

- (IBAction)apple {
    [self setAndShowDiagnosis: 100];

}


- (IBAction)dragons {
    [self setAndShowDiagnosis: 20];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
