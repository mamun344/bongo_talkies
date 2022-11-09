

import Foundation
import SwiftUI


extension NumberFormatter {
    static var decimal: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
}



struct CustomShape: Shape {
    var corner : UIRectCorner
    var radii : CGFloat
    
    func path(in rect : CGRect) -> Path{
        let path = UIBezierPath(
            roundedRect : rect,
            byRoundingCorners: corner,
            cornerRadii: CGSize(
                width: radii, height: radii))
        
        return Path(path.cgPath)
    }
}
