//
//  DateExt.swift
//  JosephCodingBrandi
//
//  Created by Joseph_iMac on 2020/12/30.
//

import Foundation

extension Date {
    func getDateType(_ strTime: String?) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

        let date = formatter.date(from: strTime ?? "")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        var retTime: String? = nil
        if let date = date {
            retTime = dateFormatter.string(from: date)
        }
        return retTime
    }
}
