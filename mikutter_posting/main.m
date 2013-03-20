//
//  main.m
//  mikutter_posting
//
//  Created by Taiki on 3/21/13.
//  Copyright (c) 2013 osakana. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
  return macruby_main("rb_main.rb", argc, argv);
}
