
import Foundation

extension Double {
    
    func formatPoints() -> String {
        if self / 1000000000 >= 1.0 {
            return String(format: "%.1f", self / 1000000000) + "B"
        } else if self / 1000000 >= 1.0 {
            return String(format: "%.1f", self / 1000000) + "M"
        } else if self / 1000 >= 1.0 {
            return String(format: "%.1f", self / 1000) + "K"
        } else {
            return String(format: "%.0f", self)
        }
    }
    
    func powerOfByBase(base: Int) -> Double {
        return (Darwin.log(self)/Darwin.log(Double(base))).rounded(.up)
    }
}
