/*****************************************************************************
 * VLCStreamOutput.m: VLCKit.framework VLCStreamOutput implementation
 *****************************************************************************
 * Copyright (C) 2008 Pierre d'Herbemont
 * Copyright (C) 2008 the VideoLAN team
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

#import "VLCStreamOutput.h"
#import "VLCLibVLCBridging.h"

@implementation VLCStreamOutput
- (id)initWithOptionDictionary:(NSDictionary *)dictionary
{
    if( self = [super init] )
    {
        options = [[NSMutableDictionary dictionaryWithDictionary:dictionary] retain];
    }
    return self;
}
- (NSString *)description
{
    return [self representedLibVLCOptions];
}
+ (id)streamOutputWithOptionDictionary:(NSDictionary *)dictionary
{
    return [[[self alloc] initWithOptionDictionary:dictionary] autorelease];
}
+ (id)rtpBroadcastStreamOutputWithSAPAnnounce:(NSString *)announceName
{
    return [self streamOutputWithOptionDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"ts", @"muxer",
                                                @"file", @"access",
                                                @"sap", @"sdp",
                                                [announceName copy], @"name",
                                                @"239.255.1.1", @"destination", nil
                                            ], @"rtpOptions",
                                            nil
                                            ]
                                        ];
}

+ (id)rtpBroadcastStreamOutput
{
    return [self rtpBroadcastStreamOutputWithSAPAnnounce:@"Helloworld!"];
}

+ (id)ipodStreamOutputWithFilePath:(NSString *)filePath
{
    return [self streamOutputWithOptionDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"mp4v", @"videoCodec",
                                                @"1024",  @"videoBitrate",
                                                @"mp4a", @"audioCodec",
                                                @"192", @"audioBitrate",
                                                @"2",   @"channels",
                                                @"320", @"width",
                                                @"240", @"canvasHeight",
                                                @"Yes", @"audio-sync",
                                                nil
                                            ], @"transcodingOptions",
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"mp4", @"muxer",
                                                @"file", @"access",
                                                [filePath copy], @"destination", nil
                                            ], @"outputOptions",
                                            nil
                                            ]
                                        ];
}

+ (id)mpeg4StreamOutputWithFilePath:(NSString *)filePath
{
    return [self streamOutputWithOptionDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"mp4v", @"videoCodec",
                                                @"1024",  @"videoBitrate",
                                                @"mp4a", @"audioCodec",
                                                @"192", @"audioBitrate",
                                                nil
                                            ], @"transcodingOptions",
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"mp4", @"muxer",
                                                @"file", @"access",
                                                [filePath copy], @"destination", nil
                                            ], @"outputOptions",
                                            nil
                                            ]
                                        ];
}

+ (id)streamOutputWithFilePath:(NSString *)filePath
{
    return [self streamOutputWithOptionDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"ps", @"muxer",
                                                @"file", @"access",
                                                [filePath copy], @"destination", nil
                                            ], @"outputOptions",
                                            nil
                                            ]
                                        ];
}

+ (id)mpeg2StreamOutputWithFilePath:(NSString *)filePath;
{
    return [self streamOutputWithOptionDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"mp2v", @"videoCodec",
                                                @"1024", @"videoBitrate",
                                                @"mp2a",   @"audioCodec",
                                                @"128",   @"audioBitrate",
                                                @"Yes",   @"audio-sync",
                                                nil
                                            ], @"transcodingOptions",
                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"mpeg", @"muxer",
                                                @"file", @"access",
                                                [filePath copy], @"destination", nil
                                            ], @"outputOptions",
                                            nil
                                            ]
                                        ];
}
@end

@implementation VLCStreamOutput (LibVLCBridge)
- (NSString *)representedLibVLCOptions
{
    NSString * representedOptions;
    NSMutableArray * subOptions = [NSMutableArray array];
    NSMutableArray * optionsAsArray = [NSMutableArray array];
    NSDictionary * transcodingOptions = [options objectForKey:@"transcodingOptions"];
    if( transcodingOptions )
    {
        NSString * videoCodec = [transcodingOptions objectForKey:@"videoCodec"];
        NSString * audioCodec = [transcodingOptions objectForKey:@"audioCodec"];
        NSString * videoBitrate = [transcodingOptions objectForKey:@"videoBitrate"];
        NSString * audioBitrate = [transcodingOptions objectForKey:@"audioBitrate"];
        NSString * channels = [transcodingOptions objectForKey:@"channels"];
        NSString * height = [transcodingOptions objectForKey:@"height"];
        NSString * canvasHeight = [transcodingOptions objectForKey:@"canvasHeight"];
        NSString * width = [transcodingOptions objectForKey:@"width"];
        NSString * audioSync = [transcodingOptions objectForKey:@"audioSync"];
        NSString * videoEncoder = [transcodingOptions objectForKey:@"videoEncoder"];
        if( videoEncoder )   [subOptions addObject:[NSString stringWithFormat:@"venc=%@", videoEncoder]];
        if( videoCodec )   [subOptions addObject:[NSString stringWithFormat:@"vcodec=%@", videoCodec]];
        if( videoBitrate ) [subOptions addObject:[NSString stringWithFormat:@"vb=%@", videoBitrate]];
        if( width ) [subOptions addObject:[NSString stringWithFormat:@"width=%@", width]];
        if( height ) [subOptions addObject:[NSString stringWithFormat:@"height=%@", height]];
        if( canvasHeight ) [subOptions addObject:[NSString stringWithFormat:@"canvas-height=%@", canvasHeight]];
        if( audioCodec )   [subOptions addObject:[NSString stringWithFormat:@"acodec=%@", audioCodec]];
        if( audioBitrate ) [subOptions addObject:[NSString stringWithFormat:@"ab=%@", audioBitrate]];
        if( channels ) [subOptions addObject:[NSString stringWithFormat:@"channels=%@", channels]];
        if( audioSync ) [subOptions addObject:[NSString stringWithFormat:@"audioSync", width]];
        [optionsAsArray addObject: [NSString stringWithFormat:@"transcode{%@}", [subOptions componentsJoinedByString:@","]]];
        [subOptions removeAllObjects];
    }
    
    NSDictionary * outputOptions = [options objectForKey:@"outputOptions"];
    if( outputOptions )
    {
        NSString * muxer = [outputOptions objectForKey:@"muxer"];
        NSString * destination = [outputOptions objectForKey:@"destination"];
        NSString * url = [outputOptions objectForKey:@"url"];
        NSString * access = [outputOptions objectForKey:@"access"];
        if( muxer )       [subOptions addObject:[NSString stringWithFormat:@"mux=%@", muxer]];
        if( destination ) [subOptions addObject:[NSString stringWithFormat:@"dst=\"%@\"", [destination stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]]];
        if( url ) [subOptions addObject:[NSString stringWithFormat:@"url=\"%@\"", [url stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]]];
        if( access )      [subOptions addObject:[NSString stringWithFormat:@"access=%@", access]];
        [optionsAsArray addObject:[NSString stringWithFormat:@"std{%@}", [subOptions componentsJoinedByString:@","]]];
        [subOptions removeAllObjects];
    }

    NSDictionary * rtpOptions = [options objectForKey:@"rtpOptions"];
    if( rtpOptions )
    {
        NSString * muxer = [rtpOptions objectForKey:@"muxer"];
        NSString * destination = [rtpOptions objectForKey:@"destination"];
        NSString * sdp = [rtpOptions objectForKey:@"sdp"];
        NSString * name = [rtpOptions objectForKey:@"name"];
        if( muxer )       [subOptions addObject:[NSString stringWithFormat:@"muxer=%@", muxer]];
        if( destination ) [subOptions addObject:[NSString stringWithFormat:@"dst=%@", destination]];
        if( sdp )      [subOptions addObject:[NSString stringWithFormat:@"sdp=%@", sdp]];
        if( name )      [subOptions addObject:[NSString stringWithFormat:@"name=\"%@\"", name]];
        [optionsAsArray addObject:[NSString stringWithFormat:@"rtp{%@}", [subOptions componentsJoinedByString:@","]]];
        [subOptions removeAllObjects];
    }
    representedOptions = [optionsAsArray componentsJoinedByString:@":"];
    return representedOptions;
}
@end
