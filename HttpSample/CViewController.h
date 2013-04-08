//
//  CViewController.h
//  HttpSample
//
//  Created by Wooseok Seo on 13. 4. 8..
//  Copyright (c) 2013년 Find-Steve. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtUrl;
@property (strong, nonatomic) IBOutlet UITextView *txtOutput;

- (IBAction)clickedRequestCall:(id)sender;
@end
