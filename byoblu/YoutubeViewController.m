//
//  YoutubeViewController.m
//  byoblu
//
//  Created by Andrea Barbon on 02/02/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "YoutubeViewController.h"

@implementation YoutubeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

}

- (UIButton *)findButtonInView:(UIView *)view {
	UIButton *button = nil;
    
	if ([view isMemberOfClass:[UIButton class]]) {
		return (UIButton *)view;
	}
    
	if (view.subviews && [view.subviews count] > 0) {
		for (UIView *subview in view.subviews) {
			button = [self findButtonInView:subview];
			if (button) return button;
		}
	}
    
	return button;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[[self.view subviews] lastObject] setFrame:self.view.frame];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)        
        return (YES);
    else
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [[[self.view subviews] lastObject] setFrame:self.view.frame];
}

@end
