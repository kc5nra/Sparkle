//
//  SUSporkelUnarchiver.m
//  Sparkle
//
//  Created by Ruwen Hahn on 18/05/2015.
//  Copyright (c) 2015 Sparkle Project. All rights reserved.
//

#import "SUSporkelUnarchiver.h"
#import "SUUnarchiver_Private.h"
#import "SUHost.h"
#import "NTSynchronousTask.h"

#include <sporkel.h>

@implementation SUSporkelUnarchiver

+ (BOOL)canUnarchivePath:(NSString *)path
{
    return [[path pathExtension] isEqualToString:@"sporkel_delta"];
}

- (void)applyBinaryDelta
{
    @autoreleasepool {
        NSString *sourcePath = self.updateHostBundlePath;
        NSString *targetPath = [[self.archivePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[sourcePath lastPathComponent]];
        
        if (sporkel_patch_apply(sourcePath.fileSystemRepresentation, self.archivePath.fileSystemRepresentation, targetPath.fileSystemRepresentation, true)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyDelegateOfSuccess];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self notifyDelegateOfFailure];
            });
        }
    }
}

- (void)start
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self applyBinaryDelta];
    });
}

+ (void)load
{
    [self registerImplementation:self];
}

@end
