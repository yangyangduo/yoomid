//
//  DiskCache.m
//  private_share
//
//  Created by Zhao yang on 6/19/14.
//  Copyright (c) 2014 hentre. All rights reserved.
//

#import "DiskCache.h"
#import "GlobalConfig.h"

#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Yoomid-User-Data"]

@implementation DiskCache

- (void)f {
    NSString *userDirectory = [DIRECTORY stringByAppendingPathComponent:[GlobalConfig defaultConfig].userName];
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:userDirectory];
    
    if(!directoryExists) {
        NSError *error;
        BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:userDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if(!createDirSuccess) {
#ifdef DEBUG
            NSLog(@"[Disk Cache] Create directory for disk cache failed, error >>> %@", error.description);
#endif
            return;
        }
    }
    
    //NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", @""]];
    
    
    
    


}

@end
