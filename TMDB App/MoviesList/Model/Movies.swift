//
//  Movies.swift
//  TMDB App
//
//  Created by Osvaldo González on 27/03/20.
//  Copyright © 2020 Osvaldo Gonzalez. All rights reserved.
//

import Foundation

//clase para crear el modelo de las peliculas
class Movie:  Decodable {
    let id: Int!
    let title: String!
    let poster_path: String!
    let release_date: String!
    let vote_average: Double!
   
    
    init(id: Int, title: String, poster_path: String, release_date: String, vote_average: Double) {
        self.id = id
        self.title = title
        self.poster_path = poster_path
        self.release_date = release_date
        self.vote_average = vote_average
    }
   
}



