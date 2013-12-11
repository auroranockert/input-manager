//
//  CSInputSource.m
//  InputManager
//
//  Created by Jens Nockert on 8/28/10.
//

#import "CSInputSource.h"

#import <Carbon/Carbon.h>

@implementation CSInputSource

- (id) initWithInputSource: (TISInputSourceRef) ref {
  if (self = [super init]) {
    mInputSource = ref;
  }

  return self;
}

+ (CSInputSource *) fromInputSource: (TISInputSourceRef) ref {
  return [[CSInputSource alloc] initWithInputSource: ref];
}

#pragma mark Public

+ (NSArray *) all {
  return [self withProperties: nil];
}

+ (NSArray *) withProperties: (NSDictionary *) properties {
  NSArray * inputs = CFBridgingRelease(TISCreateInputSourceList((__bridge CFDictionaryRef)properties, false));

  NSMutableArray * result = [NSMutableArray arrayWithCapacity: [inputs count]];

	for (CFIndex i = 0; i < [inputs count]; i++) {
		[result addObject: [CSInputSource fromInputSource: (TISInputSourceRef)CFRetain((TISInputSourceRef)inputs[i])]];
	}

  return result;
}

+ (CSInputSource *) forLanguage: (NSString *) language {
  return [CSInputSource fromInputSource: TISCopyInputSourceForLanguage((__bridge CFStringRef)language)];
}

+ (CSInputSource *) currentKeyboard {
  return [CSInputSource fromInputSource: TISCopyCurrentKeyboardInputSource()];
}

+ (CSInputSource *) currentKeyboardLayout {
  return [CSInputSource fromInputSource: TISCopyCurrentKeyboardLayoutInputSource()];
}

- (void *) getProperty: (CFStringRef) key {
  return TISGetInputSourceProperty((TISInputSourceRef)mInputSource, key);
}

- (NSString *) localizedName {
  return (NSString *)[self getProperty: kTISPropertyLocalizedName];
}

- (NSError *) select {
  return [NSError errorWithDomain: NSOSStatusErrorDomain code: TISSelectInputSource((TISInputSourceRef)mInputSource) userInfo: nil];
}

- (void) dealloc {
	CFRelease((TISInputSourceRef)mInputSource);
}

@end
