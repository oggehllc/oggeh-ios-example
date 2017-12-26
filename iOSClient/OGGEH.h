//
//  OGGEH.h
//  iOSClient
//
//  Created by Ahmed Abbas on 8/9/16.
//  Copyright (c) 2016 Oggeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OGGEH : NSObject
{
    UITextView *_console;
    NSMutableData *_responseData;
    NSString *_requestBody;
    UIColor *_success;
    UIColor *_danger;
}

@property (nonatomic) NSString *domain;
@property (nonatomic) NSString *apiKey;
@property (nonatomic) NSString *apiSecret;
@property (nonatomic) NSString *sandboxKey;

- (void)apiCall:(NSString *)requestBody :(UITextView *)console;
- (NSString *)hmacHash:(NSString *)plainText withKey:(NSString *)key;
+ (OGGEH *)sharedInstance;

@end
