//
//  APIService.swift
//  PodcastsDemo
//
//  Created by Gary Chen on 25/5/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import Foundation

class APIService {
    
    
    //singleton
    static let shared = APIService()
    
    func fetchPark(offset: Int,completionHandler: @escaping ([TaipeiPark]) -> ()) {
        
        
        let urlString =
        "https://beta.data.taipei/opendata/datalist/apiAccess?limit=15&offset=\(offset)&id=a132516d-d2f3-4e23-866e-27e616b3855a&rid=8f6fcb24-290b-461d-9d34-72ed1b3f51f0&scope=resourceAquire"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(ParkResult.self, from: data)
                
                completionHandler(jsonData.result.results)
                
            } catch let jsonErr {
                print("Serializing json error: ", jsonErr)
            }
            
            
        }.resume()
        
    }
    
    func fetchPark(completionHandler: @escaping ([TaipeiPark]) -> ()) {
        
        
        let urlString =
        "https://beta.data.taipei/opendata/datalist/apiAccess?id=a132516d-d2f3-4e23-866e-27e616b3855a&rid=8f6fcb24-290b-461d-9d34-72ed1b3f51f0&scope=resourceAquire"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(ParkResult.self, from: data)
                
                completionHandler(jsonData.result.results)
                
            } catch let jsonErr {
                print("Serializing json error: ", jsonErr)
            }
            
            
            }.resume()
        
    }
    
    
    
    func fetchFeature(parkname: String, completionHandler: @escaping ([ParkFeature]) -> ()) {
        
        let urlString = "https://beta.data.taipei/opendata/datalist/apiAccess?q=\(parkname)&rid=bf073841-c734-49bf-a97f-3757a6013812&scope=resourceAquire".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlString!) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(FeatureResult.self, from: data)
                
                completionHandler(jsonData.result.results)
                
            } catch let jsonErr {
                print("Serializing json error: ", jsonErr)
            }
        }.resume()
    }
    
    func fetchFacility(parkname: String, completionHandler: @escaping ([ParkFacility]) -> ()) {
        
        let urlString = "https://beta.data.taipei/opendata/datalist/apiAccess?q=\(parkname)&id=11b63969-a337-4f3e-b61c-954ba9ed9937&rid=97d0cf5c-dc1f-4b5e-8d02-a07e7cc82db7&scope=resourceAquire".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlString!) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode(FacilityResult.self, from: data)
                
                completionHandler(jsonData.result.results)
                
            } catch let jsonErr {
                print("Serializing json error: ", jsonErr)
            }
            }.resume()
    }
    
}



