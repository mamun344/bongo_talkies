
import Foundation


enum RequestMethod : String, CustomStringConvertible {
    case get
    case post
    case put
    case delete

    var description: String {
        self.rawValue.uppercased()
    }
}

enum ResponseError : Error, CustomStringConvertible {
    case invalidUrl
    case jsonParseFailed
    case noResponse
    case invalidHttp(Int)
    
    var description: String {
        switch self {
        case .invalidUrl:
            return "Please provide a valid URL"
            
        case .jsonParseFailed:
            return "Failed to parse the response to given type"
            
        case .noResponse:
            return "Failed to get response"
        
        case .invalidHttp(let code):
            return "Request failed with HTTP Status \(code)"
        }
    }
}
