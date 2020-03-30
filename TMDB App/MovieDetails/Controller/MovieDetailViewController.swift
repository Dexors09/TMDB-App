//
//  MovieDetailViewController.swift
//  TMDB App
//
//  Created by Osvaldo González on 29/03/20.
//  Copyright © 2020 Osvaldo Gonzalez. All rights reserved.
//

import UIKit
import Alamofire

class MovieDetailViewController: UIViewController {

    //outlets de vista
    @IBOutlet var poster: UIImageView!
    @IBOutlet var titleMovie: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var votes: UILabel!
    @IBOutlet var genress: UILabel!
    @IBOutlet var descrip: UILabel!
    
    
    
    //arrays de datos
    var arrayMovieDetail: [MovieDetail] = []
    var genres: [String] = []
    
    //variables que obtienen valor en la vista anterior
    var id = ""
    var titlee = ""
    var release_date = ""
    var vote = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //limpiamos el array
        self.arrayMovieDetail.removeAll()
        
        //se muestra el loader
        self.iniciarLoader(imagen: self.crearImagenGif())
       
        //obtenemos los datos
        getMoviesDetail(id: id)
        
        //generamos un retraso para permitir cargar bien los datos y mostrar en pantalla
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showData()
            self.detenerLoader()
        }
        
    }
    
    //mostramos los datos en pantalla
    func showData(){

        do {
            
            
            //validamos si se pueden obtener estos datos
            if let time = self.arrayMovieDetail[0].runtime,
                let descrip = self.arrayMovieDetail[0].overview,
                let backdrop = self.arrayMovieDetail[0].backdrop_path,
                let gnres = self.arrayMovieDetail[0].genres{
                    
                //imagen
                let url = URL(string: "https://image.tmdb.org/t/p/w500\(backdrop)")
                let image = try Data(contentsOf: url!)
                self.poster.image = UIImage(data: image)
                
                //titulo
                self.titleMovie.text = titlee
                
                //duracion
                self.time.text = "\(time) min"
                //descripcion
                self.descrip.text = descrip
                //votoes
                self.votes.text = vote
                
                //formatear fecha
                 let stringDate = release_date //fecha en estring
                
                 //formato original
                 let  dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd"
                 
                 //nuevo formato
                 let  dateFormatterPrint = DateFormatter()
                 dateFormatterPrint.dateFormat = "dd-MM-yyyy"
                 dateFormatterPrint.locale = Locale(identifier: "es_MX")
                 dateFormatterPrint.dateStyle = .long
                 let date = dateFormatter.date(from: stringDate)
                
                //fecha de estreno
                self.date.text = dateFormatterPrint.string(from: date!)
                
                //separar los generos del array
                let genres = gnres
                var stringGenres = ""
                
                for  (index, genre) in (genres.enumerated()) {
                    if index == 0 {
                        stringGenres += genre
                    }else{
                        stringGenres += ", \(genre)"
                    }
                    
                }
                
                //generos
                self.genress.text = stringGenres
                
            }else{
                
                print("no se pudieron cargar algunos datos")
            }
            
        }
        catch{
            print(error)
        }
    }
    
    //obtenemos el detalle de la pelicula por id (aquí use urlsession porque con alamofire estaba tardando en dar respuesta)
    func getMoviesDetail(id : String){

       let baseURL = "https://api.themoviedb.org/3/movie/\(id)?api_key=634b49e294bd1ff87914e7b9d014daed&language=es-MX"
        
        let objectUrl = URL(string: baseURL)
        let task = URLSession.shared.dataTask(with: objectUrl!) { (data, response, error) in
  
            if error != nil{
                print(error?.localizedDescription ?? "error")
            }else{
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: Any]
  
                    
                    if  let overview = json["overview"] as? String,
                        let backdrop = json["backdrop_path"] as? String,
                        let runtime = json["runtime"] as? Int,
                        let genres = json["genres"] as? [[String: Any]]{

                         for genre in genres {
                              let genre = genre["name"] as? String
                              self.genres.append(genre!)
                         }
                         
                         self.arrayMovieDetail.append(MovieDetail(overview: overview, backdrop_path: backdrop, genres: self.genres, runtime: runtime))
                    
                    }
                    
                } catch  {
                    print("El procesamiento del json tuvo un error")
                }
            }
        }
        task.resume()
        
    }
}
