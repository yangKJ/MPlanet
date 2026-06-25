#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef struct supported_type {
    const char *encoding;
} supported_type_t;

static supported_type_t supported_types[] = {
    { .encoding = @encode(void)},
    { .encoding = @encode(id)},
    { .encoding = @encode(Class)},
    { .encoding = @encode(void (^)(void))},
    { .encoding = @encode(char)},
    { .encoding = @encode(short)},
    { .encoding = @encode(int)},
    { .encoding = @encode(long)},
    { .encoding = @encode(long long)},
    { .encoding = @encode(unsigned char)},
    { .encoding = @encode(unsigned short)},
    { .encoding = @encode(unsigned int)},
    { .encoding = @encode(unsigned long)},
    { .encoding = @encode(unsigned long long)},
    { .encoding = @encode(float)},
    { .encoding = @encode(double)},
    { .encoding = @encode(BOOL)},
    { .encoding = @encode(const char*)},
};

static BOOL __objc_methodReturnTypeIsSupported(const char *type) {
    if (type == nil) {
        return NO;
    }
    
    for (int i = 0; i < sizeof(supported_types) / sizeof(supported_type_t); ++i) {
        if (supported_types[i].encoding[0] != type[0]) {
            continue;
        }
        if (strcmp(supported_types[i].encoding, type) == 0) {
            return YES;
        }
    }
    
    return NO;
}

static id __objc_getReturnValue(NSInvocation *inv, NSMethodSignature *sig) {
    NSUInteger length = [sig methodReturnLength];
    if (length == 0) return nil;
    
    char *type = (char *)[sig methodReturnType];
    while (*type == 'r' || *type == 'n' || *type == 'N' || *type == 'o' || *type == 'O' || *type == 'R' || *type == 'V') {
        type++;
    }
    
    if (strcmp(type, @encode(id)) == 0 || strcmp(type, @encode(Class)) == 0 || strcmp(type, @encode(void(^)(void))) == 0) {
        __unsafe_unretained id value = nil;
        [inv getReturnValue:&value];
        return value;
    } else if (strcmp(type, @encode(char)) == 0) {
        char value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(short)) == 0) {
        short value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(int)) == 0) {
        int value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(long)) == 0) {
        long value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(float)) == 0) {
        float value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(double)) == 0) {
        double value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(BOOL)) == 0) {
        BOOL value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else if (strcmp(type, @encode(const char *)) == 0) {
        const char * value = 0;
        [inv getReturnValue:&value];
        return @(value);
    } else {
        NSUInteger size = 0;
        NSGetSizeAndAlignment(type, &size, NULL);
        uint8_t data[size];
        [inv getReturnValue:&data];
        return [NSValue valueWithBytes:&data objCType:type];
    }
}

static id __objc_msgSend_internal(id target, SEL selector, NSDictionary<NSString *, id> *arguments) {
    NSMethodSignature *signature = [target methodSignatureForSelector:selector];
    
    if (!signature) {
        NSLog(@"[Mediator] Error: Method signature does not exist for selector %@", NSStringFromSelector(selector));
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = target;
    invocation.selector = selector;
    
    NSUInteger numberOfArguments = [signature numberOfArguments];
    
    if (arguments && numberOfArguments > 2) {
        [invocation setArgument:&arguments atIndex:2];
    }
    
    [invocation invoke];
    
    if (!__objc_methodReturnTypeIsSupported(signature.methodReturnType)) {
        NSLog(@"[Mediator] Error: Method return type is unsupported: %s", signature.methodReturnType);
        return nil;
    }
    
    return __objc_getReturnValue(invocation, signature);
}

// 主函数
extern "C" id __objc_performSelector(NSString *selName, NSString *clsName, NSString *moduleName, NSDictionary<NSString *, id> *params) {
    if (!selName || !clsName) {
        NSLog(@"[Mediator] Error: selName or clsName is nil");
        return nil;
    }
    
    NSString *fullClassName = clsName;
    if (moduleName.length > 0) {
        fullClassName = [NSString stringWithFormat:@"%@.%@", moduleName, clsName];
    }
    
    Class clazz = NSClassFromString(fullClassName);
    if (!clazz) {
        clazz = NSClassFromString(clsName);
    }
    
    if (!clazz) {
        NSLog(@"[Mediator] Error: Class %@ not found", fullClassName);
        return nil;
    }
    
    SEL sel = NSSelectorFromString(selName);
    if (!sel) {
        NSLog(@"[Mediator] Error: Selector %@ not found", selName);
        return nil;
    }
    
    id target = [[clazz alloc] init];
    if (!target) {
        NSLog(@"[Mediator] Error: Failed to create instance of %@", fullClassName);
        return nil;
    }
    
    if (![target respondsToSelector:sel]) {
        NSLog(@"[Mediator] Error: Target %@ does not respond to selector %@", fullClassName, selName);
        return nil;
    }
    
    return __objc_msgSend_internal(target, sel, params);
}
