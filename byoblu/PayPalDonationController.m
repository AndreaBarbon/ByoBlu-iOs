//
//  PayPalDonationController.m
//  byoblu
//
//  Created by Andrea Barbon on 10/03/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import "PayPalDonationController.h"

@implementation PayPalDonationController

#pragma mark - fractal

- (void)viewDidLoad
{
    [super viewDidLoad];

}

#pragma mark - PayPal

-(IBAction)payWithPayPal:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    NSString *s = btn.titleLabel.text;
    s = [s substringToIndex:[s length] - 2];
    
    NSLog(@"donazione con PayPal in corso");
    
    PayPalPayment *currentPayment = [[PayPalPayment alloc] init];
    currentPayment.paymentCurrency = @"EUR"; 
    currentPayment.paymentType = TYPE_GOODS; 
    currentPayment.subTotal = [NSDecimalNumber decimalNumberWithString: s]; 
    currentPayment.recipient = @"byoblu@gmail.com";
    currentPayment.merchantName = @"ByoBlu"; 
    currentPayment.invoiceData = [[PayPalInvoiceData alloc] init];
    
    [[PayPal getPayPalInst] checkoutWithPayment:currentPayment];

    
}

-(IBAction)customAmount:(id)sender {
    
}

-(void)paymentLibraryExit {
    
    NSLog(@"Donazione effettuata con successo!");

}


//paymentSuccessWithKey:andStatus: is a required method. in it, you should record that the payment
//was successful and perform any desired bookkeeping. you should not do any user interface updates.
//payKey is a string which uniquely identifies the transaction.
//paymentStatus is an enum value which can be STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
}

//paymentFailedWithCorrelationID is a required method. in it, you should
//record that the payment failed and perform any desired bookkeeping. you should not do any user interface updates.
//correlationID is a string which uniquely identifies the failed transaction, should you need to contact PayPal.
//errorCode is generally (but not always) a numerical code associated with the error.
//errorMessage is a human-readable string describing the error that occurred.
- (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
    
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
	NSLog(@"errorId: %@", errorId);
	NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
	NSLog(@"message: %@", message);
    
}

//paymentCanceled is a required method. in it, you should record that the payment was canceled by
//the user and perform any desired bookkeeping. you should not do any user interface updates.
- (void)paymentCanceled {

}



#pragma mark - View lifecycle

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
