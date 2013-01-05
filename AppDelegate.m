//
//  AppDelegate.m
//  mcloader
//
//  Created by Vladislav Korotnev on 1/5/13.
//  Copyright (c) 2013 Vladislav Korotnev. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.curVer.stringValue = [NSString stringWithFormat:@"Current version: %@",[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/curver"] encoding:NSUTF8StringEncoding error:nil]];
    self.youVer.stringValue = [NSString stringWithFormat:@"You have %@",[NSString stringWithContentsOfFile:[@"~/.minecraft/thisver" stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil]];
    self.name.stringValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"nick"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:[@"~/.minecraft/thisver" stringByExpandingTildeInPath]]) {
        [self.playBtn setEnabled:false];
    }
}

- (IBAction)play:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:self.name.stringValue forKey:@"nick"];
    if ([self.name.stringValue isEqualToString:@""]){ self.name.stringValue = @"Anonymous with vladkorotnev's MCLoadeR"; }
    NSString *lc = [NSString stringWithFormat:@"cd \"$( dirname \"$0\" )/bin\"\njava -Xms100M -Xmx500M -classpath jinput.jar:lwjgl.jar:lwjgl_util.jar:minecraft.jar -Djava.library.path=natives  net.minecraft.client.Minecraft \"%@\"",self.name.stringValue];
    [[NSFileManager defaultManager]removeItemAtPath:[@"~/.minecraft/Minecraft.sh" stringByExpandingTildeInPath] error:nil];
    [lc writeToFile:[@"~/.minecraft/Minecraft.sh" stringByExpandingTildeInPath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    system([[@"chmod +x ~/.minecraft/Minecraft.sh" stringByExpandingTildeInPath]UTF8String]);
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
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/cli.zip"]];
    [request setDownloadDestinationPath:[@"~/.mcdist.zip" stringByExpandingTildeInPath]];
    [request setDelegate:self];
    [self.processProgress setIndeterminate:false];
    [request setDownloadProgressDelegate:self.processProgress];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    system([[@"mv ~/.minecraft/options.txt ~/.mcopt" stringByExpandingTildeInPath]UTF8String]);
      system([[@"mkdir ~/.minecraft" stringByExpandingTildeInPath]UTF8String]);
    system([[@"unzip -o ~/.mcdist.zip -d ~/.minecraft" stringByExpandingTildeInPath]UTF8String]);
    system([[@"mv ~/.mcopt ~/.minecraft/options.txt" stringByExpandingTildeInPath]UTF8String]);
    self.curVer.stringValue = [NSString stringWithFormat:@"Current version: %@",[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.vladkorotnev.me/mcft/curver"] encoding:NSUTF8StringEncoding error:nil]];
    self.youVer.stringValue = [NSString stringWithFormat:@"You have %@",[NSString stringWithContentsOfFile:[@"~/.minecraft/thisver" stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil]];
[self.processProgress setHidden:true];
    [self.playBtn setEnabled:true];
}

- (IBAction)optionsTxt:(id)sender {
    system([[@"open ~/.minecraft/options.txt" stringByExpandingTildeInPath]UTF8String]);
}

- (IBAction)mcjar:(id)sender {
    system([[@"open ~/.minecraft/bin/minecraft.jar" stringByExpandingTildeInPath]UTF8String]);
}
@end
