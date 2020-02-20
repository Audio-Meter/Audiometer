//
//  ffmpeg.m
//  Audiometer
//
//  Created by Lewis Zhou on 11/26/19.
//  Copyright © 2019 Melmedtronics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mobileffmpeg/MobileFFmpeg.h>

NSString* execFFmpegCommand(NSString* command) {
    [MobileFFmpeg execute: command];
    int rc = [MobileFFmpeg getLastReturnCode];
    NSString *output = [MobileFFmpeg getLastCommandOutput];

    if (rc == RETURN_CODE_SUCCESS) {
        NSLog(@"Command execution completed successfully.\n");
        return output;
    } else if (rc == RETURN_CODE_CANCEL) {
        NSLog(@"Command execution cancelled by user.\n");
    } else {
        NSLog(@"Command execution failed with rc=%d and output=%@.\n", rc, output);
    }
    return NULL;
}
