//
//  ActivityModel.swift
//  ActivityTracker
//
//  Created by macintosh on 12/21/18.
//  Copyright © 2018 macintosh. All rights reserved.
//

import Foundation
struct Activities {
    let id:Int64
    let title:String
    let url:NSData
    let description:String
    let date:String
    let timeHH:Int16
    let timeMM:Int16
    let timeSS:Int16
    let totalTime:Int64
    let isRunning:Bool
}
