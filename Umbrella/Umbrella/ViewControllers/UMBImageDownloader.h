//
//  UMBImageDownloader.h
//  Umbrella
//
//  Created by Nimesh Desai on 11/20/12.
//  Copyright (c) 2012 Nimesh Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @typedef IconDownloaderCompletionBlock
 @abstract A block that will be called when the Icon downloading request is complete.
 @param success YES if the request was successful
 @param error An NSError that occurred, if there was one (will only be present if the request was not successful)
 */
typedef void(^IconDownloaderCompletionBlock)(BOOL success, UIImage* result, NSError* error);

@interface UMBImageDownloader : NSObject {
    IconDownloaderCompletionBlock completionBlock;
}

/*!
 @method data
 @abstract The data object that holds the icon image.
 */
@property (strong, nonatomic) NSMutableData* data;

/*!
 @method downloader
 @abstract Performs the actual downloading of the icon.
 */
@property (strong, nonatomic) NSURLConnection* downloader;

/*!
 @method downloadIcon:withCompletionBlock:
 @abstract Retrives the icon image from the iconURL and calls the completion block on success/failure. Must be called on main thread.
 @param iconURL the url string of the icon
 @param completionBlock The completion block to be executed when the request has completed. The completion block will be called on the main thread.
 */
- (void) downloadIcon:(NSString *)iconURL withCompletionBlock:(IconDownloaderCompletionBlock)compBlock;
@end
