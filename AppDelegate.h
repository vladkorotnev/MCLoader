//
//  AppDelegate.h
//  mcloader
//
//  Created by Vladislav Korotnev on 1/5/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASIHTTPRequest.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,ASIProgressDelegate>
@property (assign) IBOutlet NSTextField *name;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSPanel *processPanel;
@property (assign) IBOutlet NSProgressIndicator *processProgress;
- (IBAction)play:(id)sender;
@property (assign) IBOutlet NSButton *playBtn;
- (IBAction)download:(id)sender;
- (IBAction)optionsTxt:(id)sender;
- (IBAction)mcjar:(id)sender;
@property (assign) IBOutlet NSTextField *curVer;
@property (assign) IBOutlet NSTextField *youVer;

@end
