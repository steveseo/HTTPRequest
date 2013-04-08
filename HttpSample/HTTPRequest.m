// Reference.
// http://theeye.pe.kr/entry/http-wrapping-class-with-iphone-network-programming
// # Added for synchronized call
//

#import "HTTPRequest.h"

@implementation HTTPRequest

@synthesize receivedData;
@synthesize response;
@synthesize result;
@synthesize target;
@synthesize targetError;
@synthesize selector;
@synthesize selectorError;
@synthesize tag;
@synthesize contentType = _contentType;

- (BOOL)requestUrl:(NSString *)url bodyString:(NSString *)bodyString sendMethod:(int)method{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0f];
    if (_contentType != nil && ![_contentType isEqual: @""]) {
        [request addValue:_contentType forHTTPHeaderField: @"Content-Type"];
    }
    
    switch (method) {
        case POST_METHOD:
            [request setHTTPMethod:@"POST"];
            break;
        case GET_METHOD:
            [request setHTTPMethod:@"GET"];
            break;
        case DELETE_METHOD:
            [request setHTTPMethod:@"DELETE"];
            break;
    }
    
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(connection)
    {
        receivedData = [[NSMutableData alloc] init];
        return YES;
    }
    
    return NO;
    
}


- (BOOL)requestUrl:(NSString *)url bodyObject:(NSDictionary *)bodyObject sendMethod:(int)method
{
    if(bodyObject)
    {
        NSMutableArray *parts = [NSMutableArray array];
        NSString *part;
        id key;
        id value;
        
        for(key in bodyObject)
        {
            value = [bodyObject objectForKey:key];
            part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                    [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [parts addObject:part];
        }
        
        return [self requestUrl:url bodyString:[parts componentsJoinedByString:@"&"] sendMethod:method];
    }
    
    return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    self.response = aResponse;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(targetError && selectorError)
    {
        NSArray *argArray = [NSArray arrayWithObjects:self, nil,nil];
        
        [targetError performSelector:selectorError withObject:argArray];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if(target && selector)
    {
        NSArray *argArray = [NSArray arrayWithObjects:self, result,nil];
        
        [target performSelector:selector withObject:argArray];
    }
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    self.target = aTarget;
    self.selector = aSelector;
}

- (void)setErrorDelegate:(id)aTarget selector:(SEL)aSelector
{
    self.targetError = aTarget;
    self.selectorError = aSelector;
}


// For the synchronized call
- (NSString *) syncRequestUrl: (NSString *) url bodyString:(NSString *)bodyString {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:5.0f];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];    
 
    return returnString;
}


- (NSString *) syncRequestUrl: (NSString *) url bodyObject:(NSDictionary *)bodyObject {
    if(bodyObject)
    {
        NSMutableArray *parts = [NSMutableArray array];
        NSString *part;
        id key;
        id value;

        for(key in bodyObject)
        {
            value = [bodyObject objectForKey:key];
            part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                    [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [parts addObject:part];
        }
        
        return [self syncRequestUrl:url bodyString:[parts componentsJoinedByString:@"&"]];
    }
    
    return nil;
}


- (void)dealloc
{

}

@end