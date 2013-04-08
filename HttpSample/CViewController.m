//
//  CViewController.m
//  HttpSample
//
//  Created by Wooseok Seo on 13. 4. 8..
//  Copyright (c) 2013년 Find-Steve. All rights reserved.
//

#import "CViewController.h"
#import "HTTPRequest.h"

@interface CViewController ()

@end

@implementation CViewController

@synthesize txtUrl, txtOutput;


#define REQUEST_HTTP_CALL   1

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickedRequestCall:(id)sender {
    // URL String from Text Box
    NSString *url = txtUrl.text;
    
    // Craete HttpRequset instance.
    HTTPRequest *httpRequest = [[HTTPRequest alloc] init];
    
    // You need to set up a tag if you call different requests.
    // Different requests are distinguished by a tag
    httpRequest.tag = REQUEST_HTTP_CALL;
    
    // Set up for a content type.
    httpRequest.contentType = @"application/json;";
    
    // A body message is required when you call a request with Post method.
    NSString *body = [NSString stringWithFormat:@""];
    
    // The following delegate will be called by the request instance when the http call is finished.
    [httpRequest setDelegate:self selector:@selector(didReceiveFinished:)];
    
    // Error delegate will be called when there is a error.
    // If you don't mind whether there is a error or not, just set it nil.
    [httpRequest setErrorDelegate:self selector:nil];
    
    // Finally!
    [httpRequest requestUrl:url bodyString:body sendMethod:GET_METHOD];
}


- (void)didReceiveFinished:(NSArray*) objects {
    // objects[0] = HTTPRequest instance
    HTTPRequest* request = (HTTPRequest*) [objects objectAtIndex:0];
    
    // objects[1] = returned string
    NSString* returnString = (NSString*) [objects objectAtIndex:1];
    
    // A request can be distinguished by a tag number.
    if (request.tag == REQUEST_HTTP_CALL) {
        txtOutput.text = returnString;
    }
}


@end
