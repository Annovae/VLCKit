/*****************************************************************************
 * VLCTime.m: VLCKit.framework VLCTime implementation
 *****************************************************************************
 * Copyright (C) 2007 Pierre d'Herbemont
 * Copyright (C) 2007 the VideoLAN team
 * $Id$
 *
 * Authors: Pierre d'Herbemont <pdherbemont # videolan.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/

#import <VLCTime.h>

@implementation VLCTime
+ (VLCTime *)nullTime
{
    static VLCTime * nullTime = nil;
    if (!nullTime)
        nullTime = [[VLCTime timeWithNumber:nil] retain];
    return nullTime;
}

+ (VLCTime *)timeWithNumber:(NSNumber *)aNumber
{
    return [[[VLCTime alloc] initWithNumber:aNumber] autorelease];
}

// TODO: Implement [VLCTime timeWithString]
//+ (VLCTime *)timeWithString:(NSString *)aString
//{
//  return [[[VLCTime alloc] initWithString:aString] autorelease];
//}

- (id)initWithNumber:(NSNumber *)aNumber
{
    if (self = [super init])
    {
        if (aNumber)
            value = [[aNumber copy] retain];
        else
            value = nil;
    }
    return self;
}

// TODO: Implement [VLCTime initWithString]
//- (id)initWithString:(NSString *)aString
//{
//  // Sounds like a good idea but I really don't think there is any value added
//  if (self = [super init])
//  {
//      // convert value
//  }
//  return self;
//}

- (void)dealloc
{
    [value release];
    [super dealloc];
}

- (NSNumber *)numberValue
{
    return value ? [[value copy] autorelease] : nil;
}

- (NSString *)stringValue
{
    if (value)
    {
        long long duration = [value longLongValue] / 1000000;
        return [NSString stringWithFormat:@"%02d:%02d:%02d",
            (long) (duration / 3600),
            (long)((duration / 60) % 60),
            (long) (duration % 60)];
    }
    else
    {
        // Return a string that represents an undefined time.
        return @"--:--:--";
    }
}

- (NSComparisonResult)compare:(VLCTime *)aTime
{
    if (!aTime && !value)
        return NSOrderedSame;
    else if (!aTime)
        return NSOrderedDescending;
    else
        return [value compare:aTime.numberValue];
}

- (NSString *)description
{
    return self.stringValue;
}
@end
