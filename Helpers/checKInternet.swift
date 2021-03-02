//
//  checKInternet.swift
//  Shopping
//
//  Created by ahmed on 23/01/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import SystemConfiguration
public class Reachability {
    class func hasConnection()-> Bool {
        var zeroAdress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr:0), sin_zero: (0,0,0,0,0,0,0,0))
        zeroAdress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAdress))
        zeroAdress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachibility = withUnsafePointer(to: &zeroAdress,{
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1,{ zeroSockAdress in
                
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAdress)
            })
        })
        var flags : SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachibility!, &flags) == false {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return(isReachable && !needConnection)
    }
}

