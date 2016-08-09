//
//  TKMFileManager.h
//  TKMFileManager
//
//  Created by Tom Metzger on 8/8/16.
//  Copyright © 2016 Tom Metzger. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface TKMFileManager : NSObject

@property (readonly, nonatomic) NSString *documentsDirectory;
@property (readonly, nonatomic) NSString *mainBundleDirectory;




- (void)init;


- (void)createDirectory:(NSString *)newDirectoryPath;

- (void)createSubdirectory:(NSString *)subdirectoryName inDirectory:(NSString *)directoryPath;


- (void)copyDirectory:(NSString *)directoryPath toDirectory:(NSString *)destinationDirectoryPath;


- (void)moveDirectory:(NSString *)directoryPath toDirectory:(NSString *)destinationDirectoryPath;


- (void)deleteDirectory:(NSString *)directoryPath;


- (NSString *)getFile:(NSString *)filename inDirectory:(NSString *)directoryPath;

- (NSString *)findAndGetFile:(NSString *)filename;


- (void)copyFile:(NSString *)filePath toDirectory:(NSString *)destinationDirectoryPath;

- (void)findAndCopyFile:(NSString *)filename toDirectory:(NSString *)destinationDirectoryPath;


- (void)moveFile:(NSString *)filePath toDirectory:(NSString *)destinationDirectoryPath;

- (void)findAndMoveFile:(NSString *)filename toDirectory:(NSString *)destinationDirectoryPath;


- (void)deleteFile:(NSString *)filePath;

- (void)findAndDeleteFile:(NSString *)filename;

@end
