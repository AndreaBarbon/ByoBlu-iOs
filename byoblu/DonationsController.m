//
//  DonationsController.m
//  byoblu
//
//  Created by Andrea Barbon on 10/03/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "DonationsController.h"
#import "PayPalDonationController.h"

@implementation DonationsController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /*
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
        
        button.frame = CGRectMake(button.frame.origin.x,
                                  button.frame.origin.y + 30, 
                                  button.frame.size.width, 
                                  button.frame.size.height - 30);
        
    }
    */
    
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    webView.scalesPageToFit = YES;
    
    NSError *error;
    NSString* filePath= [[NSBundle mainBundle] pathForResource:@"Donations" ofType:@"txt"];
    NSString *s = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    [webView loadHTMLString:s baseURL:nil];

    
}



-(IBAction)payWithPayPal:(id)sender {
    
    
    NSString* url = @"http://www.byoblu.com/page/sostienimi.aspx";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: url]];
    
    /*
    PayPalDonationController *pp = [[PayPalDonationController alloc] init];
    pp.title = @"Dona con PayPal";
    [self.navigationController pushViewController:pp animated:YES];
    */
}

-(IBAction)payWithAppStore:(id)sender {
    
    
}




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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
