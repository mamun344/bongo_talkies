
import UIKit

class APIManager: APIService {
    
    private let session : URLSession
    
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    
    public func fetchTopMovies(page: Int, onComplete: @escaping (Result<MovieList, ResponseError>)->Void){
        
        request(APIUrl.topMoviesURL(page: page), method: .get) { result in
            switch result {
            case .success(let data):
                if let movieList = MovieList.fromJSON(data) {
                    onComplete(.success(movieList))
                }
                else {
                    onComplete(.failure(.jsonParseFailed))
                }
                
            case .failure(let responseError):
                onComplete(.failure(responseError))
            }
        }
    }
    
    
    
    public func fetchMovieDetails(id: Int, onComplete: @escaping ((Result<MovieDetails, ResponseError>)->Void)){
       
        request(APIUrl.movieDetailsURL(id: id), method: .get) { result  in
            switch result {
            case .success(let data):
                if let details = MovieDetails.fromJSON(data) {
                    onComplete(.success(details))
                }
                else {
                    onComplete(.failure(.jsonParseFailed))
                }
                
            case .failure(let responseError):
                onComplete(.failure(responseError))
            }
        }
    }
    
    
    private func request(_ urlString: String,
                         method: RequestMethod,
                         parameters: Any = [:],
                         headers: [String: String] = [:],
                         timeOut: Double = APIConstant.timeOut,
                         onCmpletion: @escaping((Result<Data, ResponseError>)->())) {
        
        guard let url = URL(string: urlString) else {
            onCmpletion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeOut
        request.httpMethod = method.description
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        var jsonData: Data?
        
        if method != .get {
            jsonData = jsonDataFrom(dic: parameters)
            request.httpBody = jsonData
        }
        
        logRequest(url: url, jsonData: jsonData)
        
        do {
            let task = session.dataTask(with: request) { data, response, error in
                self.logResponse(data: data)
                
                let stausCode = (response as? HTTPURLResponse)?.statusCode
                
                if let data, data.count > 0, let stausCode {
                    if stausCode >= 200, stausCode < 300 {
                        onCmpletion(.success(data))
                    }
                    else {
                        onCmpletion(.failure(.invalidHttp(stausCode)))
                    }
                }
                else {
                    onCmpletion(.failure(.noResponse))
                }
            }
            
            task.resume()
        }
        catch let error {
            print("API error")
        }
    }
    
    
    
    
    private func jsonDataFrom(dic: Any)->Data? {
        try? JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
    }
    
    private func jsonFrom(data: Data)->Any? {
        try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
    }
    
    private func logRequest(url: URL, jsonData: Data?){
        #if DEBUG
        print("\nREQUEST ::>>>\n")
        print("URL: ", url)
        
        if let jsonData = jsonData, let reqJson = jsonFrom(data: jsonData) {
            print("\nBody : \n", reqJson)
        }
        #endif
    }
    
    private func logResponse(data: Data?){
        #if DEBUG
        print("\n\n****   RESPONSE   ****\n")
        
        if let data = data {
            if let json = self.jsonFrom(data: data) {
                print("JSON : \n", json)
            }
            else if let responseString = String.init(data: data, encoding: .utf8) {
                print("String : \n", responseString)
            }
            else {
                print("Non formatted data")
            }
        }
        else {
            print("No Data Found")
        }
        
        print("\n-----  =======   -----\n\n")
        #endif
    }
}


