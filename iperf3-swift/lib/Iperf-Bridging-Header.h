//
//  Iperf-Bridging-Header.h
//  iperf3-swift
//
//  Created by Igor Kim on 27.10.20.
//

#ifndef Iperf_Bridging_Header_h
#define Iperf_Bridging_Header_h

#import "iperf_api.h"
#import "iperf.h"
#import "queue.h"

struct iperf_interval_results* extract_iperf_interval_results(struct iperf_stream* stream) {
    struct iperf_interval_results* interval_results = TAILQ_LAST(&stream->result->interval_results, irlisthead);
    return interval_results;
}

#endif /* Iperf_Bridging_Header_h */
