//
//  Singleton.h
//  GMaps3D
//
//  Created by Igor Rendulic on 5/6/13.
//  Copyright (c) 2013 Igor Rendulic. All rights reserved.
//

/*!
* @function Singleton GCD Macro
*/
#ifndef MAKE_SINGLETON
#define MAKE_SINGLETON(classname)                        \
\
+ (classname *)shared##classname {                      \
\
static dispatch_once_t pred;                        \
__strong static classname * shared##classname = nil;\
dispatch_once( &pred, ^{                            \
shared##classname = [[self alloc] init]; });    \
return shared##classname;                           \
}
#endif