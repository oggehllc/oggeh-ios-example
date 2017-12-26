//
//  ViewController.m
//  iOSClient
//
//  Created by Ahmed Abbas on 6/1/15.
//  Copyright (c) 2014 OGGEH. All rights reserved.
//

#import "ViewController.h"
#import "OGGEH.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)start;
{
    [OGGEH sharedInstance].domain = @"domain.ltd";
    [OGGEH sharedInstance].apiKey = @"57ff136718d176aae148c8ce9aaf6817";
    [OGGEH sharedInstance].apiSecret = @"ca58365e824a4135a3c537b8f362a863";
    [OGGEH sharedInstance].sandboxKey = @"39e55bb297b9943cfdab5d77cbf4f374";
}

- (IBAction)getResponse;
{
    [[OGGEH sharedInstance] apiCall:_request_body.text :_console_log];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
