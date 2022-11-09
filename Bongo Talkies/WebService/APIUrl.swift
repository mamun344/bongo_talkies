
import Foundation


enum ImageQuality : String, CustomStringConvertible {
    case original
    case w500
    
    var description: String { self.rawValue }
}


extension APIUrl {
    private enum Scheme {
        static let movie    = "https"
        static let image    = "https"
    }
    
    private enum Host {
        static let movie    = "api.themoviedb.org"
        static let image    = "image.tmdb.org"
    }
    
    
    private enum Version {
        static let movie    = "3"
    }
  
    private enum Path {
        static let movie    = "movie"
        static let image    = "t/p"
    }
    
    
    static var fullMoviePath: URLComponents {
        var components = URLComponents()
        components.scheme = Scheme.movie
        components.host = Host.movie
        components.path = "/" + Version.movie + "/" + Path.movie
        return components
    }
    
    static var fullImagePath: URLComponents {
        var components = URLComponents()
        components.scheme = Scheme.image
        components.host = Host.image
        components.path = "/" + Path.image
        return components
    }
}


extension APIUrl {
    private static let topMoviesEndPoint = "top_rated"
}



struct APIUrl {
    
    static func topMoviesURL(page: Int)->String {
        var components = fullMoviePath
        components.path.append("/" + topMoviesEndPoint)
        
        var items = [URLQueryItem]()
        items.append(.init(name: "api_key", value: APIConstant.APIKey))
        items.append(.init(name: "language", value: APIConstant.APILang))
        items.append(.init(name: "page", value: page.description))
        components.queryItems = items
        
        return components.string ?? ""
    }
    
    static func movieDetailsURL(id: Int)->String {
        var components = fullMoviePath
        components.path.append("/" + id.description)
        
        var items = [URLQueryItem]()
        items.append(.init(name: "api_key", value: APIConstant.APIKey))
        items.append(.init(name: "language", value: APIConstant.APILang))
        components.queryItems = items
        
        return components.string ?? ""
    }
    
    static func moviePosterURL(quality: ImageQuality, path: String)->String {
        var components = fullImagePath
        components.path.append("/" + quality.description + path)
        return components.string ?? ""
    } 
}








