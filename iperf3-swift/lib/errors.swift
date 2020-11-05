//
//  errors.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import Foundation

enum IperfError: Int32 {
    case UNKNOWN = -1
    case IENONE = 0             // No error
    /* Parameter errors */
    case IESERVCLIENT = 1       // Iperf cannot be both server and client
    case IENOROLE = 2           // Iperf must either be a client (-c) or server (-s)
    case IESERVERONLY = 3       // This option is server only
    case IECLIENTONLY = 4       // This option is client only
    case IEDURATION = 5         // test duration too long. Maximum value = %dMAX_TIME
    case IENUMSTREAMS = 6       // Number of parallel streams too large. Maximum value = %dMAX_STREAMS
    case IEBLOCKSIZE = 7        // Block size too large. Maximum value = %dMAX_BLOCKSIZE
    case IEBUFSIZE = 8          // Socket buffer size too large. Maximum value = %dMAX_TCP_BUFFER
    case IEINTERVAL = 9         // Invalid report interval (min = %gMIN_INTERVAL max = %gMAX_INTERVAL seconds)
    case IEMSS = 10             // MSS too large. Maximum value = %dMAX_MSS
    case IENOSENDFILE = 11      // This OS does not support sendfile
    case IEOMIT = 12            // Bogus value for --omit
    case IEUNIMP = 13           // Not implemented yet
    case IEFILE = 14            // -F file couldn't be opened
    case IEBURST = 15           // Invalid burst count. Maximum value = %dMAX_BURST
    case IEENDCONDITIONS = 16   // Only one test end condition (-t -n -k) may be specified
    case IELOGFILE = 17        // Can't open log file
    case IENOSCTP = 18        // No SCTP support available
    case IEBIND = 19        // UNUSED:  Local port specified with no local bind option
    case IEUDPBLOCKSIZE = 20    // Block size invalid
    case IEBADTOS = 21        // Bad TOS value
    case IESETCLIENTAUTH = 22   // Bad configuration of client authentication
    case IESETSERVERAUTH = 23   // Bad configuration of server authentication
    case IEBADFORMAT = 24        // Bad format argument to -f
    case IEREVERSEBIDIR = 25    // Iperf cannot be both reverse and bidirectional
    case IEBADPORT = 26        // Bad port number
    case IETOTALRATE = 27       // Total required bandwidth is larger than server's limit
    case IETOTALINTERVAL = 28   // Invalid time interval for calculating average data rate
    /* Test errors */
    case IENEWTEST = 100        // Unable to create a new test (check perror)
    case IEINITTEST = 101       // Test initialization failed (check perror)
    case IELISTEN = 102         // Unable to listen for connections (check perror)
    case IECONNECT = 103        // Unable to connect to server (check herror/perror) [from netdial]
    case IEACCEPT = 104         // Unable to accept connection from client (check herror/perror)
    case IESENDCOOKIE = 105     // Unable to send cookie to server (check perror)
    case IERECVCOOKIE = 106     // Unable to receive cookie from client (check perror)
    case IECTRLWRITE = 107      // Unable to write to the control socket (check perror)
    case IECTRLREAD = 108       // Unable to read from the control socket (check perror)
    case IECTRLCLOSE = 109      // Control socket has closed unexpectedly
    case IEMESSAGE = 110        // Received an unknown message
    case IESENDMESSAGE = 111    // Unable to send control message to client/server (check perror)
    case IERECVMESSAGE = 112    // Unable to receive control message from client/server (check perror)
    case IESENDPARAMS = 113     // Unable to send parameters to server (check perror)
    case IERECVPARAMS = 114     // Unable to receive parameters from client (check perror)
    case IEPACKAGERESULTS = 115 // Unable to package results (check perror)
    case IESENDRESULTS = 116    // Unable to send results to client/server (check perror)
    case IERECVRESULTS = 117    // Unable to receive results from client/server (check perror)
    case IESELECT = 118         // Select failed (check perror)
    case IECLIENTTERM = 119     // The client has terminated
    case IESERVERTERM = 120     // The server has terminated
    case IEACCESSDENIED = 121   // The server is busy running a test. Try again later.
    case IESETNODELAY = 122     // Unable to set TCP/SCTP NODELAY (check perror)
    case IESETMSS = 123         // Unable to set TCP/SCTP MSS (check perror)
    case IESETBUF = 124         // Unable to set socket buffer size (check perror)
    case IESETTOS = 125         // Unable to set IP TOS (check perror)
    case IESETCOS = 126         // Unable to set IPv6 traffic class (check perror)
    case IESETFLOW = 127        // Unable to set IPv6 flow label
    case IEREUSEADDR = 128      // Unable to set reuse address on socket (check perror)
    case IENONBLOCKING = 129    // Unable to set socket to non-blocking (check perror)
    case IESETWINDOWSIZE = 130  // Unable to set socket window size (check perror)
    case IEPROTOCOL = 131       // Protocol does not exist
    case IEAFFINITY = 132       // Unable to set CPU affinity (check perror)
    case IEDAEMON = 133        // Unable to become a daemon process
    case IESETCONGESTION = 134  // Unable to set TCP_CONGESTION
    case IEPIDFILE = 135        // Unable to write PID file
    case IEV6ONLY = 136          // Unable to set/unset IPV6_V6ONLY (check perror)
    case IESETSCTPDISABLEFRAG = 137 // Unable to set SCTP Fragmentation (check perror)
    case IESETSCTPNSTREAM = 138  //  Unable to set SCTP number of streams (check perror)
    case IESETSCTPBINDX = 139    // Unable to process sctp_bindx() parameters
    case IESETPACING = 140       // Unable to set socket pacing rate
    case IESETBUF2 = 141        // Socket buffer size incorrect (written value != read value)
    case IEAUTHTEST = 142       // Test authorization failed
    /* Stream errors */
    case IECREATESTREAM = 200   // Unable to create a new stream (check herror/perror)
    case IEINITSTREAM = 201     // Unable to initialize stream (check herror/perror)
    case IESTREAMLISTEN = 202   // Unable to start stream listener (check perror)
    case IESTREAMCONNECT = 203  // Unable to connect stream (check herror/perror)
    case IESTREAMACCEPT = 204   // Unable to accepte stream connection (check perror)
    case IESTREAMWRITE = 205    // Unable to write to stream socket (check perror)
    case IESTREAMREAD = 206     // Unable to read from stream (check perror)
    case IESTREAMCLOSE = 207    // Stream has closed unexpectedly
    case IESTREAMID = 208       // Stream has invalid ID
    /* Timer errors */
    case IENEWTIMER = 300       // Unable to create new timer (check perror)
    case IEUPDATETIMER = 301    // Unable to update timer (check perror)
    
    var debugDescription: String {
        switch self {
        case .UNKNOWN:
            return "Unknown error"
        case .IENONE:
            return "No error"
        /* Parameter errors */
        case .IESERVCLIENT:
            return "Iperf cannot be both server and client"
        case .IENOROLE:
            return "Iperf must either be a client (-c) or server (-s)"
        case .IESERVERONLY:
            return "This option is server only"
        case .IECLIENTONLY:
            return "This option is client only"
        case .IEDURATION:
            return "test duration too long. Maximum value = %dMAX_TIME"
        case .IENUMSTREAMS:
            return "Number of parallel streams too large. Maximum value = %dMAX_STREAMS"
        case .IEBLOCKSIZE:
            return "Block size too large. Maximum value = %dMAX_BLOCKSIZE"
        case .IEBUFSIZE:
            return "Socket buffer size too large. Maximum value = %dMAX_TCP_BUFFER"
        case .IEINTERVAL:
            return "Invalid report interval (min = %gMIN_INTERVAL max = %gMAX_INTERVAL seconds)"
        case .IEMSS:
            return "MSS too large. Maximum value = %dMAX_MSS"
        case .IENOSENDFILE:
            return "This OS does not support sendfile"
        case .IEOMIT:
            return "Bogus value for --omit"
        case .IEUNIMP:
            return "Not implemented yet"
        case .IEFILE:
            return "-F file couldn't be opened"
        case .IEBURST:
            return "Invalid burst count. Maximum value = %dMAX_BURST"
        case .IEENDCONDITIONS:
            return "Only one test end condition (-t -n -k) may be specified"
        case .IELOGFILE:
            return "Can't open log file"
        case .IENOSCTP:
            return "No SCTP support available"
        case .IEBIND:
            return "UNUSED:  Local port specified with no local bind option"
        case .IEUDPBLOCKSIZE:
            return "Block size invalid"
        case .IEBADTOS:
            return "Bad TOS value"
        case .IESETCLIENTAUTH:
            return "Bad configuration of client authentication"
        case .IESETSERVERAUTH:
            return "Bad configuration of server authentication"
        case .IEBADFORMAT:
            return "Bad format argument to -f"
        case .IEREVERSEBIDIR:
            return "Iperf cannot be both reverse and bidirectional"
        case .IEBADPORT:
            return "Bad port number"
        case .IETOTALRATE:
            return "Total required bandwidth is larger than server's limit"
        case .IETOTALINTERVAL:
            return "Invalid time interval for calculating average data rate"
        /* Test errors */
        case .IENEWTEST:
            return "Unable to create a new test (check perror)"
        case .IEINITTEST:
            return "Test initialization failed (check perror)"
        case .IELISTEN:
            return "Unable to listen for connections (check perror)"
        case .IECONNECT:
            return "Unable to connect to server (check herror/perror) [from netdial]"
        case .IEACCEPT:
            return "Unable to accept connection from client (check herror/perror)"
        case .IESENDCOOKIE:
            return "Unable to send cookie to server (check perror)"
        case .IERECVCOOKIE:
            return "Unable to receive cookie from client (check perror)"
        case .IECTRLWRITE:
            return "Unable to write to the control socket (check perror)"
        case .IECTRLREAD:
            return "Unable to read from the control socket (check perror)"
        case .IECTRLCLOSE:
            return "Control socket has closed unexpectedly"
        case .IEMESSAGE:
            return "Received an unknown message"
        case .IESENDMESSAGE:
            return "Unable to send control message to client/server (check perror)"
        case .IERECVMESSAGE:
            return "Unable to receive control message from client/server (check perror)"
        case .IESENDPARAMS:
            return "Unable to send parameters to server (check perror)"
        case .IERECVPARAMS:
            return "Unable to receive parameters from client (check perror)"
        case .IEPACKAGERESULTS:
            return "Unable to package results (check perror)"
        case .IESENDRESULTS:
            return "Unable to send results to client/server (check perror)"
        case .IERECVRESULTS:
            return "Unable to receive results from client/server (check perror)"
        case .IESELECT:
            return "Select failed (check perror)"
        case .IECLIENTTERM:
            return "The client has terminated"
        case .IESERVERTERM:
            return "The server has terminated"
        case .IEACCESSDENIED:
            return "The server is busy running a test. Try again later."
        case .IESETNODELAY:
            return "Unable to set TCP/SCTP NODELAY (check perror)"
        case .IESETMSS:
            return "Unable to set TCP/SCTP MSS (check perror)"
        case .IESETBUF:
            return "Unable to set socket buffer size (check perror)"
        case .IESETTOS:
            return "Unable to set IP TOS (check perror)"
        case .IESETCOS:
            return "Unable to set IPv6 traffic class (check perror)"
        case .IESETFLOW:
            return "Unable to set IPv6 flow label"
        case .IEREUSEADDR:
            return "Unable to set reuse address on socket (check perror)"
        case .IENONBLOCKING:
            return "Unable to set socket to non-blocking (check perror)"
        case .IESETWINDOWSIZE:
            return "Unable to set socket window size (check perror)"
        case .IEPROTOCOL:
            return "Protocol does not exist"
        case .IEAFFINITY:
            return "Unable to set CPU affinity (check perror)"
        case .IEDAEMON:
            return "Unable to become a daemon process"
        case .IESETCONGESTION:
            return "Unable to set TCP_CONGESTION"
        case .IEPIDFILE:
            return "Unable to write PID file"
        case .IEV6ONLY:
            return "Unable to set/unset IPV6_V6ONLY (check perror)"
        case .IESETSCTPDISABLEFRAG:
            return "Unable to set SCTP Fragmentation (check perror)"
        case .IESETSCTPNSTREAM:
            return "Unable to set SCTP number of streams (check perror)"
        case .IESETSCTPBINDX:
            return "Unable to process sctp_bindx() parameters"
        case .IESETPACING:
            return "Unable to set socket pacing rate"
        case .IESETBUF2:
            return "Socket buffer size incorrect (written value != read value)"
        case .IEAUTHTEST:
            return "Test authorization failed"
        /* Stream errors */
        case .IECREATESTREAM:
            return "Unable to create a new stream (check herror/perror)"
        case .IEINITSTREAM:
            return "Unable to initialize stream (check herror/perror)"
        case .IESTREAMLISTEN:
            return "Unable to start stream listener (check perror)"
        case .IESTREAMCONNECT:
            return "Unable to connect stream (check herror/perror)"
        case .IESTREAMACCEPT:
            return "Unable to accepte stream connection (check perror)"
        case .IESTREAMWRITE:
            return "Unable to write to stream socket (check perror)"
        case .IESTREAMREAD:
            return "Unable to read from stream (check perror)"
        case .IESTREAMCLOSE:
            return "Stream has closed unexpectedly"
        case .IESTREAMID:
            return "Stream has invalid ID"
        /* Timer errors */
        case .IENEWTIMER:
            return "Unable to create new timer (check perror)"
        case .IEUPDATETIMER:
            return "Unable to update timer (check perror)"
        }
    }
}
