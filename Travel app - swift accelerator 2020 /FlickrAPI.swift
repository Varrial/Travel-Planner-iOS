//
//  FlickrAPI.swift
//  Travel app - swift accelerator 2020 grup 7
//
//  Created by Sonia Becz on 25/01/2023.
//

import UIKit

struct Error {
    var message: String
}

class FlickrAPI {
    
    // https://www.flickr.com/services/apps/create/apply/
    static let apiKey = "4bfada23cf7be386b75bcf03b3586539"  // tmp api key
    
    class func prepareURL(_ params: [String: Any]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest/"
        components.queryItems = [URLQueryItem]()
        
        components.queryItems!.append(URLQueryItem(name: "api_key", value: apiKey))
        components.queryItems!.append(URLQueryItem(name: "extras", value: "url_c"))
        components.queryItems!.append(URLQueryItem(name: "format", value: "json"))
        components.queryItems!.append(URLQueryItem(name: "nojsoncallback", value: "1"))
        components.queryItems!.append(URLQueryItem(name: "content_type", value: "1"))
        components.queryItems!.append(URLQueryItem(name: "tag_mode", value: "all"))
        components.queryItems!.append(URLQueryItem(name: "sort", value: "relevance"))
        components.queryItems!.append(URLQueryItem(name: "is_getty", value: "true"))
        
        for (key, value) in params {
            components.queryItems!.append(URLQueryItem(name: key, value: "\(value)"))
        }
        
        return components.url!
    }
    
    class func searchPhotos(text: String, completionHandler: @escaping ([[String: AnyObject]], Error?) -> Void) {
        var params = [
            "method": "flickr.photos.search",
            "text": text
        ] as [String: Any]
        
        func handleError(_ message: String) {
            completionHandler([[:]], Error(message: message))
        }
        
        let task = URLSession.shared.dataTask(with: prepareURL(params)) { (data, response, error) in
            guard (error == nil) else {
                handleError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            guard let data = data else {
                handleError("No data was returned by the request!")
                return
            }
            
            var parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            } catch {
                handleError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let stat = parsedResult["stat"] as? String, stat == "ok" else {
                handleError("Stat fail '\(parsedResult)'")
                return
            }
            
            guard let photosDict = parsedResult["photos"] as? [String: AnyObject],
                let photosArray = photosDict["photo"] as? [[String: AnyObject]] else
            {
                handleError("Missing key photos or photo")
                return
            }
            completionHandler(photosArray, nil)
        }
        task.resume()
    }
    
    class func getPhotos(_ galleryID: Int, completionHandler: @escaping ([[String: AnyObject]], Error?) -> Void) {
        
        var params = [
            "method": "flickr.galleries.getPhotos",
            "gallery_id": galleryID,
        ] as [String: Any]
        
        func handleError(_ message: String) {
            completionHandler([[:]], Error(message: message))
        }
        
        let task = URLSession.shared.dataTask(with: prepareURL(params)) { (data, response, error) in
            guard (error == nil) else {
                handleError("There was an error with your request: \(String(describing: error))")
                return
            }
            
            guard let data = data else {
                handleError("No data was returned by the request!")
                return
            }
            
            var parsedResult: [String: AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            } catch {
                handleError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            guard let stat = parsedResult["stat"] as? String, stat == "ok" else {
                handleError("Stat fail \(parsedResult)")
                return
            }
            
            guard let photosDict = parsedResult["photos"] as? [String: AnyObject],
                let photosArray = photosDict["photo"] as? [[String: AnyObject]] else
            {
                handleError("Missing key photos or photo")
                return
            }
            completionHandler(photosArray, nil)
        }
        task.resume()
    }
}

