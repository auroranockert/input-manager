//
//  CSInputSource.h
//  InputManager
//
//  Created by Jens Nockert on 8/28/10.
//

#import <Foundation/Foundation.h>

@interface CSInputSource : NSObject {
  @private void * mInputSource;
}

+ (NSArray *) all;
+ (NSArray *) withProperties: (NSDictionary *) properties;

+ (CSInputSource *) forLanguage: (NSString *) language;

+ (CSInputSource *) currentKeyboard;
+ (CSInputSource *) currentKeyboardLayout;

- (void *) getProperty: (NSString *) key;
- (NSString *) localizedName;

- (NSError *) select;

@end
