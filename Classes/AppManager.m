//
//  AppManager.m
//  mmwrMockup
//
//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


#import "AppManager.h"
#import "Debug.h"

static AppManager *sharedAppManager = nil;

@implementation AppManager


@synthesize appName, doc, searchContext, navController, tableFont, agreedWithEula;

#pragma mark Singleton Methods
+ (id)singletonAppManager {
	@synchronized(self) {
		if(sharedAppManager == nil)
			[[self alloc] init];
	}
	return sharedAppManager;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedAppManager == nil)  {
			sharedAppManager = [super allocWithZone:zone];
			return sharedAppManager;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}

- (id)autorelease {
	return self;
}

- (id)init {
	if ((self = [super init])) {
		self.appName = @"STD Guide";
		self.tableFont = [UIFont boldSystemFontOfSize: 16];
        self.agreedWithEula = FALSE;

	}
	return self;
}

- (void)dealloc {

	// Should never be called, but just here for clarity really.
	[appName release];
	[super dealloc];

}

@end
