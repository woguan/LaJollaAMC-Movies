//
//  SourceDecoder.swift
//  Theater-Movies
//
//  Created by Guan Wong on 1/12/17.
//  Copyright © 2017 Wong. All rights reserved.
//

import Foundation

func retrieveImageURL (strings: [String]) -> [String]{
    
    var result = [String]()
    
    for str in strings{
        let lowerbound = str.range(of: "\"image\" content=\"")?.upperBound
        let upperbound = str.range(of: ".jpg")?.lowerBound
        result += [str.substring(with: lowerbound! ..< upperbound!) + ".jpg"]
    }
    
    
    return result
}

func retrieveDescription (strings: [String]) -> [String]{
    var result = [String]()
    
    for str in strings{
        let lowerbound = str.range(of: "description\" content=\"")?.upperBound
        let first = str.substring(from: lowerbound!)
        let upperbound = first.range(of: "/>")?.lowerBound
        var final = first.substring(to: upperbound!)
        
        while final[final.index(before: final.endIndex)] != "."{
            
            if final.characters.count == 1 {
                final = "No description found."
                break
            }
            final.remove(at: final.index(before: final.endIndex))
        }
        
        
        result += [final]
    }
    
    
    return result
    
}

func retrieveTitle (strings:[String]) -> [String]{
    
    var result = [String]()
    
    for str in strings{
        let lowerbound = str.range(of: "name\" content=\"")?.upperBound
        let first = str.substring(from: lowerbound!)
        let upperbound = first.range(of: "/>")?.lowerBound
        var final = first.substring(to: upperbound!)
        
        while final[final.index(before: final.endIndex)] != "\""{
            
            if final.characters.count == 1 {
                final = "No description found."
                break
            }
            final.remove(at: final.index(before: final.endIndex))
        }
        
        if final.characters.count > 1 && final[final.index(before: final.endIndex)] == "\""{
            final.remove(at: final.index(before: final.endIndex))
        }
        
        result += [final]
    }
    
    
    return result
    
}

