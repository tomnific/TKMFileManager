//
//  TKMFileManager.m
//  Revera
//
//  Created by Tom Metzger on 8/8/16.
//  Copyright © 2016 Tom Metzger. All rights reserved.
//

#import "TKMFileManager.h"





@implementation TKMFileManager
{
	NSArray *paths;
}




- (id)init
{
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	_documentsDirectory = [paths objectAtIndex:0];
	
	
	_mainBundleDirectory = [[NSBundle mainBundle] resourcePath];
	
	
	
	return self;
}




- (void)createDirectory:(NSString *)newDirectoryPath
{
	NSError *error;
	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectoryPath isDirectory:YES])
	{
		NSLog(@"Creating Directory: '%@'", newDirectoryPath);
		[[NSFileManager defaultManager] createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:NO attributes:nil error:&error];
	}
	else
	{
		NSLog(@"ERROR: Could Not Create Directory '%@'", newDirectoryPath);
		NSLog(@"    RESULTING ERROR: %@", error);
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
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectoryPath isDirectory:YES])
	{
		NSLog(@"Creating Directory: '%@'", newDirectoryPath);
		[[NSFileManager defaultManager] createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:NO attributes:nil error:&error];
	}
	else
	{
		NSLog(@"ERROR: Could Not Create Directory '%@'", newDirectoryPath);
		NSLog(@"    RESULTING ERROR: %@", error);
	}
}




- (void)copyDirectory:(NSString *)directoryPath toDirectory:(NSString *)destinationDirectoryPath
{
	NSError *error;
	NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:&error];
	
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:destinationDirectoryPath isDirectory:YES])
	{
		[[NSFileManager defaultManager] removeItemAtPath:destinationDirectoryPath error:&error];
	}
	
	
	NSLog(@"Copying Contents Of Directory: '%@'\nTo Directory: '%@'", directoryPath, destinationDirectoryPath);
	
	if ([files count] > 0)
	{
		/*for (int i = 0; i < [files count]; i++)
		 {
			NSString *filePath = [directoryPath stringByAppendingString:[@"/" stringByAppendingString:files[i]]];
			NSString *newPathForFile = [destinationDirectoryPath stringByAppendingString:[@"/" stringByAppendingString:files[i]]];
			
			if (![[NSFileManager defaultManager] fileExistsAtPath:newPathForFile])
			{
		 NSLog(@"Copying File: '%@' \nTo Directory: '%@'", filePath, destinationDirectoryPath);
		 [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:newPathForFile error:&error];
			}
			else
			{
		 NSLog(@"ERROR: Could Not Copy File: '%@'\nTo Directory: '%@'", filePath, destinationDirectoryPath);
		 NSLog(@"    RESULTING ERROR: %@", [error localizedDescription]);
			}
		 }*/
		
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
	
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:destinationDirectoryPath isDirectory:YES])
	{
		[[NSFileManager defaultManager] removeItemAtPath:destinationDirectoryPath error:&error];
	}
	
	
	NSLog(@"Moving Contents Of Directory: '%@'\nTo Directory: '%@'", directoryPath, destinationDirectoryPath);
	
	if ([files count] > 0)
	{
		/*for (int i = 0; i < [files count]; i++)
		 {
			NSString *filePath = [directoryPath stringByAppendingString:[@"/" stringByAppendingString:files[i]]];
			NSString *newPathForFile = [destinationDirectoryPath stringByAppendingString:[@"/" stringByAppendingString:files[i]]];
			
			if (![[NSFileManager defaultManager] fileExistsAtPath:newPathForFile])
			{
		 NSLog(@"Copying File: '%@' \nTo Directory: '%@'", filePath, destinationDirectoryPath);
		 [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:newPathForFile error:&error];
			}
			else
			{
		 NSLog(@"ERROR: Could Not Copy File: '%@'\nTo Directory: '%@'", filePath, destinationDirectoryPath);
		 NSLog(@"    RESULTING ERROR: %@", [error localizedDescription]);
			}
		 }*/
		
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




- (void)deleteDirectory:(NSString *)directoryPath
{
	NSLog(@"Deleting Directory: '%@'", directoryPath);
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:YES])
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
	NSURL *directoryURL = [NSURL fileURLWithPath:directoryPath isDirectory:YES]; // URL pointing to the directory you want to browse
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
	
	
	NSLog(@"Retrieving File: '%@'\nFrom Directory: '%@'", filename, directoryPath);
	
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
	NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:_documentsDirectory isDirectory:YES]; // URL pointing to the directory you want to browse
	NSURL *mainBundleDirectoryURL = [NSURL fileURLWithPath:_mainBundleDirectory isDirectory:YES];
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
	
	
	NSLog(@"Searching Documents Directory For File: '%@'", filename);
	
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
	
	
	NSLog(@"Searching Main Bundle For File: '%@'", filename);
	
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
	NSLog(@"Copying File: '%@'\nTo Directory: '%@'", filePath, destinationDirectoryPath);
	
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
	
	
	
	NSLog(@"Copying File: '%@'\nTo Directory: '%@'", pathOfFile, destinationDirectoryPath);
	
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
	NSLog(@"Moving File: '%@'\nTo Directory: '%@'", filePath, destinationDirectoryPath);
	
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
	
	
	
	NSLog(@"Moving File: '%@'\nTo Directory: '%@'", pathOfFile, destinationDirectoryPath);
	
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
	NSLog(@"Deleting File: '%@'", filePath);
	
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
	
	
	
	NSLog(@"Deleting File: '%@'", pathOfFile);
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:pathOfFile])
	{
		[[NSFileManager defaultManager] removeItemAtPath:pathOfFile error:nil];
	}
	else
	{
		NSLog(@"ERROR: No File To Delete");
	}
	
}

@end
