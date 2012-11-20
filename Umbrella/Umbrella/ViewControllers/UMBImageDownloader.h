//
//  UMBImageDownloader.h
//  Umbrella
//
//  Created by Nimesh Desai on 11/20/12.
//  Copyright (c) 2012 Nimesh Desai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(BOOL success, UIImage* result, NSError* error);

@interface UMBImageDownloader : NSObject {
    CompletionBlock completionBlock;
}

@property (strong, nonatomic) NSMutableData* data;
@property (strong, nonatomic) NSURLConnection* downloader;

- (void) downloadIcon:(NSString *)iconURL withCompletionBlock:(CompletionBlock)compBlock;
@end
