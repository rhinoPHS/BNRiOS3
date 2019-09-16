//
//  BNRImageStore.m
//  Homepwner
//
//  Created by rhino Q on 04/09/2019.
//  Copyright © 2019 rhino Q. All rights reserved.
//

#import "BNRImageStore.h"

@implementation BNRImageStore

+(instancetype)sharedStore {
    static BNRImageStore *defaultImageStore = nil;
    if(!defaultImageStore)
        defaultImageStore = [[BNRImageStore alloc] init];
    return defaultImageStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(clearCache:)
                   name:UIApplicationDidReceiveMemoryWarningNotification
                 object:nil];
    }
    return self;
}

-(void)clearCache:(NSNotification *)noti {
    NSLog(@"flushing %lu images out of the cache", (unsigned long)[dictionary count]);
    [dictionary removeAllObjects];
}

- (void)setImage:(UIImage *)i forkey:(NSString *)s {
    [dictionary setObject:i forKey:s];
    // Create full path for image
    NSString *imagePath = [self imagePathForKey:s];
    
    // Trun image into JPEG data
    NSData *d = UIImagePNGRepresentation(i);
//    NSData *d = UIImageJPEGRepresentation(i, 0.5);
    
    // Write it to full path
    [d writeToFile:imagePath atomically:YES];
}

- (UIImage *)imageForKey:(NSString *)s {
    
    //    return [dictionary objectForKey:s];
    // If possible, get it from the dictionary
    UIImage *result = [dictionary objectForKey:s];
    
    if(!result) {
        //Create UIImage object from file
        result = [UIImage imageWithContentsOfFile:[self imagePathForKey:s]];
        
        // If we found an image on the file system, place it into the cache
        if(result) {
            [dictionary setObject:result forKey:s];
        } else {
            NSLog(@"Error : unalbe to find %@", [self imagePathForKey:s]);
        }
    }
    return result;
}

- (void)deleteImageForKey:(NSString *)s {
    if(!s)
        return;
    [dictionary removeObjectForKey:s];
    NSString *path = [self imagePathForKey:s];
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

- (NSString *)imagePathForKey:(NSString *)key {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory
                                                                       , NSUserDomainMask
                                                                       , YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:key];
}


@end
