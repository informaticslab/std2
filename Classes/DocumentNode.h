//
//  DocumentNode.h
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
#import "SearchContext.h"
#import "DocumentNodeType.h"

@class SearchContext;


@interface DocumentNode : NSObject {

	DocumentNodeType type;
	NSString *text;
	NSString *contentText;
	DocumentNode *parentNode;
	NSMutableArray *childNodes;
	NSString *contentFilePath;

}

@property(nonatomic, retain) NSString *text;
@property(nonatomic, retain) NSString *contentText;
@property(nonatomic, retain) NSMutableArray *childNodes;
@property(nonatomic, retain) NSString *contentFilePath;
@property(nonatomic, retain) DocumentNode *parentNode;

@property DocumentNodeType type;

-(id)initWithTextAndType:(NSString *)nodeText nodeType:(DocumentNodeType)newNodeType;
-(id)initWithTextTypeContentFile:(NSString *)nodeText nodeType:(DocumentNodeType)nodeType contentFile:(NSString *)content;
-(NSUInteger)getChildNodeCount;
-(void)addChildDocumentNode:(DocumentNode *)childNode;
-(void)addChildNodesToArray:(NSMutableArray *)destArray;
-(void)printChildNodes;
-(DocumentNode *)childNodeAtIndex:(NSUInteger)index;
-(BOOL)hasChildContentNode;
-(BOOL)isContentNode;
-(NSString *)removeHtmlTags:(NSString *)html;
-(NSString *)readAppBundleTextFile;
-(void)searchForText:(SearchContext *)context;
-(void)searchForContentText:(SearchContext *)context;
-(void)searchForHeaderText:(SearchContext *)context;
-(void)loadContentText;


@end
