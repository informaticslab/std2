//
//  DocumentMap.h
//  Std-Guide
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


#import <Foundation/Foundation.h>
#import "AppManager.h"
#import "DocumentNode.h"

@interface DocumentMap : NSObject 
{
	NSString *csvAsString;
	NSArray *csvAsArray;
	DocumentNode *rootNode;

}

@property (nonatomic, retain) NSString *csvAsString;
@property (nonatomic, retain) NSArray *csvAsArray;
@property (nonatomic, retain) DocumentNode *rootNode;

-(NSString *)readDocumentMapFile;
-(NSArray *)parse:(NSString *)fileContents;
-(DocumentNode *)createDocumentNodes;


@end
