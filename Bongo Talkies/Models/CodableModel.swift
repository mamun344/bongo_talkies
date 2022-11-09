

import Foundation

protocol CodableModel: Codable {
    static func fromJSON(_ jsonData: Data?)->Self?
    static func arrayFromJSON(_ jsonData: Data?)->[Self]?
}



extension CodableModel {
    
    public func toJSON()->Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            debugPrint("JSON Decode error: ", error.localizedDescription)
        }
        
        return nil
    }
    
   static public func fromJSON(_ jsonData: Data?)->Self? {
        guard let jsonData = jsonData else { return nil }

        do {
           return try JSONDecoder().decode(Self.self, from: jsonData)
        } catch {
            debugPrint("JSON Decode error: ", error.localizedDescription)
        }
        return nil
    }
    
    
    static public func arrayFromJSON(_ jsonData: Data?)->[Self]? {
         guard let jsonData = jsonData else { return nil }

         do {
            return try JSONDecoder().decode([Self].self, from: jsonData)
            
         } catch {
             debugPrint("JSON Decode error: ", error.localizedDescription)
         }
         return nil
     }
}

extension Array where Element : CodableModel {

    func toJSON()->Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            debugPrint("JSON Decode error: ", error.localizedDescription)
        }
        
        return nil
    }
}

