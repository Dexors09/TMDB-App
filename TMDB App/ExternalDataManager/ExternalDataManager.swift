//
//  ExternalDataManager.swift
//  ProyectoMVCEjemplo
//
//  Created by Osvaldo González on 14/02/20.
//  Copyright © 2020 Osvaldo Gonzalez. All rights reserved.
//
//clase en la que se hace el consumo de servicios API URL (usando alomofire) para traer los datos necesarios (en este caso ciudades)
//obtenidos en json y parseados para gaurdar en un array para usar en otras clases

import Foundation
import Alamofire

protocol ExternalDataSource {
    func getDataFromServer(datos: [Movie])
}

class ExternalDataManager {
    //url de la api
    let urlMoviesList = "https://api.themoviedb.org/3/movie/now_playing?api_key=634b49e294bd1ff87914e7b9d014daed&language=es-MX&page=1"
    
   
    var arrayMovies = [Movie]()
    
    //propiedad del protocolo
    let delegate: ExternalDataSource
   // var movie: Movies?
    
    init(delegate: ExternalDataSource) {
        self.delegate = delegate
    }
    
    //servicio para traer datos de las peliculas en cartelera
    func getMovies(){
    
       
       AF.request(urlMoviesList).responseJSON{ response in
            
            if let statusCode = response.response?.statusCode{
               
                if statusCode == 200{
                    
                    do {
                        if let parsedData = try JSONSerialization.jsonObject(with: response.data!) as? [String:Any]{
                        
                            let results = parsedData["results"] as? [[String: Any]]
                            for result in results! {
                                 if let id = result["id"] as? Int,
                                    let title = result["title"] as? String,
                                    let poster = result["poster_path"] as? String,
                                    let date = result["release_date"] as? String,
                                    let votes = result["vote_average"] as? Double{
                                    
                                    self.arrayMovies.append(Movie(id: id, title: title, poster_path: poster, release_date: date, vote_average: votes))
                                }
                                
                            }
                        }
                    } catch  {
                        print("No se ha podido parsear el  JSON")
                    }
                    //pasamos los datos al delegado para usar en otras clases
                    self.delegate.getDataFromServer(datos: self.arrayMovies)
                }
            }
        }
    }
    
}
