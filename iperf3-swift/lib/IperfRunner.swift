//
//  IperfRunner.swift
//  iperf3-swift
//
//  Created by Igor Kim on 27.10.20.
//

import Foundation

class IperfRunner {
    private var configuration: IperfConfiguration = IperfConfiguration()
    private var callbackFunction: (_ status: IperfIntervalResult) -> Void = {result in }
    private var observer: NSObjectProtocol? = nil
    private var test: UnsafeMutablePointer<iperf_test>? = nil
    private var state: IperfRunnerState = .ready {
        willSet {
            callbackFunction(IperfIntervalResult(runnerState: newValue))
        }
    }
    
    // MARK: Initialisers
    init() { }
    
    init(with configuration: IperfConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: Callbacks
    private let reporterCallback: @convention(c) (UnsafeMutablePointer<iperf_test>?) -> Void = { refTest in
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(IperfNotificationName.status), object: refTest)
        }
    }
    
    private func reporterNotificationCallback(notification: Notification) {
        if state != .running {
            return
        }
        guard let pointer = notification.object as? UnsafeMutablePointer<iperf_test> else {
            return
        }
        
        let runningTest = pointer.pointee
        var result = IperfIntervalResult()
        result.debugDescription = "OK"
        result.state = IperfState(rawValue: runningTest.state) ?? .UNKNOWN
        
        if configuration.role == .server && result.state == .IPERF_DONE {
            return
        }
        
        guard var stream: UnsafeMutablePointer<iperf_stream> = runningTest.streams.slh_first else {
            return
        }
        while true {
            let intervalResultsP: UnsafeMutablePointer<iperf_interval_results>? = extract_iperf_interval_results(stream)
            if let intervalResults = intervalResultsP?.pointee {
                result.streams.append(IperfStreamIntervalResult(intervalResults))
            }
            if stream.pointee.streams.sle_next == nil {
                break
            }
            stream = stream.pointee.streams.sle_next
        }
        
        // Calculate sum/average over streams
        result.evaulate()
        
        callbackFunction(result)
    }
    
    // MARK: Private methods
    private func applyConfiguration() {
        var addr: UnsafePointer<Int8>? = nil
        if let address = configuration.address, !address.isEmpty {
            addr = NSString(string: address).utf8String
        }
        
        // Server/Client
        iperf_set_test_role(test, configuration.role.rawValue)
        iperf_set_test_server_port(test, Int32(configuration.port))
        
        if let reporterInterval = configuration.reporterInterval {
            iperf_set_test_reporter_interval(test, Double(reporterInterval))
            iperf_set_test_stats_interval(test, Double(reporterInterval))
        }
        
        if configuration.role == .server {
            if let addr = addr {
                iperf_set_test_bind_address(test, addr)
            }
        }
        
        if configuration.role == .client {
            set_protocol(test, configuration.prot.iperfConfigValue)
            iperf_set_test_reverse(test, configuration.reverse.rawValue)
            
            var blksize: Int32 = 0
            if configuration.prot == .tcp {
                blksize = DEFAULT_TCP_BLKSIZE
                iperf_set_test_num_streams(test, Int32(configuration.numStreams))
            } else if configuration.prot == .udp {
                iperf_set_test_rate(test, UInt64(configuration.rate))
            } else if configuration.prot == .sctp {
                blksize = DEFAULT_SCTP_BLKSIZE
            }
            iperf_set_test_blksize(test, blksize)
            
            if let addr = addr {
                iperf_set_test_server_hostname(test, addr)
            }
            if let duration = configuration.duration {
                iperf_set_test_duration(test, Int32(duration))
            }
            if let timeout = configuration.timeout {
                iperf_set_test_connect_timeout(test, Int32(timeout) * 1000)
            }
            if let tos = configuration.tos {
                iperf_set_test_tos(test, Int32(tos))
            }
        }
    }
    
    private func startIperfProcess() {
        DispatchQueue.global(qos: .background).async {
            defer {
                DispatchQueue.main.async { self.state = .ready }
            }
            
            i_errno = IperfError.IENONE.rawValue
            
            DispatchQueue.main.sync { self.state = .running }
            
            var code: Int32
            if self.configuration.role == .client {
                code = iperf_run_client(self.test)
            } else {
                code = iperf_run_server(self.test)
            }
            if code < 0 || i_errno != IperfError.IENONE.rawValue {
                let error = IperfError.init(rawValue: i_errno) ?? .UNKNOWN
                self.callbackFunction(IperfIntervalResult(
                        debugDescription:
                            (self.configuration.role == .client ? "iperf_run_client" : "iperf_run_server")
                            + "failed: \(error.debugDescription)",
                        error: error)
                )
            }
        }
    }
    
    // MARK: Public methods
    func start(with configuration: IperfConfiguration, _ callback: @escaping (_ status: IperfIntervalResult) -> Void) {
        self.configuration = configuration
        self.start(callback)
    }
    
    func start(_ callback: @escaping (_ result: IperfIntervalResult) -> Void) {
        signal(SIGPIPE, SIG_IGN)
        callbackFunction = callback
        state = .initialising
        
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer)
        }
        
        stop()
        test = iperf_new_test()
        guard let testPointer = test else {
            callback(IperfIntervalResult(
                        state: .INIT_ERROR,
                        debugDescription: "iperf_new_test failed")
            )
            return
        }
        
        let code = iperf_defaults(test)
        if code < 0 {
            callback(IperfIntervalResult(
                        state: .INIT_ERROR,
                        debugDescription: "iperf_defaults failed with code \(code)")
            )
            return
        }

        applyConfiguration()
        
        // Cofingure callbacks and notifications
        testPointer.pointee.reporter_callback = reporterCallback
        observer = NotificationCenter.default.addObserver(
            forName: Notification.Name(IperfNotificationName.status), object: nil, queue: nil, using: reporterNotificationCallback
        )
        
        startIperfProcess()
    }
    
    func stop() {
        guard let pointer = test else {
            return
        }
        if pointer.pointee.state != IPERF_DONE {
            pointer.pointee.done = 1
            if configuration.role == .server {
                shutdown(pointer.pointee.listener, SHUT_RDWR)
                close(pointer.pointee.listener)
            }
        }
    }
}
