//
//  NSObject+NSObjects.m
//  LinUtil
//
//  Created by lin on 2/10/15.
//  Copyright (c) 2015 lin. All rights reserved.
//

#import "NSObjects.h"

@implementation NSObject (NSObjects)

-(id)performSelector:(SEL)selector withObjects:(NSArray *)objects{
    
    NSMethodSignature *signature = [self methodSignatureForSelector:selector];
    if (signature) {
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        for(int i = 0; i < [objects count]; i++){
            id object = [objects objectAtIndex:i];
            [invocation setArgument:&object atIndex: (i + 2)];
        }
        [invocation invoke];
        if (signature.methodReturnLength) {
            id anObject;
            [invocation getReturnValue:&anObject];
            return anObject;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
    
    return nil;
}
@end


const IMP _rac_objc_msgForward = _objc_msgForward;

void rac_objc_setAssociatedObject(const void* object, const void* key, id value, objc_AssociationPolicy policy) {
    __unsafe_unretained id obj = (__bridge typeof(obj)) object;
    objc_setAssociatedObject(obj, key, value, policy);
}

