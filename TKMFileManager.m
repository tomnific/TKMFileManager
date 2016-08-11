//
//  TKMFileManager.m
//  Revera
//
//  Created by Tom Metzger on 8/8/16.
//  Copyright © 2016 Tom Metzger. All rights reserved.
//

#import "TKMFileManager.h"



#define DEV_DEBUG_MODE NO





@implementation TKMFileManager
{
	NSArray *paths;
	BOOL debugMode;
}




- (id)init
{
	debugMode = false;
	
	
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	_documentsDirectory = [paths objectAtIndex:0];
	
	
	_mainBundleDirectory = [[NSBundle mainBundle] resourcePath];
	
	
	
	return self;
}




- (void)createDirectory:(NSString *)newDirectoryPath
{
	NSError *error;
	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectoryPath])
	{
#if DEV_DEBUG_MODE
		NSLog(@"Creating Directory: '%@'", newDirectoryPath);
#endif
		
#if !DEV_DEBUG_MODE
		if (debugMode)
		{
			NSLog(@"Creating Directory: '%@'", newDirectoryPath);
		}
#endif
		
		[[NSFileManager defaultManager] createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:NO attributes:nil error:&error];
	}
	else
	{
		NSLog(@"ERROR: Could Not Create Directory '%@'", newDirectoryPath);
		NSLog(@"    MOST LIKELY REASON: Directory Already Exists");
		NSLog(@"       RESULTING ERROR: %@", error);
	}
}




- (void)createSubdirectory:(NSString *)subdirectoryName inDirectory:(NSString *)directoryPath
{
	NSError *error;
	NSString *correctedSubdirectoryName;
	
	
	
	correctedSubdirectoryName = subdirectoryName;
	if (![correctedSubdirectoryName hasPrefix:@"/"])
	{
		correctedSubdirectoryName = [@"/" stringByAppendingString:correctedSubdirectoryName];
	}
	
	
	NSString *newDirectoryPath = [_documentsDirectory stringByAppendingPathComponent:correctedSubdirectoryName];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectoryPath])
	{
#if Dev_DEBUG_MODE
		NSLog(@"Creating Directory: '%@'", newDirectoryPath);
#endif
		
#if !DEV_DEBUG_MODE
		if (debugMode)
		{
			NSLog(@"Creating Directory: '%@'", newDirectoryPath);
		}
#endif
		
		[[NSFileManager defaultManager] createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:NO attributes:nil error:&error];
	}
	else
	{
		NSLog(@"ERROR: Could Not Create Directory '%@'", newDirectoryPath);
		NSLog(@"    MOST LIKELY REASON: Directory Already Exists");
		NSLog(@"       RESULTING ERROR: %@", error);
	}
}




- (void)copyDirectory:(NSString *)directoryPath toDirectory:(NSString *)destinationDirectoryPath
{
	NSError *error;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
	
	
	
#if DEV_DEBUG_MODE
	NSLog(@"Copying Contents Of Directory: '%@'\nTo Directory: '%@'", directoryPath, destinationDirectoryPath);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Copying Contents Of Directory: '%@'\nTo Directory: '%@'", directoryPath, destinationDirectoryPath);
	}
#endif
	
	if ([files count] > 0)
	{
		NSError *copyError = nil;
		if (![[NSFileManager defaultManager] copyItemAtPath:directoryPath toPath:destinationDirectoryPath error:&copyError])
		{
			NSLog(@"ERROR: Could Not Copy Files");
			NSLog(@"    RESULTING ERROR: %@", [copyError localizedDescription]);
		}
	}
	else
	{
		NSLog(@"ERROR: Empty Directory: '%@'", directoryPath);
	}
}




- (void)moveDirectory:(NSString *)directoryPath toDirectory:(NSString *)destinationDirectoryPath
{
	NSError *error;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
	
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:destinationDirectoryPath ])
	{
		[[NSFileManager defaultManager] removeItemAtPath:destinationDirectoryPath error:&error];
	}
	
	
#if DEV_DEBUG_MODE
	NSLog(@"Moving Contents Of Directory: '%@'\nTo Directory: '%@'", directoryPath, destinationDirectoryPath);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Moving Contents Of Directory: '%@'\nTo Directory: '%@'", directoryPath, destinationDirectoryPath);
	}
#endif
	
	if ([files count] > 0)
	{
		NSError *copyError = nil;
		if (![[NSFileManager defaultManager] moveItemAtPath:directoryPath toPath:destinationDirectoryPath error:&copyError])
		{
			NSLog(@"ERROR: Could Not Move Files");
			NSLog(@"    RESULTING ERROR: %@", [copyError localizedDescription]);
		}
	}
	else
	{
		NSLog(@"ERROR: Empty Directory: '%@'", directoryPath);
	}
}



- (void)renameDirectory:(NSString *)directoryPath toName:(NSString *)newName
{
	NSString *pathOfNewName;
	
	
	
	if (![newName hasPrefix:@"/"])
	{
		pathOfNewName = [[directoryPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
	}
	else
	{
		pathOfNewName = [[directoryPath stringByDeletingLastPathComponent] stringByAppendingString:newName];
	}
	
	
#if DEV_DEBUG_MODE
	NSLog(@"Renaming Directory '%@' to '%@'", directoryPath, pathOfNewName);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Renaming Directory '%@' to '%@'", directoryPath, pathOfNewName);
	}
#endif
	
	[self createDirectory:pathOfNewName];
	[self moveDirectory:directoryPath toDirectory:pathOfNewName];
}




- (void)deleteDirectory:(NSString *)directoryPath
{
#if DEV_DEBUG_MODE
	NSLog(@"Deleting Directory: '%@'", directoryPath);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Deleting Directory: '%@'", directoryPath);
	}
#endif
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath ])
	{
		[[NSFileManager defaultManager] removeItemAtPath:directoryPath error:nil];
	}
	else
	{
		NSLog(@"ERROR: No Directory To Delete");
	}
}



- (NSString *)getFile:(NSString *)filename inDirectory:(NSString *)directoryPath
{
	BOOL fileFound = false;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *directoryURL = [NSURL fileURLWithPath:directoryPath ]; // URL pointing to the directory you want to browse
	NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
	
	NSDirectoryEnumerator *enumerator = [fileManager
										 enumeratorAtURL:directoryURL
										 includingPropertiesForKeys:keys
										 options:0
										 errorHandler:^(NSURL *url, NSError *error)
										 {
											 // Handle the error.
											 // Return YES if the enumeration should continue after the error.
											 return YES;
										 }];
	
	
#if DEV_DEBUG_MODE
	NSLog(@"Retrieving File: '%@'\nFrom Directory: '%@'", filename, directoryPath);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Retrieving File: '%@'\nFrom Directory: '%@'", filename, directoryPath);
	}
#endif
	
	for (NSURL *url in enumerator)
	{
		NSError *error;
		NSNumber *isDirectory = nil;
		if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error])
		{
			// handle error
		}
		else if (! [isDirectory boolValue])
		{
			if([[url absoluteString] hasSuffix:filename])
			{
				fileFound = true;
				return url.path;
			}
		}
	}
	
	
	if (!fileFound)
	{
		NSLog(@"ERROR: File Not Found In Directory");
		return NULL;
	}
	else
	{
		NSLog(@"ERROR: File Found But Not Returned");
		return NULL;
	}
}




- (NSString *)findAndGetFile:(NSString *)filename
{
	BOOL fileFound = false;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:_documentsDirectory ]; // URL pointing to the directory you want to browse
	NSURL *mainBundleDirectoryURL = [NSURL fileURLWithPath:_mainBundleDirectory ];
	NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
	
	NSDirectoryEnumerator *documentsEnumerator = [fileManager
												  enumeratorAtURL:documentsDirectoryURL
												  includingPropertiesForKeys:keys
												  options:0
												  errorHandler:^(NSURL *url, NSError *error)
												  {
													  // Handle the error.
													  // Return YES if the enumeration should continue after the error.
													  return YES;
												  }];
	
	NSDirectoryEnumerator *mainBundleEnumerator = [fileManager
												   enumeratorAtURL:mainBundleDirectoryURL
												   includingPropertiesForKeys:keys
												   options:0
												   errorHandler:^(NSURL *url, NSError *error)
												   {
													   // Handle the error.
													   // Return YES if the enumeration should continue after the error.
													   return YES;
												   }];
	
	
#if DEV_DEBUG_MODE
	NSLog(@"Searching Documents Directory For File: '%@'", filename);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Searching Documents Directory For File: '%@'", filename);
	}
#endif
	
	for (NSURL *url in documentsEnumerator)
	{
		NSError *error;
		NSNumber *isDirectory = nil;
		if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error])
		{
			// handle error
		}
		else if (! [isDirectory boolValue])
		{
			if([[url absoluteString] hasSuffix:filename])
			{
				fileFound = true;
				return url.path;
			}
		}
	}
	
	
#if DEV_DEBUG_MODE
	NSLog(@"Searching Main Bundle For File: '%@'", filename);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Searching Main Bundle For File: '%@'", filename);
	}
#endif
	
	for (NSURL *url in mainBundleEnumerator)
	{
		NSError *error;
		NSNumber *isDirectory = nil;
		if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error])
		{
			// handle error
		}
		else if (! [isDirectory boolValue])
		{
			if([[url absoluteString] hasSuffix:filename])
			{
				fileFound = true;
				return url.path;
			}
		}
	}
	
	
	if (!fileFound)
	{
		NSLog(@"ERROR: File Not Found In Documents Directory Or Main Bundle Directory");
		return NULL;
	}
	else
	{
		NSLog(@"ERROR: File Found But Not Returned");
		return NULL;
	}
}




- (void)copyFile:(NSString *)filePath toDirectory:(NSString *)destinationDirectoryPath
{
#if DEV_DEBUG_MODE
	NSLog(@"Copying File: '%@'\nTo Directory: '%@'", filePath, destinationDirectoryPath);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Copying File: '%@'\nTo Directory: '%@'", filePath, destinationDirectoryPath);
	}
#endif
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:destinationDirectoryPath])
	{
		[self createDirectory:destinationDirectoryPath];
	}
	
	if ([[NSFileManager defaultManager] isReadableFileAtPath:filePath])
	{
		[[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:filePath] toURL:[NSURL fileURLWithPath:[destinationDirectoryPath stringByAppendingString:[@"/" stringByAppendingString:[filePath lastPathComponent]]]] error:nil];
	}
	else
	{
		NSLog(@"ERROR: Unable To Copy File: '%@' - Does Not Exist", filePath);
	}
}



- (void)findAndCopyFile:(NSString *)filename toDirectory:(NSString *)destinationDirectoryPath
{
	NSString *pathOfFile = [self findAndGetFile:filename];
	
	
	
#if DEV_DEBUG_MODE
	NSLog(@"Copying File: '%@'\nTo Directory: '%@'", pathOfFile, destinationDirectoryPath);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Copying File: '%@'\nTo Directory: '%@'", pathOfFile, destinationDirectoryPath);
	}
#endif
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:destinationDirectoryPath])
	{
		[self createDirectory:destinationDirectoryPath];
	}
	
	if ([[NSFileManager defaultManager] isReadableFileAtPath:pathOfFile])
	{
		[[NSFileManager defaultManager] copyItemAtURL:[NSURL fileURLWithPath:pathOfFile] toURL:[NSURL fileURLWithPath:[destinationDirectoryPath stringByAppendingString:[@"/" stringByAppendingString:[pathOfFile lastPathComponent]]]] error:nil];
	}
	else
	{
		NSLog(@"ERROR: Unable To Copy File: '%@' - Does Not Exist", pathOfFile);
	}
}




- (void)moveFile:(NSString *)filePath toDirectory:(NSString *)destinationDirectoryPath
{
#if DEV_DEBUG_MODE
	NSLog(@"Moving File: '%@'\nTo Directory: '%@'", filePath, destinationDirectoryPath);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Moving File: '%@'\nTo Directory: '%@'", filePath, destinationDirectoryPath);
	}
#endif
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:destinationDirectoryPath])
	{
		[self createDirectory:destinationDirectoryPath];
	}
	
	if ([[NSFileManager defaultManager] isReadableFileAtPath:filePath])
	{
		[[NSFileManager defaultManager] moveItemAtURL:[NSURL fileURLWithPath:filePath] toURL:[NSURL fileURLWithPath:[destinationDirectoryPath stringByAppendingString:[@"/" stringByAppendingString:[filePath lastPathComponent]]]] error:nil];
	}
	else
	{
		NSLog(@"ERROR: Unable To Move File: '%@' - Does Not Exist", filePath);
	}
}




- (void)findAndMoveFile:(NSString *)filename toDirectory:(NSString *)destinationDirectoryPath
{
	NSString *pathOfFile = [self findAndGetFile:filename];
	
	
	
#if DEV_DEBUG_MODE
	NSLog(@"Moving File: '%@'\nTo Directory: '%@'", pathOfFile, destinationDirectoryPath);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Moving File: '%@'\nTo Directory: '%@'", pathOfFile, destinationDirectoryPath);
	}
#endif
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:destinationDirectoryPath])
	{
		[self createDirectory:destinationDirectoryPath];
	}
	
	if ([[NSFileManager defaultManager] isReadableFileAtPath:pathOfFile])
	{
		[[NSFileManager defaultManager] moveItemAtURL:[NSURL fileURLWithPath:pathOfFile] toURL:[NSURL fileURLWithPath:[destinationDirectoryPath stringByAppendingString:[@"/" stringByAppendingString:[pathOfFile lastPathComponent]]]] error:nil];
	}
	else
	{
		NSLog(@"ERROR: Unable To Move File: '%@' - Does Not Exist", pathOfFile);
	}
}




- (void)deleteFile:(NSString *)filePath
{
#if DEV_DEBUG_MODE
	NSLog(@"Deleting File: '%@'", filePath);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Deleting File: '%@'", filePath);
	}
#endif
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
	}
	else
	{
		NSLog(@"ERROR: No File To Delete");
	}
}




- (void)findAndDeleteFile:(NSString *)filename
{
	NSString *pathOfFile = [self findAndGetFile:filename];
	
	
	
#if DEV_DEBUG_MODE
	NSLog(@"Deleting File: '%@'", pathOfFile);
#endif
	
#if !DEV_DEBUG_MODE
	if (debugMode)
	{
		NSLog(@"Deleting File: '%@'", pathOfFile);
	}
#endif
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:pathOfFile])
	{
		[[NSFileManager defaultManager] removeItemAtPath:pathOfFile error:nil];
	}
	else
	{
		NSLog(@"ERROR: No File To Delete");
	}
	
}




- (void)setDebugMode:(BOOL *)debug
{
	debugMode = debug;
}

@end
