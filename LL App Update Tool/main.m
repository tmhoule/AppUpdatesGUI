//
//  main.m
//  LL App Update Tool
//
//  Created by Houle, Todd - 1170 - MITLL on 11/6/15.
//  Copyright © 2015 MIT Lincoln Labs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, const char * argv[]) {
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    return NSApplicationMain(argc, argv);
}
