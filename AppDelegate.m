//
//  AppDelegate.m
//  mcloader
//
//  Created by Vladislav Korotnev on 1/5/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize nwVerPanel;
@synthesize dlPanel;
@synthesize closeModsBtn;
@synthesize modPanelBtn;
@synthesize spinMods;
@synthesize modTable;
@synthesize installModBtn;
@synthesize modPanel;
@synthesize modList, modsAvail;

- (void)dealloc
{
    [super dealloc];
}
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return  false;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.curVer.stringValue = [NSString stringWithFormat:@"Current version on server: %@",[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/curver"] encoding:NSUTF8StringEncoding error:nil]];
    self.youVer.stringValue = [NSString stringWithFormat:@"You have %@",[NSString stringWithContentsOfFile:[@"~/.minecraft/thisver" stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil]];
    self.name.stringValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"nick"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:[@"~/.minecraft/thisver" stringByExpandingTildeInPath]]) {
        [self.playBtn setEnabled:false];
    }
    
    [self refrMods:self];
    [modTable setDataSource:self];
    [modTable setAllowsTypeSelect:NO];
    [modTable setAllowsMultipleSelection:NO];
    [modTable setAllowsEmptySelection:NO];
    [modTable setAllowsColumnSelection:NO];
    [modTable setAllowsColumnResizing:NO];
    [modTable setAllowsColumnReordering:NO];
    [modTable setDelegate:self];
    [self performSelector:@selector(checkUpd) withObject:nil afterDelay:1];
}

- (IBAction)play:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:self.name.stringValue forKey:@"nick"];
    if ([self.name.stringValue isEqualToString:@""]){ self.name.stringValue = @"Anonymous with vladkorotnev's MCLoadeR"; }
    NSString *lc = [NSString stringWithFormat:@"cd \"$( dirname \"$0\" )/bin\"\njava -Xms100M -Xmx500M -classpath jinput.jar:lwjgl.jar:lwjgl_util.jar:minecraft.jar -Djava.library.path=natives  net.minecraft.client.Minecraft \"%@\"",self.name.stringValue];
    [[NSFileManager defaultManager]removeItemAtPath:[@"~/.minecraft/Minecraft.sh" stringByExpandingTildeInPath] error:nil];
    [lc writeToFile:[@"~/.minecraft/Minecraft.sh" stringByExpandingTildeInPath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    system([[@"chmod +x ~/.minecraft/Minecraft.sh" stringByExpandingTildeInPath]UTF8String]);
    system([[@"rm -r ~/.minecraft/bin/minecraft.jar/__MACOSX" stringByExpandingTildeInPath]UTF8String]);
    NSTask * task = [[NSTask alloc]init];
    [task setLaunchPath:@"/bin/bash"];
    
    [task setArguments:[NSArray arrayWithObjects:[@"~/.minecraft/Minecraft.sh" stringByExpandingTildeInPath], nil]];
    [task launch];
    [[NSApplication sharedApplication]terminate:0];
    
}
- (IBAction)download:(id)sender {
    [self.processProgress setHidden:false];
    [self.playBtn setEnabled:false];
    [self.processProgress startAnimation:nil];
    [[NSApplication sharedApplication] beginSheet:dlPanel
                                   modalForWindow:self.window
                                    modalDelegate:self
                                   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
                                      contextInfo:nil];
    
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/cli.zip"]];
    [request setDownloadDestinationPath:[@"~/.mcdist.zip" stringByExpandingTildeInPath]];
    [request setDelegate:self];
    [self.processProgress setIndeterminate:false];
    [request setDownloadProgressDelegate:self.processProgress];
    [request startAsynchronous];
}
-(void) checkUpd {
    if ([[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/ldrver"] encoding:NSUTF8StringEncoding error:nil]floatValue ] > [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]floatValue]) {
        [[NSApplication sharedApplication] beginSheet:nwVerPanel
                                       modalForWindow:self.window
                                        modalDelegate:self
                                       didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
                                          contextInfo:nil];
    }
    if ([[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/ldrver"] encoding:NSUTF8StringEncoding error:nil]floatValue ] < [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]floatValue]) {
        NSLog(@"DeveloperS?");
    }
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    [self.installModBtn setEnabled:true];
    return  true;
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    if([request.downloadDestinationPath isEqualToString:[@"~/.mcdist.zip" stringByExpandingTildeInPath]]) {
    system([[@"mv ~/.minecraft/options.txt ~/.mcopt" stringByExpandingTildeInPath]UTF8String]);
      system([[@"mkdir ~/.minecraft" stringByExpandingTildeInPath]UTF8String]);
    system([[@"unzip -o ~/.mcdist.zip -d ~/.minecraft" stringByExpandingTildeInPath]UTF8String]);
    system([[@"mv ~/.mcopt ~/.minecraft/options.txt" stringByExpandingTildeInPath]UTF8String]);
    self.curVer.stringValue = [NSString stringWithFormat:@"Current version: %@",[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/curver"] encoding:NSUTF8StringEncoding error:nil]];
    self.youVer.stringValue = [NSString stringWithFormat:@"You have %@",[NSString stringWithContentsOfFile:[@"~/.minecraft/thisver" stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil]];
[self.processProgress setHidden:true];
    [self.playBtn setEnabled:true];
        [[NSApplication sharedApplication] stopModal];
        [dlPanel orderOut:self];
        [ NSApp endSheet:dlPanel returnCode:0 ] ;
        system([[@"rm ~/.mcdist.zip" stringByExpandingTildeInPath]UTF8String]);
    }
    if([request.downloadDestinationPath isEqualToString:[@"~/.mcmod.zip" stringByExpandingTildeInPath]]) {
        if ([[[modsAvail objectAtIndex:request.tag]objectForKey:@"Target"]isEqualToString:@"jar"]) {
            system([[@"unzip -o ~/.mcmod.zip -d ~/.minecraft/bin/minecraft.jar" stringByExpandingTildeInPath]UTF8String]);
            system([[@"rm -rf ~/.minecraft/bin/minecraft.jar/META-INF/*MOJANG*" stringByExpandingTildeInPath]UTF8String]);
        }
        if ([[[modsAvail objectAtIndex:request.tag]objectForKey:@"Target"]isEqualToString:@"rsrc"]) {
            system([[@"unzip -o ~/.mcmod.zip -d ~/Library/Application\\ Support/minecraft/resources/" stringByExpandingTildeInPath]UTF8String]);
        }
        if ([[[modsAvail objectAtIndex:request.tag]objectForKey:@"Target"]isEqualToString:@"coremods"]) {
            system([[@"mkdir -p ~/Library/Application\\ Support/minecraft/coremods/" stringByExpandingTildeInPath]UTF8String]);
            system([[@"unzip -o ~/.mcmod.zip -d ~/Library/Application\\ Support/minecraft/coremods/" stringByExpandingTildeInPath]UTF8String]);
            system([[@"rm -rf ~/Library/Application\\ Support/minecraft/coremods/__MACOSX" stringByExpandingTildeInPath]UTF8String]);
        }
        if ([[[modsAvail objectAtIndex:request.tag]objectForKey:@"Target"]isEqualToString:@"text"]) {
            system([[@"unzip -o ~/.mcmod.zip -d ~/Library/Application\\ Support/minecraft/texturepacks/" stringByExpandingTildeInPath]UTF8String]);
            system([[@"rm -rf ~/Library/Application\\ Support/minecraft/texturepacks/__MACOSX" stringByExpandingTildeInPath]UTF8String]);
        }
        if ([[[modsAvail objectAtIndex:request.tag]objectForKey:@"Target"]isEqualToString:@"mods"]) {
            system([[@"mkdir -p ~/Library/Application\\ Support/minecraft/mods" stringByExpandingTildeInPath]UTF8String]);
            [[NSFileManager defaultManager]moveItemAtPath:[@"~/.mcmod.zip" stringByExpandingTildeInPath] toPath:[[NSString stringWithFormat:@"~/Library/Application Support/minecraft/mods/%@.zip",[[modsAvail objectAtIndex:request.tag]objectForKey:@"Name"]]stringByExpandingTildeInPath] error:nil];
            
        }
        
        self.curVer.stringValue = [NSString stringWithFormat:@"Current version on server: %@",[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/curver"] encoding:NSUTF8StringEncoding error:nil]];
        self.youVer.stringValue = [NSString stringWithFormat:@"You have %@",[NSString stringWithContentsOfFile:[@"~/.minecraft/thisver" stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil]];
        [self.spinMods setIndeterminate:true];
        [spinMods stopAnimation:nil];
        [installModBtn setEnabled:true];
        [closeModsBtn setEnabled:true];
        [modTable setEnabled:true];
        NSAlert* msgBox = [[[NSAlert alloc] init] autorelease];
        [msgBox setMessageText: [NSString stringWithFormat:@"Mod \"%@\" was installed.",[[modsAvail objectAtIndex:request.tag]objectForKey:@"Name"]]];
        [msgBox addButtonWithTitle: @"OK"];
        [msgBox runModal];
        system([[@"rm ~/.mcmod.zip" stringByExpandingTildeInPath]UTF8String]);
    }
}

- (IBAction)optionsTxt:(id)sender {
    system([[@"open ~/.minecraft/options.txt" stringByExpandingTildeInPath]UTF8String]);
}

- (IBAction)mcjar:(id)sender {
    system([[@"open ~/.minecraft/bin/minecraft.jar" stringByExpandingTildeInPath]UTF8String]);
}
- (IBAction)refrMods:(id)sender {
    [spinMods startAnimation:nil];
    modsAvail = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/mods.plist"]];
    [modsAvail retain];
    NSLog(@"%@",modsAvail);
    [modTable reloadData];
    [spinMods stopAnimation:nil];
}
- (IBAction)installMod:(id)sender {
    [spinMods startAnimation:nil];
    [spinMods setIndeterminate:false];
    [installModBtn setEnabled:false];
    [modTable setEnabled:false];
    [closeModsBtn setEnabled:false];
    NSString * modUrl = [[modsAvail objectAtIndex:modTable.selectedRow]objectForKey:@"URL"];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:modUrl]];
    [request setDownloadDestinationPath:[@"~/.mcmod.zip" stringByExpandingTildeInPath]];
    [request setDelegate:self];
    [request setTag:modTable.selectedRow];
    [self.spinMods setIndeterminate:false];
    [request setDownloadProgressDelegate:self.spinMods];
    [request startAsynchronous];
}

- (IBAction)closeMods:(id)sender {
    [[NSApplication sharedApplication] stopModal];
    [modPanel orderOut:self];
   [ NSApp endSheet:modPanel returnCode:0 ] ;
    
}
- (IBAction)openModPanel:(id)sender {
    [[NSApplication sharedApplication] beginSheet:modPanel
                                   modalForWindow:self.window
                                    modalDelegate:self
                                   didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
                                      contextInfo:nil];
   // [[NSApplication sharedApplication] runModalForWindow: modPanel];
}
// just returns the item for the right row
- (id)     tableView:(NSTableView *) aTableView
objectValueForTableColumn:(NSTableColumn *) aTableColumn
                 row:(NSInteger ) rowIndex
{
    if ([[[modsAvail objectAtIndex:rowIndex]objectForKey:@"Compat"]floatValue] != [[NSString stringWithContentsOfFile:[@"~/.minecraft/thisver" stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil]floatValue]) {

        NSString * theHTML = [NSString stringWithFormat:@"<font face='Monaco' color=#EE0000>%@ <font size=2>[Needs %@, you have %@]</font></font>",[[modsAvail objectAtIndex:rowIndex]objectForKey:@"Name"],[[modsAvail objectAtIndex:rowIndex]objectForKey:@"Compat"] , [NSString stringWithContentsOfFile:[@"~/.minecraft/thisver" stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil]];
        // fill the NSData buffer with the contents of the NSString
        NSData * htmlData = [theHTML dataUsingEncoding: NSUTF8StringEncoding];
        NSAttributedString * styledText = [[NSAttributedString alloc]
                                           initWithHTML: htmlData  documentAttributes: nil];
        return [styledText autorelease];
    }
   
    
    return [[modsAvail objectAtIndex:rowIndex]objectForKey:@"Name"];
}

// just returns the number of items we have.
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSLog(@"count");
    return [modsAvail count];
}
- (void) sheetDidEnd:(NSWindow *) sheet returnCode:(int)returnCode contextInfo:(void *) contextInfo {

}
- (IBAction)clsMeta:(id)sender {
        system([[@"rm -rf ~/.minecraft/bin/minecraft.jar/META-INF/*MOJANG*" stringByExpandingTildeInPath]UTF8String]);
}
- (IBAction)splashes:(id)sender {
     system([[@"open ~/.minecraft/bin/minecraft.jar/title/splashes.txt" stringByExpandingTildeInPath]UTF8String]);
}
- (IBAction)getUpd:(id)sender {
    system([[@"open http://vladkorotnev.me/mcft/mcloader.app.zip" stringByExpandingTildeInPath]UTF8String]);
}

- (IBAction)willDo:(id)sender {
    [[NSApplication sharedApplication] stopModal];
    [nwVerPanel orderOut:self];
    [ NSApp endSheet:nwVerPanel returnCode:0 ] ;
}
- (IBAction)openMods:(id)sender {
     system([[@"open ~/Library/Application\\ Support/minecraft/mods" stringByExpandingTildeInPath]UTF8String]);
}
@end
