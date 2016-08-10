# TKMFileManager
TKMFileManager is a simple tool to manage your iOS App's files, written in Objective-C (Swift coming soon). Instead of using NSFileManager and the lengthy amount of code needed for a simple operation, you can write it in just one line with TKMFileManager!
<br>To be perfectly honest, there's not much that is super special about it - except instead of writing this:

```Objective-C
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths objectAtIndex:0]; 
NSString *newDirectory = [documentsDirectory stringByAppendingPathComponent:@"/newDirectory"];

if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectory])
{
	[[NSFileManager defaultManager] createDirectoryAtPath:newDirectory withIntermediateDirectories:NO attributes:nil error:nil];
}
```

You can simply write this:
```Objective-C
TKMFileManager *manager = [[TKMFileManager alloc] init];
[manager createSubdirectory:@"/NewDirectory" inDirectory:manager.documentsDirectory];
```

Sure, almost anyone could write something like this, but why bother when its already written for you - for free!

Still not convinced that you should use this over others? Besides the fact that this is one of the few that's still being updated, check out these awesome features:



## Features
* Built with NSFileManager, using all the methods you'd probably be using already <br>
* Smart file & directory searching - Don't know the exact path of a file or directory? Let TKMFileManager find it for you! (***Exclusive!***)<br>
* Copy file / directory to directory <br>
   * + Find & Copy (***Exclusive!***)
* Move file / directory to directory <br>
   * + Find & Move (***Exclusive!***)
* Delete file / directory <br>
   * + Find & Delete (***Exclusive!***)
* Retrieve NSData from file (***Coming Soon!***) <br>
* Install via CocoaPods (***Coming Soon!***) <br>



## Requirements
* ARC enabled
* iOS 5.0 or higher



## Installation
### Without CocoaPods
1) Simply copy `TKMFileManager.h` and `TKMFileManager.m` into your project's files. <br>

2) In the file in which you'd like to use TKMFileManager, add the following line to your import statements:
```Objective-C
#import "TKMFileManager.h"
```


### With CocoaPods
***Coming Soon***



## Usage
To create a new TKMFileManager object (named manager in this example), simply write:
```Objective-C
TKMFileManager *manager = [[TKMFileManager alloc] init];
```
<br>
If, for some reason, you don't want to initialize it right away, you can simply write:
```Objective-C
TKMFileManager *manager = [TKMFileManager alloc];
```
However, before you can use it, you ***MUST*** initialize the TKMFileManager object:
```Objective-C
[manager init];
```

<br>
Now that you've created your TKMFileManager object, you're reading to begin managing your files:


### Creating A New Directory
TKMFileManager does ***NOT*** default to any specific directory, so when making a new directory you will need to specify the ***FULL*** path of your new directory. Luckily, this is easy as TKFileManager does provide easy access to the directories you're likely to use:
```Objective-C
manager.documentsDirectory //Path for the Documents Directory
manager.mainBundleDirectory //Path for the Main Bundle's directory
```
So, to create a new directory in your app's Documents Directory, you simply need to say:
```Objective-C
[manager createDirectory:[manager.documentsDirectory stringByAppendingPathComponent:@"NewDirectory"]];
```
Alternatively, you can accomplish this by using the `createSubdirectory` method:
```Objective-C
[manager createSubdirectory:@"NewDirectory" inDirectory:manager.documentsDirectory];
```

To make things easier for you, `createSubdirectory` is smart enough to add "/" in front of your subdirectory's name, should you forget to. <br>
When using `createDirectory` you will either need to have the "/" already included in your path's string, or you'll need to use `stringByAppendingPathComponent`.


### Copying A Directory
Copying a directory makes a copy of the directory's files in a new location, while leaving the files in the original directory intact. <br>
To copy a directory, you need to have the full path to the directory you wish to copy and the full path of the directory to wish you would like to copy it. If the destination directory does not exist, it will be created. For this example, we will copy the contents of the `mainBundleDirectory` to the `documentsDirectory`:
```Objective-C
[manager copyDirectory:manager.mainBundleDirectory toDirectory:manager.documentsDirectory];
```
***Note:*** that this does not create a "mainBundle" subdirectory in the Documents Directory, but rather it copies the contents of `mainBundleDirectory` directly to `documentsDirectory`. <br>
If you wish for the contents to be copied to a subdirectory of the Documents Directory, you will first need to create it and then copy into it:
```Objective-C
NSString *mainBundleInDocuments = [manager.documentsDirectory stringByAppendingPathComponent:@"MainBundleFiles"];
[manager copyDirectory:manager.mainBundleDirectory toDirectory:mainBundleInDocuments];
```


### Moving A Directory
Moving a directory moves the a directory's files to a new location. The files are will no longer be able to be found the original directory, as they no longer exist there.  If the destination directory does not exist, it will be created. <br>
Like copying a directory, when moving a directory you must have the full path of the source directory and the destination directory:
```Objective-C
NSString *mainBundleInDocuments = [manager.documentsDirectory stringByAppendingPathComponent:@"MainBundleFiles"];
[manager moveDirectory:manager.mainBundleDirectory toDirectory:mainBundleInDocuments];
```
***NOTE:*** It is NOT recommended that you move the contents of `mainBundleDirectory` to any other directory.


### Deleting A Directory
Deleting a directory will delete it's contents and the directory itself from the parent directory. <br>
To delete a directory, you simple need to use the `deleteDirectory` method:
```Objective-C
//(this example assumes "mainBundleInDocuments" is a valid variable)
[manager deleteDirectory:mainBundleInDocuments];
```
If the directory you are attempting to delete does not exist, nothing will happen.


### Copying A File
If you know a file's full path, you can copy it to a directory (if the destination directory doesn't exist, it will be created):
```Objective-C
[manager copyFile:[manager.mainBundleDirectory stringByAppendingPathComponent:@"default.n64skin"] toDirectory:manager.documentsDirectory];
```


### Moving A File
If you know a file's full path, you can move it to a directory (if the destination directory doesn't exist, it will be created):
```Objective-C
[manager moveFile:[manager.mainBundleDirectory stringByAppendingPathComponent:@"default.2600skin"]  toDirectory:manager.documentsDirectory];
```
***Remember***: If you move a file, it will no longer be in the original directory


### Deleting A File
If you know a file's full path, you can delete it with the `deleteFile` method:
```Objective-C
[manager deleteFile:[manager.documentsDirectory stringByAppendingPathComponent:@"testROM.z64"]];
```



### Getting A File's Path
If you know what directory a file is in, you can get it's full path be using the `getFile` method:
```Objective-C
NSString *dogeMemePath = [manager getFile:@"doge.png" inDirectory:manager.documentsDirectory];
```
This will search through the directory & its subdirectories, and will return the full path for your file (handy if you don't know if its in a subdirectory or not). <br>

But, what if you don't know quite where a file's stored? Well, with TKMFileManager's exclusive `findAndGetFile` method, it will search all available directories (currently only Main Bundle & Documents) and all their subdirectories until it finds your file:
```Objective-C
NSString *triggeredMemePath = [manager findAndGetFile:@"triggered.png"];
```
This feature also extends to moving, copying, and deleting a file, like so:
```Objective-C
[manager findAndCopyFile:@"repost.png" toDirectory:manager.documentsDirectory];
[manager findAndMoveFile:@"moveItSomewhereElsePatrick.png" toDirectory:manager.documentsDirectory];
[manager findAndDeleteFile:@"harambe.png"];
```



## License
TKMFileManager is licensed under the MIT License, which is reproduced in full in the [License](LICENSE) file. <br>
Attribution is technically required by the MIT License - plus, I enjoy being able to see how code I wrote has helped / benefited other developers and their users!



## Cool Projects That Use TKMFileManager
* Revera - A Nintendo 64 emulator for iOS devices



## Does Your Project US TKMFileManager? 
If you've got an awesome project that uses TKMFileManager, contact me (info below) and I'll be sure to add your project to the list!



##Contact 
Please report all bugs to the "Issues" page here on GitHub. 
If you've got a cool project that uses TKMFileManager, need help figuring out how to use it (beyond what's provided in this guide), or you just want to say hi, you can contact me here: <br>

Twitter: <br>
[@TheTomMetzger](https://www.twitter.com/thetommetzger "Tom's Twitter") <br>

Email: <br>
[tom@southernderd.us](tom@southernderd.us "Tom's Email") <br>
