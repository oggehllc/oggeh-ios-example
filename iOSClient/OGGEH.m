//
//  OGGEH.m
//  iOSClient
//
//  Updated by Ahmed Abbas on 12/26/17.
//  Copyright (c) 2014 OGGEH. All rights reserved.
//

#import "RSA.h" // https://github.com/ideawu/Objective-C-RSA
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "OGGEH.h"

@implementation OGGEH

- (void)apiCall:(NSString *)requestBody :(UITextView *)console
{
    if (console != nil) {
        _console = console;
    }
    if (requestBody != nil) {
        _requestBody = requestBody;
    }
    if (_apiKey == nil || [_apiKey isEqualToString:@""] || _apiSecret == nil || [_apiSecret isEqualToString:@""]) {
        if (_console != nil) {
            _console.backgroundColor = [OGGEH _danger];
            _console.text = @"Invalid Parameters!";
        } else {
            NSLog(@"Invalid Parameters!");
        }
    } else {
        _responseData = [[NSMutableData alloc] init];
        
        
        // Sandbox Request:
        // Combine your App domain.ltd with your App API Key
        NSString *sandboxValue = [NSString stringWithFormat:@"%@%@", _domain, _apiKey];
        // Calculate a Hash Message Authentication Code (HMAC + SHA512) using your App Sandbox Key as a shared secret
        NSString *sandbox = [self hmacHash:sandboxValue withKey:_sandboxKey];
        NSString *url = [NSString stringWithFormat: @"https://api.oggeh.com/?api_key=%@", _apiKey];
        
        
        /*
        // Production Request:
        // IMPORTANT: comment out SandBox request above, along with setting SandBox custom header @line 65
        // Define public key file name and extension
        NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"pem"];
        // Load public key contents
        NSString *publicKey = [NSString stringWithContentsOfFile:publicKeyPath encoding:NSUTF8StringEncoding error:NULL];
        // Encrypt your App API Secret using OAEP algorithm (output encoded in base64)
        NSString *encryptedSecret = [RSA encryptString:_apiSecret publicKey:publicKey];
        // Pass the final encoded API Secret as a URL parameter to our endpoint, along with your App API Key
        NSString *url = [NSString stringWithFormat: @"https://api.oggeh.com/?api_key=%@&api_secret=%@", _apiKey, encryptedSecret];
        */
        
        NSData *postData = [requestBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", [postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setTimeoutInterval:10.0];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        // Set SandBox header with HMAC output value
        [request setValue:sandbox forHTTPHeaderField:@"SandBox"];
        [request setHTTPBody:postData];
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(!conn) {
            NSLog(@"Connection Error ..");
        }
        NSLog(@"Request:");
        NSLog(@"Request url %@", url);
        NSLog(@"Request body %@", [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding]);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //
}

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    [_responseData appendData:data];
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection Error: %@", error);
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    @try {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:nil];
        if (json != nil) {
            NSString *error = [NSString stringWithFormat:@"%@", [json objectForKey:@"error"]];
            if ([error isEqual:@""]) {
                NSArray *stack = [json objectForKey:@"stack"];
                if ([stack count] > 0) {
                    NSString *childError = [NSString stringWithFormat:@"%@", stack[0][@"error"]];
                    NSString *output = [NSString stringWithFormat:@"%@", stack[0]];
                    if ([childError isEqual:@""]) {
                        if (![output isEqual:@""]) {
                            if (_console != nil) {
                                _console.backgroundColor = [OGGEH _success];
                                _console.text = output;
                            } else {
                                NSLog(@"%@", output);
                            }
                        } else {
                            if (_console != nil) {
                                _console.backgroundColor = [OGGEH _danger];
                                _console.text = error;
                            } else {
                                NSLog(@"%@", error);
                            }
                            
                        }
                    } else {
                        if (_console != nil) {
                            _console.backgroundColor = [OGGEH _danger];
                            _console.text = childError;
                        } else {
                            NSLog(@"%@", childError);
                        }
                    }
                } else {
                    if (_console != nil) {
                        _console.backgroundColor = [OGGEH _danger];
                        _console.text = @"empty stack response!";
                    } else {
                        NSLog(@"empty stack response!");
                    }
                    NSLog(@"Response %@", _responseData);
                }
            } else {
                if (_console != nil) {
                    _console.backgroundColor = [OGGEH _danger];
                    _console.text = error;
                } else {
                    NSLog(@"%@", error);
                }
                NSLog(@"Response %@", _responseData);
            }
        } else {
            if (_console != nil) {
                _console.backgroundColor = [OGGEH _danger];
                _console.text = @"unable to parse json data!";
            } else {
                NSLog(@"unable to parse json data!");
            }
            NSLog(@"Response %@", _responseData);
        }
    }
    @catch (NSException *e) {
        NSString *ex = [NSString stringWithFormat: @"Exception: %@", e];
        if (_console != nil) {
            _console.backgroundColor = [OGGEH _danger];
            _console.text = ex;
        } else {
            NSLog(@"%@", e);
        }
        NSLog(@"Response %@", _responseData);
    }
    @finally {
        //
    }
    _responseData = nil;
}

-(NSString *)hmacHash:(NSString *)plainText withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plainText cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    
    for (int i = 0; i < HMACData.length; ++i)
        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long)buffer[i]];
    
    return HMAC;
}

+ (OGGEH *)sharedInstance
{
    static OGGEH *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

+(UIColor *)_success
{
    return [UIColor colorWithRed:204.0/255.0f green:240.0/255.0f blue:191.0/255.0f alpha:1.0];
}

+(UIColor *)_danger
{
    return [UIColor colorWithRed:240.0/255.0f green:192.0/255.0f blue:192.0/255.0f alpha:1.0];
}

@end
