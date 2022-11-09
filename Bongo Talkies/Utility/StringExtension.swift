
import Foundation
import UIKit

extension String {
    
    func convertToDate(_ format: String, utc: Bool)->Date? {
        let dateFormatter = DateFormatter()
        
        let local = Locale.init(identifier:"en_US_POSIX")
        dateFormatter.locale = local
        dateFormatter.dateFormat = format
        
        if utc {
            let zone = NSTimeZone(name: "UTC")! as TimeZone
            dateFormatter.timeZone = zone
        }
        
        return dateFormatter.date(from: self)
    }
    
    
    func fileJSONData()->Data? {
        guard let pathString = Bundle.main.path(forResource: self, ofType: "json") else {
            print(self + ".json not found")
            return nil
        }
        
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            print("Unable to convert \(self).json to String")
            return nil
        }
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Unable to convert \(self).json to Data")
            return nil
        }
        
        return jsonData
    }
    
}
