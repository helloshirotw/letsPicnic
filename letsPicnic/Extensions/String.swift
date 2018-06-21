//
//  String.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/21.
//  Copyright © 2018年 gary chen. All rights reserved.
//

import UIKit

extension String {
    
    func isOpenTime() -> Bool {
        
        let calender = Calendar.current
        let now = Date()
        
        let beginTimeHour = self.getSubstring(startOffset: 0, endOffset: 1)
        let beginTimeMinute = self.getSubstring(startOffset: 3, endOffset: 4)
        
        var closeTimeHour = self.getSubstring(startOffset: 6, endOffset: 7)
        var closeTimeMinute = self.getSubstring(startOffset: 9, endOffset: 10)
        
        let beginTime = calender.date(bySettingHour: Int(beginTimeHour)!, minute: Int(beginTimeMinute)!, second: 0, of: now)!
        if closeTimeHour == "24" {
            closeTimeHour = "23"
            closeTimeMinute = "59"
        }
        let closeTime = calender.date(bySettingHour: Int(closeTimeHour)!, minute: Int(closeTimeMinute)!, second: 0, of: now)!
        
        if now >= beginTime && now <= closeTime {
            return true
        } else {
            return false
        }
    }
    
    func getSubstring(startOffset: Int, endOffset: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: startOffset)
        let endIndex = self.index(self.startIndex, offsetBy: endOffset)
        return String(self[startIndex...endIndex])
    }
}
