//
//  VarioComm.h
//  FlyteParkDevice
//
//  Created by Brian Vogel on 8/21/11.
//  Copyright 2011 Techrhythm. All rights reserved.
//
 
static const Byte SET_MAGIC  = 0x24;
static const Byte GET_MAGIC = 0x23;
static const int MIN_PACKET_SIZE = 4;  //Magic,Command,Checksum,Length 
static const int FIRST_TRACK = 0x002000;
static const int LAST_TRACK = 0x1FFFFA;

typedef enum VarioCommand
{
    VC_INITIALIZE = 0x00,
    VC_REALTIME_DATA_MODE = 0x01,
    VC_READ_OPTIONS = 0x02,
    VC_READ_OPTION = 0x03,
    VC_WRITE_OPTIONS = 0x04,
    VC_WRITE_OPTION = 0x05,
    VC_READ_LOG = 0x06,
    VC_READ_TRACK = 0x07,
    VC_ERASE_TRACKS = 0x08,
    VC_ERASE_FLIGHTS = 0x09,
    VC_SET_FACTORY_DEFAULTS = 0x0A,
    VC_READ_ID = 0x0B,
    VC_READ_RTC = 0x0C,
    VC_WRITE_RTC = 0x0D,
    VC_READ_TRACK_LOG_COUNT = 0x0E,
    VC_READ_TRACK_STATISTICS = 0x0F,
    VC_FACTORY_TEST = 0x10,
    VC_END_REALTIME = 0x11,
    VC_SET_VARIO_AUDIO = 0x12
    //LAST = 0x0E
} VarioCommand;

/// <summary>
/// Possible vario responses
/// </summary>
typedef enum VarioResponse
{
    VR_REALTIME_DATA = 0x00,
    VR_OK = 0x01,
    VR_OPTIONS = 0x02,
    VR_OPTION = 0x03,
    VR_LOG = 0x04,
    VR_TRACK = 0x05,
    VR_ID = 0x06,
    VR_RTC = 0x07,
    VR_TRLOG_COUNT = 0x08,
    VR_BAD_MAGIC = 0x09,
    VR_BAD_NBYTES = 0x0A,
    VR_BAD_CHECKSUM = 0x0B,
    VR_BAD_COMMAND = 0x0C,
    VR_BAD_PARAMETER = 0x0D,
    VR_MISSED_PACKETS = 0x0E,
    VR_INITIALIZED = 0x0F,
    VR_TRACK_STATISTICS = 0x10,
    VR_TIMING = 0xFF
    //LAST = 0x0E
} VarioResponse;