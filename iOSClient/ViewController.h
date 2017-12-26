//
//  ViewController.h
//  iOSClient
//
//  Created by Ahmed Abbas on 6/1/15.
//  Copyright (c) 2015 Oggeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSURLConnectionDelegate>

@property (nonatomic, strong) IBOutlet UITextView *console_log;
@property (nonatomic, strong) IBOutlet UITextView *request_body;

- (IBAction)start;

@end

