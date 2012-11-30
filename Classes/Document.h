//
//  Document.h
//  StdGuide
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
#import "DocumentNode.h"
#import "SearchContext.h"

@class DocumentMap;

@interface Document : NSObject 
{
    DocumentNode *rootNode;
	NSArray *allNodes;
	DocumentMap *docMap;
}

@property(nonatomic, retain) DocumentNode *rootNode;
@property(nonatomic, retain) DocumentMap *docMap;
@property(nonatomic, retain) NSArray *allNodes;

-(void)loadTestData;
-(void)createArrayOfNodes;
-(void)searchForText:(SearchContext *)context;
-(void)testSearch;



@end
