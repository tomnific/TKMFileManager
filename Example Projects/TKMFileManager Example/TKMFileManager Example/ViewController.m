//
//  ViewController.m
//  TKMFileManager Example
//
//  Created by Tom Metzger on 8/10/16.
//  Copyright © 2016 Tom Metzger. All rights reserved.
//

#import "ViewController.h"
#import "TKMFileManager.h"





@interface ViewController ()

@end





@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	/*
	 * SECTION 1: The Basics
	 *    Note: The results will vary slightly based on if it is the initial intall/run of the app or not, as the file changes stay after the app finishes running 
	 *          (i.e. there will be no need to copy 'example2.txt' into the documents directory, as it is already there after the first run)
	 */
	//Creates a new TKMFileManager object.
	TKMFileManager *manager = [[TKMFileManager alloc] init];
	
	//Creates a new directory named 'SampleNewDirectory' in the Documents Directory. (If the directory doesn't exist)
	[manager createDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory"]];
	
	//Creates a new subdirecotry in the Documents Directory named 'SampleSubdirectory'. (If it doesn't already exist)
	[manager createSubdirectory:@"/SampleSubdriectory" inDirectory:manager.documentsDirectory];
	
	//Copies the file 'example.txt' to the previously created 'SampleNewDirectory'. (If 'SampleDirectory' didn't already exist, it would be created)
	[manager copyFile:[manager.mainBundleDirectory stringByAppendingPathComponent:@"example.txt"] toDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory"]];
	
	//Copies the contents of the previously created 'SampleNewDirectory' into a NEW directory named 'SampleDirectory2' in the Documents Directory.
	[manager copyDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory"] toDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory2"]];
	
	//Moves the contents of the newly created 'SampleDirectory2' into the previously created 'SampleSubdirectory'. 'SampleDirectory2' is deleted as a result of this operation.
	[manager moveDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory2"] toDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleSubdriectory"]];
	
	//Deletes the previously created 'SampleSubdirectory'.
	[manager deleteDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleSubdriectory"]];
	
	
	/*
	 * SECTION 2: The Not-So Basics
	 */
	//WOW! That was a lot of moving around of files. I wonder where our 'example.txt' file is. Luckily our TKMFileManager can find it for us!
	NSString *exampleFilePath = [manager findAndGetFile:@"example.txt"];
	
	//Now that we've found the example file, lets move it over to a new location. Since we're moving a file and not a directory, the directory its located in remains in tact. Note that we are also creating a new directory by doing this
	[manager moveFile:exampleFilePath toDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleTextFile"]];
	
	//Actually, I don't like the directory name 'ExampleTextFile'. Lets rename it to something fitting for all example files, like 'ExampleFiles'
	[manager renameDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleTextFile"] toName:@"ExampleFiles"];
	

	/*
	 * SECTION 3: The Adanced Stuff
	 */
	//But, what if I told you that we could have done the last section with just one line of code? Well, you can!
	[manager findAndMoveFile:@"example.txt" toDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleTextFile2"]];
	
	//We don't really need that file anymore, lets get rid of it.
	[manager findAndDeleteFile:@"example.txt"];
	
	//In fact, we don't need the any of the subdirectoryies in the Documents Directory
	[manager deleteDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"SampleNewDirectory"]];
	[manager deleteDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleTextFile2"]];
	[manager deleteDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"ExampleFiles"]];
	
	//Now that we've cleaned all that up, lets copy 'example2.txt'. Wait, where is it? Documents or Main Bundle? Luckily, we can find and copy in one step too!
	[manager findAndCopyFile:@"example2.txt" toDirectory:manager.documentsDirectory];
	
	
	/*
	 * SECTION 4: The Outroduction
	 */
	// That's All Folks! Now you're and expert with managing files with TKMFileManager.
	// Not all of the available methods were shown off here, but this should be enough for you to understand how this thing works.
	// More methods are being added, but for now, you should be able to perform any operation you may need with a combination of operations here
	//If you have an operation you'd like to be added, you can contact me on Twitter: @TheTomMetzger, or you can email me: tom@southernerd.us
	//Thanks for using TKMFileManager! Happy Managing!
}




- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
