/*****************************************************************************
 * VLCAudio.m: VLC.framework VLCAudio implementation
 *****************************************************************************
 * Copyright (C) 2007 Faustino E. Osuna
 * Copyright (C) 2007 the VideoLAN team
 * $Id$
 *
 * Authors: Faustino E. Osuna <enrique.osuna # gmail.com>
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

#import "VLCAudio.h"
#import "VLCLibVLCBridging.h"

/* Notification Messages */
NSString * VLCMediaPlayerVolumeChanged = @"VLCMediaPlayerVolumeChanged"; 

/* libvlc event callback */
// TODO: Callbacks

@implementation VLCAudio

- (id)init
{
    return nil;
}

- (id)initWithLibrary:(VLCLibrary *)aLibrary
{
    if (![library audio] && (self = [super init]))
    {
        library = aLibrary;
        [library setAudio:self];
    }
    return self;
}

- (void)setMute:(BOOL)value
{
    libvlc_audio_set_mute([library instance], value, NULL);
}

- (BOOL)isMuted
{
    libvlc_exception_t ex;
    libvlc_exception_init(&ex);
    BOOL result = libvlc_audio_get_mute([library instance], &ex);
    catch_exception(&ex);
    
    return result;
}

- (void)setVolume:(int)value
{
    if (value < 0)
        value = 0;
    else if (value > 200)
        value = 200;
    libvlc_audio_set_volume([library instance], value, NULL);
}

- (int)volume
{
    libvlc_exception_t ex;
    libvlc_exception_init(&ex);
    int result = libvlc_audio_get_volume([library instance], &ex);
    catch_exception(&ex);
    return result;
}
@end
