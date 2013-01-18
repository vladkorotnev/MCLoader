//
//  AppDelegate.h
//  mcloader
//
//  Created by Vladislav Korotnev on 1/5/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASIHTTPRequest.h"
@interface AppDelegate : NSObject <NSApplicationDelegate,ASIProgressDelegate,NSTableViewDataSource,NSTableViewDelegate> {
    NSPanel *modPanel;
    NSScrollView *modList;
    NSProgressIndicator *spinMods;
    NSTableView *modTable;
    NSButton *installModBtn;
    NSArray * modsAvail;
    
    NSButton *closeModsBtn;
    NSButton *modPanelBtn;
    NSPanel *dlPanel;
    NSPanel *newVerPanel;
    NSTextField *modDescrippy;
}
- (IBAction)getUpd:(id)sender;
- (IBAction)willDo:(id)sender;
@property (assign) IBOutlet NSPanel *nwVerPanel;
- (IBAction)openMods:(id)sender;
@property (assign) IBOutlet NSTextField *modDescrippy;

@property (assign) IBOutlet NSTextField *name;
@property (assign) NSArray *modsAvail;
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
@property (assign) IBOutlet NSPanel *modPanel;
@property (assign) IBOutlet NSScrollView *modList;
- (IBAction)refrMods:(id)sender;
@property (assign) IBOutlet NSProgressIndicator *spinMods;
@property (assign) IBOutlet NSTableView *modTable;
- (IBAction)splashes:(id)sender;
@property (assign) IBOutlet NSButton *installModBtn;
- (IBAction)installMod:(id)sender;
- (IBAction)closeMods:(id)sender;
@property (assign) IBOutlet NSButton *closeModsBtn;
@property (assign) IBOutlet NSButton *modPanelBtn;
- (IBAction)openModPanel:(id)sender;
@property (assign) IBOutlet NSPanel *dlPanel;
- (IBAction)clsMeta:(id)sender;

@end
