//
//  CSInputSource.m
//  InputManager
//
//  Created by Jens Nockert on 8/28/10.
//

#import "CSInputSource.h"

#import <Carbon/Carbon.h>

@implementation CSInputSource

- (id) initWithInputSource: (TISInputSourceRef) ref
{
  if (self = [super init]) {    
    mInputSource = ref;
    
    CFRetain(mInputSource);
  }
  
  return self;
}

+ (CSInputSource *) fromInputSource: (TISInputSourceRef) ref
{
  return [[CSInputSource alloc] initWithInputSource: ref];
}

#pragma mark Public

+ (NSArray *) all
{
  return [self withProperties: nil];
}

+ (NSArray *) withProperties: (NSDictionary *) properties
{
  NSArray * inputs = (NSArray *)TISCreateInputSourceList((CFDictionaryRef)properties, false);
  
  NSMutableArray * result = [NSMutableArray arrayWithCapacity: [inputs count]];
  
  for (id ref in inputs) {
    [result addObject: [CSInputSource fromInputSource: (TISInputSourceRef)ref]];
  }
  
  CFMakeCollectable(inputs);
  
  return result;
}

+ (CSInputSource *) forLanguage: (NSString *) language
{
  TISInputSourceRef ref = TISCopyInputSourceForLanguage((CFStringRef)language);
  
  CSInputSource * result = [CSInputSource fromInputSource: ref];
  
  CFMakeCollectable(ref);
  
  return result;
}

+ (CSInputSource *) currentKeyboard
{
  TISInputSourceRef ref = TISCopyCurrentKeyboardInputSource();
  
  CSInputSource * result = [CSInputSource fromInputSource: ref];
  
  CFMakeCollectable(ref);
  
  return result;
}

+ (CSInputSource *) currentKeyboardLayout
{
  TISInputSourceRef ref = TISCopyCurrentKeyboardLayoutInputSource();
  
  CSInputSource * result = [CSInputSource fromInputSource: ref];
  
  CFMakeCollectable(ref);
  
  return result;
}

- (void *) getProperty: (NSString *) key
{
  return TISGetInputSourceProperty((TISInputSourceRef)mInputSource, (CFStringRef)key);
}

- (NSString *) localizedName
{
  return (NSString *)[self getProperty: (NSString *)kTISPropertyLocalizedName];
}

- (NSError *) select
{
  return [NSError errorWithDomain: NSOSStatusErrorDomain code: TISSelectInputSource((TISInputSourceRef)mInputSource) userInfo: nil];
}

- (void) finalize
{
  CFMakeCollectable(mInputSource);
  
  [super finalize];
}

@end
