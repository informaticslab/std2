//
//  Keywords.m
//  std2
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


#import "Keywords.h"


@implementation Keywords

@synthesize keywords;

-(id)init
{
    self.keywords = [[NSMutableArray alloc] initWithObjects:
        
        @"bacterial vaginosis",
        @"vulvovaginal candidiasis",
        @"cervicitis",
        @"chancroid",
        @"chlamydia",
        @"epididymitis",
        @"genital warts",
        @"gonorrhea",
        @"hepatitis A",
        @"hepatitis B",
        @"hepatitis C",
        @"herpes",
        @"lymphogranuloma venereum",
        @"pediculosis pubis",
        @"pelvic inflammatory disease",
        @"proctitis",
        @"colitis",
        @"enteritis",
        @"scabies",
        @"syphilis",
        @"trichomoniasis",
        @"urethritis",
        nil];
        
    return self;

    
    
}
@end
