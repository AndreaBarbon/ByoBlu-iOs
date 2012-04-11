//
//  PayPalDonationController.h
//  byoblu
//
//  Created by Andrea Barbon on 10/03/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPal.h"
#import "PayPalPayment.h"
#import "PayPalReceiverPaymentDetails.h"
#import "PayPalInvoiceItem.h"


@interface PayPalDonationController : UIViewController <PayPalPaymentDelegate> {
    
}

-(IBAction)payWithPayPal:(id)sender;
-(void)paymentLibraryExit;
-(IBAction)customAmount:(id)sender;

@end