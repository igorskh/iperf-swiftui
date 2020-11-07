//
//  types.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import Foundation

protocol HasDescription {
    var description: String { get }
    var uiImage: String? { get }
}

enum IperfRunnerState {
    case unknown
    case ready
    case initialising
    case running
}

enum IperfProtocol: HasDescription {
    case tcp
    case udp
    case sctp
    
    var uiImage: String? {
        return nil
    }
    var description: String {
        switch self {
        case .tcp:
            return "TCP"
        case .udp:
            return "UDP"
        case .sctp:
            return "SCTP"
        }
    }
    var iperfConfigValue: Int32 {
        switch self {
        case .tcp:
            return Ptcp
        case .udp:
            return Pudp
        case .sctp:
            return Psctp
        }
        
    }
}

enum IperfRole: Int8, HasDescription {
    case server = 115
    case client = 99
    
    var uiImage: String? {
        return nil
    }
    var description: String {
        switch self {
        case .client:
            return "Client"
        case .server:
            return "Server"
        }
    }
}

enum IperfDirection: Int32, HasDescription {
    case download = 1
    case upload = 0
    
    var uiImage: String? {
        switch self {
        case .download:
            return "arrow.down"
        case .upload:
            return "arrow.up"
        }
    }
    var description: String {
        switch self {
        case .download:
            return "Download"
        case .upload:
            return "Upload"
        }
    }
}

enum IperfState: Int8 {
    case TEST_START = 1
    case TEST_RUNNING = 2
    case TEST_END = 4
    case PARAM_EXCHANGE = 9
    case CREATE_STREAMS = 10
    case SERVER_TERMINATE = 11
    case CLIENT_TERMINATE = 12
    case EXCHANGE_RESULTS = 13
    case DISPLAY_RESULTS = 14
    case IPERF_START = 15
    case IPERF_DONE = 16
    case ACCESS_DENIED = -1
    case SERVER_ERROR = -2
    
    case UNKNOWN = 0
    case INIT_ERROR = -10
}

enum IperfNotificationName: String {
    case status = "reporter"
}

extension Notification.Name {
    init(_ enumValue: IperfNotificationName) {
        self.init(enumValue.rawValue)
    }
}

struct IperfConfiguration {
    var address: String? = "bouygues.iperf.fr"
    var numStreams = 2
    var role = IperfRole.client
    var reverse = IperfDirection.download
    var port = 5201
    var prot = IperfProtocol.tcp
    
    var rate: UInt64 = UInt64(UDP_RATE)
    
    var duration: TimeInterval?
    var timeout: TimeInterval?
    var tos: Int?
    
    var reporterInterval: TimeInterval?
    var statsInterval: TimeInterval?
}

struct IperfThroughput {
    var rawValue: Double
    var bitsValue: Double
    
    var Mbps: Double {
        return bitsValue / 1e6
    }
    var Gbps: Double {
        return bitsValue / 1e9
    }
    
    init(bytesPerSecond initValue: Double) {
        rawValue = initValue
        bitsValue = initValue*8
    }
    
    init(bytes initValue: UInt64, seconds: TimeInterval) {
        self.init(bytesPerSecond: Double(initValue) / seconds)
    }
}

struct IperfStreamIntervalResult {
//#if (defined(linux) || defined(__FreeBSD__) || defined(__NetBSD__)) && \
//    defined(TCP_INFO)
//    struct tcp_info tcpInfo; /* getsockopt(TCP_INFO) for Linux, {Free,Net}BSD */
//    TAILQ_ENTRY(iperf_interval_results) irlistentries;
//    void     *custom_data;
    var bytesTransferred: UInt64 = 0
    var intervalDuration: Double = 0
    var intervalPacketCount: Int32 = 0
    var intervalOutoforderPackets: Int32 = 0
    var intervalCntError: Int32 = 0
    
    var packetCount: Int32 = 0
    var jitter: Double = 0
    var outoforderPackets: Int32 = 0
    var cnt_error: Int32 = 0
    var omitted: Int32 = 0
    
    var intervalRetrans: Int32 = 0
    var intervalSacks: Int32 = 0
    var sndCwnd: Int32 = 0
    var rtt: Int32 = 0
    var rttvar: Int32 = 0
    var pmtu: Int32 = 0
    
    var intervalTimeDiff = TimeInterval(0.0)
    
    init(_ results: iperf_interval_results) {
        var diff = iperf_time()
        var time1Pointer: UnsafeMutablePointer<iperf_time>?
        var time2Pointer: UnsafeMutablePointer<iperf_time>?
        
        var timeConv1 = results.interval_end_time
        withUnsafeMutablePointer(to: &timeConv1) { pointer in
            time1Pointer = pointer
        }
        var timeConv2 = results.interval_start_time
        withUnsafeMutablePointer(to: &timeConv2) { pointer in
            time2Pointer = pointer
        }
        
        iperf_time_diff(time1Pointer, time2Pointer, &diff)
        intervalTimeDiff = Double(diff.secs) + Double(diff.usecs)*1e-6
        
        bytesTransferred = results.bytes_transferred
        intervalDuration = Double(results.interval_duration)
        
        // MARK: UDP only results
        intervalPacketCount = results.interval_packet_count
        intervalOutoforderPackets = results.interval_outoforder_packets
        intervalCntError = results.interval_cnt_error
        packetCount = results.packet_count
        jitter = results.jitter
        outoforderPackets = results.outoforder_packets
        cnt_error = results.cnt_error
        
        omitted = results.omitted
        
        intervalRetrans = results.interval_retrans
        intervalSacks = results.interval_sacks
        sndCwnd = results.snd_cwnd
        rtt = results.rtt
        rttvar = results.rttvar
        pmtu = results.pmtu
    }
    
}

struct IperfIntervalResult: Identifiable {
    var id = UUID()
    var runnerState: IperfRunnerState = .unknown
    
    var streams: [IperfStreamIntervalResult] = []
    
    var totalBytes: UInt64 = 0
    var totalPackets: Int32 = 0
    var totalLostPackets: Int32 = 0
    var averageJitter: Double = 0.0
    var duration: TimeInterval = 0.0
    var state: IperfState = .UNKNOWN
    var debugDescription: String = ""
    
    var throughput = IperfThroughput.init(bytesPerSecond: 0.0)
    var hasError: Bool {
        state.rawValue < 0 || error != .IENONE
    }
    var error: IperfError = .IENONE
    
    mutating func evaulate() {
//        var sum_jitter: Double = 0.0
        for s in streams {
            totalBytes += s.bytesTransferred
//            totalPackets += s.intervalPacketCount
//            totalLostPackets += s.intervalCntError
//            sum_jitter += s.jitter
        }
        if let first = streams.first {
            duration = first.intervalDuration
//            averageJitter = sum_jitter / Double(streams.count)
            throughput = IperfThroughput(bytes: totalBytes, seconds: first.intervalDuration)
        }
    }
}
