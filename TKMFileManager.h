//
//  TKMFileManager.h
//  Revera
//
//  Created by Tom Metzger on 8/8/16.
//  Copyright © 2016 Tom Metzger. All rights reserved.
//
/*!
 @header TKFileManager.h
 
 @brief This is the header file for the TKMFileManager.
 
 This file contains the most importnant method and properties decalaration.
 
 @author Tom Metzger
 @copyright  2015 Tom Metzger
 @version    1.0
 */

#import <Foundation/Foundation.h>





/*!
 @class TKFileManager
 
 @brief The TKFileManager class
 
 @discussion    This class was developed to make file management in iOS easier, and with less lines of code.
 
 @superclass SuperClass: NSObject
 */
@interface TKMFileManager : NSObject

/*! @brief This readonly property holds the string path of the app's Documents Directory. */
@property (readonly, nonatomic) NSString *documentsDirectory;
/*! @brief This readonly property holds the string path of the directory of the app's Main Bundle. */
@property (readonly, nonatomic) NSString *mainBundleDirectory;



/*!
 @brief Initializes the `TKMFileManager` object.
 
 @discussion Assigns the correct paths to `documentsDirectory` and `mainBundleDirectory`. Then it returns itself as the `TKMFileManager` object.
 
 ```
	TKMFileManager *manager = [[TKMFileManager alloc] init];
 ```
 
 @return id - After initializing the paths, it returns itself.
 */
- (id)init;


/*!
 @brief Creates a new directory at `newDirectoryPath`.
 
 @discussion Creates a new directory at `newDirectoryPath`, if it doesn't already exist.
 
 ```
	NSString *newDirectory = [manager.documentsDirectory stringByAppendingPathComponent:@"NewDirectory"]];
	[manager createDirectory:newDirectory];
 ```
 
 @warning The path must be a valid path that is accessible in the app's sandbox.
 
 @param newDirectoryPath The full path for the directory you wish to create.
 
 @return void - there isn't anything to return.
 */
- (void)createDirectory:(NSString *)newDirectoryPath;

/*!
 @brief Creates a subdirectory named `subdirectoryName` in `directoryPath`.
 
 @discussion Creates a new directory at `subdirectoryName`, if it doesn't already exist.
 
 ```
	NSString *subdirectory = @"/SubDirectory";
	[manager createSubdirectory:subdirectory inDirectory:manager.documentsDirectory];
 ```
 
 @warning If `subdirectoryName` does not contain "/" at the beginning, it will automatically be added.
 
 @param subdirectoryName The name of the subdirectory you wish to create.
 
 @param directoryPath The path of the directory in which you wish to make a subdirectory.
 
 @return void - there isn't anything to return.
 */
- (void)createSubdirectory:(NSString *)subdirectoryName inDirectory:(NSString *)directoryPath;


/*!
 @brief Copies the contents of one directory into another.
 
 @discussion Copies the contents of `directoryPath` into `destinationDirectoryPath`.
 
 ```
	[manager copyDirectory:manager.mainBundleDirectory toDirectory:manager.documentsDirectory];
 ```
 
 @warning It does <b>not</b> create a new directory for the files to be copied into.
 
 @param directoryPath The path of the directory who's contents you'd like to copy.
 
 @param destinationDirectoryPath The path of the directory into which you'd like the contents of `directoryPath` to be copied.
 
 @return void - there isn't anything to return.
 */
- (void)copyDirectory:(NSString *)directoryPath toDirectory:(NSString *)destinationDirectoryPath;


/*!
 @brief Moves the contents of one directory into another.
 
 @discussion Moves the contents of `directoryPath` into `destinationDirectoryPath`. <b>Note:</b> `directoryPath` is deleted as a result of this operation
 
 ```
	[manager moveDirectory:manager.mainBundleDirectory toDirectory:mainBundleInDocuments];
 ```
 
 @warning It does <b>not</b> create a new directory for the files to be moved into. Also, it is not recommended to move the contents of the Main Bundle into the Documents Directory.
 
 @param directoryPath The path of the directory who's contents you'd like to move.
 
 @param destinationDirectoryPath The path of the directory into which you'd like the contents of `directoryPath` to be moved.
 
 @return void - there isn't anything to return.
 */
- (void)moveDirectory:(NSString *)directoryPath toDirectory:(NSString *)destinationDirectoryPath;


/*!
 @brief Renames the directory located at `directoryPath` to `newName`.
 
 @discussion Under the hood, what this really does is creates a new directory at the same level as `directoryPath` with the name of `newName`, then moves the contents of `directoryPath` to `newName`'s directory.
 
 ```
	NSString *directoryToRename = [manager.documentsDirectory stringByAppendingPathComponent:@"/SubDirectory"];
	[manager renameDirectory:directoryToRename toDirectory:@"RenamedDirectory"];
 ```
 
 @warning Do not attempt to use this method to rename files
 
 @param directoryPath The path of the directory you'd like to rename.
 
 @param newName The new name you'd like to give the directory.
 
 @return void - there isn't anything to return.
 */
- (void)renameDirectory:(NSString *)directoryPath toName:(NSString *)newName;


/*!
 @brief Deletes a directory and its contents.
 
 @discussion Deletes a directory and its contents.
 
 ```
	[manager deleteDirectory:manager.documentsDirectory];
 ```
 
 @warning Deleting the Main Bundle directory or the Documents Directory is not recommended.
 
 @param directoryPath The path of the directory you'd like to delete.
 
 @return void - there isn't anything to return.
 */
- (void)deleteDirectory:(NSString *)directoryPath;


/*!
 @brief Returns the filepath of a file located in the desired directory.
 
 @discussion Returns the filepath of a file named `filename` located in the directory `directoryPath`.
 
 ```
	NSString *exampleFilePath = [manager getFile:@"example.png" inDirectory:manager.documentsDirectory];
 ```
 
 @param filename The name of the file who's full path you'd like to retrieve.
 
 @param directoryPath The path of the directory which contains the file `filename`.
 
 @return NSString - An NSString containing the path to the desired file.
 */
- (NSString *)getFile:(NSString *)filename inDirectory:(NSString *)directoryPath;

/*!
 @brief Returns the filepath of a file located in an unknown directory.
 
 @discussion Recursively searches all available directories in the app's sandbox and returns the path to the first instance of a file named `filename`.
 
 ```
	NSString *exampleFilePath = [manager findAndGetFile:@"example.png"];
 ```
 
 @warning For use when the directory the desired file is located in is not known.
 
 @param filename The name of the file you'd like to retrieve the path of, but don't know the directory of.
 
 @return NSString - An NSString containing the path to the desired file.
 */
- (NSString *)findAndGetFile:(NSString *)filename;


/*!
 @brief Copies a file to a specified directory.
 
 @discussion Copies a file with the path `filePath` to a directory with the path `directoryPath`. If `directoryPath` doesn't exist, it is created.
 
 ```
	NSString *exampleFilePath = [manager.mainBundleDirectory stringByAppendingPathComponent:@"example.txt"];
	[manager copyFile:exampleFilePath toDirectory:manager.documentsDirectory];
 ```
 
 @param filePath The path of the file you'd like to copy.
 
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be copied.
 
 @return void - there isn't anything to return.
 */
- (void)copyFile:(NSString *)filePath toDirectory:(NSString *)destinationDirectoryPath;

/*!
 @brief Finds, then copies a file to a specified directory.
 
 @discussion Recursively searches all available directories for a file named `filename`, then copies the first found instance to a directory with the path `directoryPath`. If `directoryPath` doesn't exist, it is created.
 
 ```
	[manager findAndCopyFile:@"example.txt" toDirectory:manager.documentsDirectory];
 ```
 
 @param filename The name of the file you'd like to find and copy.
 
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be copied, once found.
 
 @return void - there isn't anything to return.
 */
- (void)findAndCopyFile:(NSString *)filename toDirectory:(NSString *)destinationDirectoryPath;


/*!
 @brief Moves a file to a specified directory.
 
 @discussion Moves a file with the path `filePath` to a directory with the path `directoryPath`. If `directoryPath` doesn't exist, it is created.
 
 ```
	NSString *exampleFilePath = [manager.mainBundleDirectory stringByAppendingPathComponent:@"example.txt"];
	[manager moveFile:exampleFilePath toDirectory:manager.documentsDirectory];
 ```
 
 @param filePath The path of the file you'd like to move.
 
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be moved.
 
 @return void - there isn't anything to return.
 */
- (void)moveFile:(NSString *)filePath toDirectory:(NSString *)destinationDirectoryPath;

/*!
 @brief Finds, then moves a file to a specified directory.
 
 @discussion Recursively searches all available directories for a file named `filename`, then moves the first found instance to a directory with the path `directoryPath`. If `directoryPath` doesn't exist, it is created.
 
 ```
	[manager findAndMoveFile:@"example.txt" toDirectory:manager.documentsDirectory];
 ```
 
 @param filename The name of the file you'd like to find and move.
 
 @param destinationDirectoryPath The path of the directory into which you'd like the file to be moved, once found.
 
 @return void - there isn't anything to return.
 */
- (void)findAndMoveFile:(NSString *)filename toDirectory:(NSString *)destinationDirectoryPath;


/*!
 @brief Deletes the file located at `filePath`.
 
 @discussion Deletes the file located at `filePath`.
 
 ```
	NSString *exampleFilePath = [manager.mainBundleDirectory stringByAppendingPathComponent:@"example.txt"];
	[manager deleteFile:exampleFilePath];
 ```
 
 @param filePath The path of the file you'd like to delete.
 
 @return void - there isn't anything to return.
 */
- (void)deleteFile:(NSString *)filePath;

/*!
 @brief Finds, then deletes a file named `filename`.
 
 @discussion Recursively searches all available directories for a file named `filename`, then deletes the first found instance.
 
 ```
	[manager findAndDeleteFile:@"example.txt"];
 ```
 
 @param filename The name of the file you'd like to delete, once found.
 
 @return void - there isn't anything to return.
 */
- (void)findAndDeleteFile:(NSString *)filename;



/*!
 @brief Sets the TKMFileManager object into Debug Mode.
 
 @discussion Sets the TKMFileManager object into Debug Mode. This will print all `NSLog()` statements, instead of just the ones containing errors. By default, Debug Mode is off.
 
 ```
	[manager setDebugMode:YES];
 ```
 
 @param debug A Boolean that if YES sets Debug Mode on, if NO sets Debug Mode off
 
 @return void - there isn't anything to return.
 */
- (void)setDebugMode:(BOOL *)debug;

@end
