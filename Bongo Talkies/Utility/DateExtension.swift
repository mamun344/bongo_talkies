
import Foundation


extension Date {
    
    func convertToString(format: String, local: Bool)->String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if !local {
            let zone = NSTimeZone(name: "UTC")! as TimeZone
            dateFormatter.timeZone = zone
        }
        
        return dateFormatter.string(from: self)
    }
    
    func convertToShortTimeString(local: Bool)->String? {
        var dateString : String!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        if !local {
            let zone = NSTimeZone(name: "UTC")! as TimeZone
            
            dateFormatter.timeZone = zone
        }
        
        dateString = dateFormatter.string(from: self as Date)
        
        
        let times = dateString.components(separatedBy: ":")
        
        if times.count != 2 {
            return nil
        }
        
        let mins = times[1]
        
        if mins.count > 2 {
            return dateString
        }
        
        var hour = times[0]
        let hourInt = Int(hour)!
        var ampm = "AM"
        
        if hourInt >= 12 {
            ampm = "PM"
        }
        
        if hourInt > 12{
            hour = "\(hourInt % 12)"
        }
        
        return hour + ":" + mins + " " + ampm
    }
}
