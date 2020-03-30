//
//  MovieDetail.swift
//  TMDB App
//
//  Created by Osvaldo González on 29/03/20.
//  Copyright © 2020 Osvaldo Gonzalez. All rights reserved.
//

import Foundation

//clase para crear el modelo del detalle de peliculas, para los datos faltantes
class MovieDetail: Decodable {
    
    let overview: String!
    let backdrop_path: String!
    let genres: [String]!
    let runtime: Int!
    
    init(overview: String, backdrop_path: String, genres: [String], runtime: Int){
   
        self.overview = overview
        self.backdrop_path = backdrop_path
        self.genres = genres
        self.runtime = runtime
    }
}
