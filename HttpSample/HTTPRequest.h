//
//  Created by Wooseok Seo on 12. 5. 21..
//


#import <Foundation/Foundation.h>

#define POST_METHOD     0
#define GET_METHOD      1
#define DELETE_METHOD   2

@interface HTTPRequest : NSObject
{
    NSMutableData *receivedData;
    NSURLResponse *response;
    NSString *result;
    id target;
    SEL selector;
    NSInteger tag;
}

- (BOOL)requestUrl:(NSString *)url bodyObject:(NSDictionary *)bodyObject isPost:(BOOL)isPost;
- (BOOL)requestUrl:(NSString *)url bodyString:(NSString *)bodyString sendMethod:(int)method;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (void)setErrorDelegate:(id)aTarget selector:(SEL)aSelector;
- (NSString *) syncRequestUrl: (NSString *) url bodyObject:(NSDictionary *)bodyObject;
- (NSString *) syncRequestUrl: (NSString *) url bodyString:(NSString *)bodyString;

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSString *result;
@property id target;
@property id targetError;
@property SEL selector;
@property SEL selectorError;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, retain) NSString *contentType;
@end
