#ifndef mediator_h
#define mediator_h

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

id __objc_performSelector(NSString *selName, NSString *clsName, NSString *moduleName, NSDictionary<NSString *, id> *params);

#ifdef __cplusplus
}
#endif

#endif /* mediator_h */
