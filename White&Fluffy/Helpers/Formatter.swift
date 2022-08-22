//
//  File.swift
//  White&Fluffy
//
//  Created by Lev on 22.08.2022.
//

import Foundation

struct Formatter {
    static func formatDate(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd-yy HH:mm"
        return  dateFormatter.string(from: date!)
    }
}
