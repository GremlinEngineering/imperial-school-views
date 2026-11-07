#import <AppKit/AppKit.h>
#import <ScreenSaver/ScreenSaver.h>
#include <stdio.h>
#include <stdlib.h>

static void Expect(BOOL ok, NSString *message) {
    if (ok) return;
    fprintf(stderr, "FAIL: %s\n", message.UTF8String);
    exit(EXIT_FAILURE);
}

static NSData *Read(NSURL *root, NSString *name) {
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:[root URLByAppendingPathComponent:name] options:0 error:&error];
    Expect(data != nil, error.localizedDescription);
    return data;
}

static NSArray<NSDictionary *> *Frames(NSData *feed) {
    NSError *error = nil;
    NSDictionary *document = [NSJSONSerialization JSONObjectWithData:feed options:0 error:&error];
    Expect(document != nil, error.localizedDescription);
    return document[@"targets"][@"d1"][@"frames"];
}

static void WriteFeed(NSData *feed, NSURL *root) {
    NSError *error = nil;
    BOOL written = [feed writeToURL:[root URLByAppendingPathComponent:@"saver-state.json"] options:NSDataWritingAtomic error:&error];
    Expect(written, error.localizedDescription);
}

static ScreenSaverView *Start(Class saverClass, NSURL *root) {
    ScreenSaverView *view = [[saverClass alloc] initWithFrame:NSMakeRect(0, 0, 640, 480) isPreview:YES];
    Expect(view != nil, @"Could not instantiate the screen saver");
    [view setValue:root forKey:@"root"];
    [view startAnimation];
    Expect(view.isAnimating, @"Screen saver did not start animating");
    return view;
}

static BOOL Shows(ScreenSaverView *view, NSDictionary *frame) {
    NSString *key = [frame[@"sha256"] stringByAppendingString:@"/fit"];
    return key != nil && [[view valueForKey:@"imageKey"] isEqual:key] && [view valueForKey:@"image"] != nil;
}

static void WaitForFrame(ScreenSaverView *view, NSDictionary *frame, NSTimeInterval seconds, NSString *failure) {
    NSDate *deadline = [NSDate dateWithTimeIntervalSinceNow:seconds];
    do {
        [view animateOneFrame];
        if (Shows(view, frame)) return;
        [NSThread sleepForTimeInterval:0.05];
    } while (deadline.timeIntervalSinceNow > 0);
    Expect(NO, failure);
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        Expect(argc == 3, @"Usage: saver-checks SAVER_BUNDLE FIXTURES");
        [NSApplication sharedApplication];
        NSURL *bundleURL = [NSURL fileURLWithFileSystemRepresentation:argv[1] isDirectory:YES relativeToURL:nil];
        NSURL *fixtures = [NSURL fileURLWithFileSystemRepresentation:argv[2] isDirectory:YES relativeToURL:nil];
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        Class saverClass = bundle.principalClass;
        Expect([saverClass isSubclassOfClass:ScreenSaverView.class], @"Could not load the ScreenSaverView from the packaged bundle");

        NSURL *inherited = [fixtures URLByAppendingPathComponent:@"inherit" isDirectory:YES];
        NSArray *weather = Frames(Read(inherited, @"saver-state.json"));
        Expect(weather.count == 2, @"Expected two scheduled weather frames");
        ScreenSaverView *weatherView = Start(saverClass, inherited);
        Expect(Shows(weatherView, weather[0]), @"Inherited screen saver did not start on the desktop weather frame");

        NSURL *own = [fixtures URLByAppendingPathComponent:@"own-next" isDirectory:YES];
        NSURL *first = [fixtures URLByAppendingPathComponent:@"own-first" isDirectory:YES];
        NSData *firstFeed = Read(first, @"saver-state.json");
        NSData *nextFeed = Read(own, @"saver-state.json");
        WriteFeed(firstFeed, own);
        ScreenSaverView *ownView = Start(saverClass, own);
        Expect(Shows(ownView, Frames(firstFeed).firstObject), @"Own screen saver did not start on the compatibility JPEG");
        [ownView animateOneFrame];
        WriteFeed(nextFeed, own);
        WaitForFrame(ownView, Frames(nextFeed).firstObject, 4, @"Own screen saver did not reload the next compatibility JPEG");
        [ownView stopAnimation];
        puts("PASS packaged saver: own dynamic scene reloads the next JPEG while animating");

        WaitForFrame(weatherView, weather[1], 13, @"Inherited screen saver did not follow the cached weather schedule");
        [weatherView stopAnimation];
        puts("PASS packaged saver: inherited weather scene advances to the next cached frame");
    }
    return EXIT_SUCCESS;
}
