//
//  SearchContext.h
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
#import "SearchMatch.h"
#import "DocumentNodeType.h"
#import "DocumentNode.h"
@class SearchMatch;
@class DocumentNode;

@interface SearchContext : NSObject {

    NSMutableArray *allMatches;
    NSString *searchString;
    DocumentNodeType nodeTypes;

}

@property(nonatomic, retain) NSMutableArray *allMatches;
@property(nonatomic, retain) NSString *searchString;
@property DocumentNodeType nodeTypes;

-(SearchMatch *)getSearchMatchAtIndex:(NSUInteger)index;
-(NSUInteger)matchCount;
-(void)clearAll;
-(void)addSearchMatch:(SearchMatch *)match;

@end
