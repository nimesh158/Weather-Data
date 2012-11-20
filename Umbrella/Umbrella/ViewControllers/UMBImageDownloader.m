//
//  UMBImageDownloader.m
//  Umbrella
//
//  Created by Nimesh Desai on 11/20/12.
//  Copyright (c) 2012 Nimesh Desai. All rights reserved.
//

#import "UMBImageDownloader.h"

@interface UMBImageDownloader ()
@end

@implementation UMBImageDownloader
@synthesize data = _data, downloader = _downloader;

- (void) downloadIcon:(NSString *)iconURL withCompletionBlock:(CompletionBlock)compBlock {
    self.data = [[NSMutableData alloc] init];
    
    completionBlock = [compBlock copy];
    
    NSURL* url = [NSURL URLWithString:iconURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.downloader = [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response {
    [self.data setLength:0];
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection {
    UIImage* image = [UIImage imageWithData:self.data];
    
    completionBlock(YES, image, nil);
}

- (void) connection:(NSURLConnection *) didFailWithError:(NSError *) error {
    completionBlock(NO, nil, error);
}

@end 
