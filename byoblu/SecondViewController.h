//
//  SecondViewController.h
//  byoblu
//
//  Created by Andrea Barbon on 06/01/12.
//  Copyright (c) 2012 Università degli studi di Padova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchXML.h"


@interface SecondViewController : UIViewController {
    
    NSMutableData *data; //keep reference to the data so we can collect it as it downloads
    NSMutableArray *videos;	
    CXMLNode *infoNode;
}

@end
