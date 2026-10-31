#import <ScreenSaver/ScreenSaver.h>
#import <AppKit/AppKit.h>
#import <ColorSync/ColorSync.h>
#import <CommonCrypto/CommonDigest.h>
#import <math.h>
#import <dispatch/dispatch.h>
#import "SaverDataPath.h"

static NSDictionary *ReadJSON(NSURL *url) {
    NSNumber *size=nil;[url getResourceValue:&size forKey:NSURLFileSizeKey error:nil];
    if(!size||size.unsignedLongLongValue>8*1024*1024)return nil;
    NSData *bytes=[NSData dataWithContentsOfURL:url options:0 error:nil];
    id value=bytes?[NSJSONSerialization JSONObjectWithData:bytes options:0 error:nil]:nil;
    return [value isKindOfClass:NSDictionary.class]?value:nil;
}
static NSDate *DateValue(id text) {
    if(![text isKindOfClass:NSString.class])return nil;
    static NSISO8601DateFormatter *plain,*fraction;static dispatch_once_t once;
    dispatch_once(&once,^{plain=[NSISO8601DateFormatter new];fraction=[NSISO8601DateFormatter new];fraction.formatOptions=NSISO8601DateFormatWithInternetDateTime|NSISO8601DateFormatWithFractionalSeconds;});
    return [fraction dateFromString:text]?:[plain dateFromString:text];
}
static BOOL HashOK(id value) {
    if(![value isKindOfClass:NSString.class]||[value length]!=64)return NO;
    return [value rangeOfCharacterFromSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"] invertedSet]].location==NSNotFound;
}
@interface ImperialSchoolSaverView : ScreenSaverView
@property(nonatomic,strong) NSURL *root;
@property(nonatomic,strong) NSImage *image;
@property(nonatomic,strong) NSImage *previous;
@property(nonatomic,strong) NSImage *fallback;
@property(nonatomic,copy) NSString *imageKey;
@property(nonatomic,copy) NSString *contextKey;
@property(nonatomic,copy) NSString *placement;
@property(nonatomic,copy) NSString *previousPlacement;
@property(nonatomic) NSTimeInterval nextRead;
@property(nonatomic) NSTimeInterval fadeStarted;
@property(nonatomic,strong) NSWindow *settingsSheet;
@property(nonatomic,strong) NSTextField *dataStatus;
@property(nonatomic,strong) NSDictionary *cachedFeed;
@property(nonatomic,strong) NSDate *feedStamp;
@property(nonatomic,strong) NSNumber *feedLength;
@end

@implementation ImperialSchoolSaverView
- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)preview {
    if((self=[super initWithFrame:frame isPreview:preview])) {
        self.animationTimeInterval=1.0/30.0;self.placement=@"fit";
        self.fallback=[[NSImage alloc] initWithContentsOfURL:[[NSBundle bundleForClass:self.class] URLForResource:@"no-data" withExtension:@"png"]];
        [self resolveRoot];
    }return self;
}
- (void)resolveRoot {
    if(self.root)return;
    char *path=ISVCopySaverDataPath();if(!path)return;
    NSString *name=[[NSFileManager defaultManager] stringWithFileSystemRepresentation:path length:strlen(path)];free(path);
    if(name.length)self.root=[NSURL fileURLWithPath:name isDirectory:YES];
    self.cachedFeed=nil;self.feedStamp=nil;self.feedLength=nil;
}
- (void)startAnimation {[super startAnimation];self.nextRead=0;[self refreshFrame];self.needsDisplay=YES;}
- (void)stopAnimation {[super stopAnimation];self.previous=nil;}
- (NSString *)displayID {
    NSScreen *screen=self.window.screen;if(!screen)return nil;
    CGDirectDisplayID number=[screen.deviceDescription[@"NSScreenNumber"] unsignedIntValue];
    CFUUIDRef uuid=CGDisplayCreateUUIDFromDisplayID(number);if(!uuid)return [NSString stringWithFormat:@"display-%u",number];
    NSString *value=CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault,uuid));CFRelease(uuid);return value;
}
- (NSImage *)verifiedImage:(NSDictionary *)frame {
    if(![frame isKindOfClass:NSDictionary.class]||!HashOK(frame[@"sha256"]))return nil;
    if(![frame[@"bytes"] isKindOfClass:NSNumber.class]||![frame[@"width"] isKindOfClass:NSNumber.class]||![frame[@"height"] isKindOfClass:NSNumber.class])return nil;
    NSUInteger expected=[frame[@"bytes"] unsignedIntegerValue];if(!expected||expected>100000000)return nil;
    NSURL *folder=[[self.root URLByAppendingPathComponent:@"weather-images" isDirectory:YES] URLByResolvingSymlinksInPath];
    NSURL *url=[[folder URLByAppendingPathComponent:[frame[@"sha256"] stringByAppendingString:@".jpg"]] URLByResolvingSymlinksInPath];
    if(![[url URLByDeletingLastPathComponent].path isEqual:folder.path])return nil;
    NSNumber *size=nil;[url getResourceValue:&size forKey:NSURLFileSizeKey error:nil];if(size.unsignedIntegerValue!=expected)return nil;
    NSData *data=[NSData dataWithContentsOfURL:url options:0 error:nil];if(data.length!=expected)return nil;
    unsigned char hash[CC_SHA256_DIGEST_LENGTH];CC_SHA256(data.bytes,(CC_LONG)data.length,hash);NSMutableString *hex=[NSMutableString stringWithCapacity:64];
    for(NSUInteger i=0;i<CC_SHA256_DIGEST_LENGTH;i++)[hex appendFormat:@"%02x",hash[i]];
    if(![hex isEqual:frame[@"sha256"]])return nil;
    NSBitmapImageRep *rep=[[NSBitmapImageRep alloc] initWithData:data];
    if(!rep||rep.pixelsWide!=[frame[@"width"] integerValue]||rep.pixelsHigh!=[frame[@"height"] integerValue])return nil;
    NSImage *image=[[NSImage alloc] initWithSize:NSMakeSize(rep.pixelsWide,rep.pixelsHigh)];[image addRepresentation:rep];return image;
}
- (void)clearImage {
    if(self.image||self.previous){self.image=nil;self.previous=nil;self.imageKey=nil;self.contextKey=nil;self.needsDisplay=YES;}
}
- (void)refreshFrame {
    [self resolveRoot];if(!self.root){[self clearImage];return;}
    NSURL *feedURL=[self.root URLByAppendingPathComponent:@"saver-state.json"];NSDate *stamp=nil;NSNumber *length=nil;
    [feedURL getResourceValue:&stamp forKey:NSURLContentModificationDateKey error:nil];[feedURL getResourceValue:&length forKey:NSURLFileSizeKey error:nil];
    if(!self.cachedFeed||![stamp isEqual:self.feedStamp]||![length isEqual:self.feedLength]){self.cachedFeed=ReadJSON(feedURL);self.feedStamp=stamp;self.feedLength=length;}
    NSDictionary *settings=ReadJSON([self.root URLByAppendingPathComponent:@"settings.json"]),*feed=self.cachedFeed;
    if(![settings[@"saver"] isKindOfClass:NSDictionary.class]||![settings[@"saver"][@"enabled"] boolValue]||[feed[@"schema"] integerValue]!=1||![feed[@"configuration_revision"] isEqual:settings[@"configuration_revision"]]){[self clearImage];return;}
    NSDictionary *targets=feed[@"targets"];if(![targets isKindOfClass:NSDictionary.class]){[self clearImage];return;}
    NSString *display=[self displayID];NSDictionary *target=display?targets[display]:nil;
    if(!target&&self.isPreview)target=targets[[targets.allKeys sortedArrayUsingSelector:@selector(compare:)].firstObject?:@""];
    if(![target isKindOfClass:NSDictionary.class]){[self clearImage];return;}
    NSString *context=[NSString stringWithFormat:@"%@/%@/%@/%@",target[@"profile"],target[@"revision"],target[@"world_id"],target[@"location_revision"]];
    if(![context isEqual:self.contextKey]){[self clearImage];self.contextKey=context;}
    NSArray *frames=target[@"frames"];if(![frames isKindOfClass:NSArray.class]||frames.count>8000)return;
    NSTimeInterval now=NSDate.date.timeIntervalSince1970;NSDictionary *selected=nil;
    if([target[@"mode"] isEqual:@"slideshow"]&&frames.count){NSTimeInterval anchor=DateValue(target[@"anchor"]).timeIntervalSince1970,interval=fmax(10,fmin(3600,[target[@"interval"] doubleValue]));NSUInteger index=(NSUInteger)fmax(0,floor((now-anchor)/interval))%frames.count;selected=frames[index];}
    else {for(id value in frames){if(![value isKindOfClass:NSDictionary.class])continue;NSDate *from=DateValue(value[@"valid_from"]),*until=DateValue(value[@"valid_until"]);if(from&&until&&from.timeIntervalSince1970<=now&&now<until.timeIntervalSince1970){if(selected){selected=nil;break;}selected=value;}}}
    if(!selected&&!self.image&&[target[@"fallback"] isKindOfClass:NSDictionary.class])selected=target[@"fallback"];
    if(![selected isKindOfClass:NSDictionary.class])return;NSString *placement=[target[@"placement"] isEqual:@"fill"]?@"fill":@"fit";
    NSString *key=[NSString stringWithFormat:@"%@/%@",selected[@"sha256"],placement];if([key isEqual:self.imageKey])return;
    NSImage *image=[self verifiedImage:selected];if(!image)return;
    self.previous=self.image;self.previousPlacement=self.placement;self.image=image;self.imageKey=key;self.placement=placement;self.fadeStarted=now;self.needsDisplay=YES;
}
- (void)animateOneFrame {
    if(!self.isAnimating)return;
    NSTimeInterval now=NSDate.date.timeIntervalSince1970;if(now>=self.nextRead){self.nextRead=now+1;[self refreshFrame];}
    if(self.previous){self.needsDisplay=YES;if(now-self.fadeStarted>=1.5)self.previous=nil;}
}
- (void)drawImage:(NSImage *)image placement:(NSString *)placement alpha:(CGFloat)alpha {
    if(!image||image.size.width<=0||image.size.height<=0)return;
    CGFloat x=NSWidth(self.bounds)/image.size.width,y=NSHeight(self.bounds)/image.size.height,scale=[placement isEqual:@"fill"]?fmax(x,y):fmin(x,y);
    NSRect rect=NSMakeRect((NSWidth(self.bounds)-image.size.width*scale)/2,(NSHeight(self.bounds)-image.size.height*scale)/2,image.size.width*scale,image.size.height*scale);
    [image drawInRect:rect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:alpha respectFlipped:YES hints:@{NSImageHintInterpolation:@(NSImageInterpolationHigh)}];
}
- (void)drawRect:(NSRect)dirtyRect {
    [NSColor.blackColor setFill];NSRectFill(self.bounds);[NSGraphicsContext saveGraphicsState];NSRectClip(self.bounds);
    CGFloat alpha=self.previous?fmax(0,fmin(1,(NSDate.date.timeIntervalSince1970-self.fadeStarted)/1.5)):1;
    if(self.previous)[self drawImage:self.previous placement:self.previousPlacement alpha:1];[self drawImage:self.image?:self.fallback placement:self.image?self.placement:@"fit" alpha:alpha];
    [NSGraphicsContext restoreGraphicsState];
}
- (BOOL)hasConfigureSheet {return YES;}
- (NSWindow *)configureSheet {
    if(!self.settingsSheet){self.settingsSheet=[[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,540,230) styleMask:NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];self.settingsSheet.title=@"Виды и обои · Хранитель";
        NSTextField *text=[NSTextField wrappingLabelWithString:@"Коллекцию и расписание выбирайте в приложении: «Экран или хранитель» → «Хранитель экрана».\n\nДанные находятся автоматически. Хранитель читает общий кеш приложения; выбирать папку не нужно."];text.frame=NSMakeRect(22,108,496,102);[self.settingsSheet.contentView addSubview:text];
        self.dataStatus=[NSTextField wrappingLabelWithString:@""];self.dataStatus.frame=NSMakeRect(22,56,496,46);[self.settingsSheet.contentView addSubview:self.dataStatus];
        NSButton *done=[NSButton buttonWithTitle:@"Готово" target:self action:@selector(closeSettings:)];done.frame=NSMakeRect(410,16,108,32);done.keyEquivalent=@"\r";[self.settingsSheet.contentView addSubview:done];}
    [self resolveRoot];
    NSDictionary *settings=self.root?ReadJSON([self.root URLByAppendingPathComponent:@"settings.json"]):nil;
    NSDictionary *feed=self.root?ReadJSON([self.root URLByAppendingPathComponent:@"saver-state.json"]):nil;
    NSString *status=@"Данные пока недоступны. Включите хранитель в приложении и нажмите «Применить».";
    if([settings[@"saver"] isKindOfClass:NSDictionary.class]){
        if(![settings[@"saver"][@"enabled"] boolValue])status=@"Хранитель выключен в приложении.";
        else if([feed[@"schema"] integerValue]==1&&[feed[@"configuration_revision"] isEqual:settings[@"configuration_revision"]]&&[feed[@"targets"] isKindOfClass:NSDictionary.class]&&[feed[@"targets"] count])status=@"Данные приложения подключены автоматически.";
        else status=@"Настройки прочитаны. Приложение ещё не подготовило кадры.";
    }
    self.dataStatus.stringValue=status;return self.settingsSheet;
}
- (void)closeSettings:(id)sender {[NSApp endSheet:self.settingsSheet];[self.settingsSheet orderOut:nil];}
@end
