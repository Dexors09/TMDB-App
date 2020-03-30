//
//  ViewController.swift
//  TMDB App
//
//  Created by Osvaldo González on 27/03/20.
//  Copyright © 2020 Osvaldo Gonzalez. All rights reserved.
//

import UIKit

var blurEffectView : UIView!

class MoviesViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //se muestra el loader
        self.iniciarLoader(imagen: self.crearImagenGif())
        //hacer la llamada al server
        let conexion = ExternalDataManager(delegate: self)
        conexion.getMovies()
        
       
        
    }
}

//metodos de la collectionView para mostrar los datos
extension MoviesViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return self.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = self.movies[indexPath.row]
        
        do {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path!)")
            let data = try Data(contentsOf: url!)
            cell.movieImage.image = UIImage(data: data)
            cell.movieTitle.text = movie.title
            
            //formatear fecha
            let stringDate = movie.release_date! //fecha en estring
           
            //formato original
            let  dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            //nuevo formato
            let  dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd-MM-yyyy"
            dateFormatterPrint.locale = Locale(identifier: "es_MX")
            dateFormatterPrint.dateStyle = .medium
            let date = dateFormatter.date(from: stringDate)
          
            cell.movieDate.text = dateFormatterPrint.string(from: date!)
            cell.movieVote.text = String(movie.vote_average)
        }
        catch{
            print(error)
        }

        return cell
    }
    
    //usamos segue para pasar parametros a la siguiente pantalla ya que se pueden obtener en la primera llamada a la api
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMovieDetail" {
            let cell = sender as! UICollectionViewCell
            let VC = segue.destination as! MovieDetailViewController
            if let indexPath = self.collectionView!.indexPath(for: cell){
                let  movie = self.movies[indexPath.row]
                
                //parametros para usar en la siguiente vista
                VC.id = String(movie.id)
                VC.release_date = movie.release_date
                VC.titlee = movie.title
                VC.vote = String(movie.vote_average)
               
            }
        }
    }
}

//usamos esta extension para hacer uso de los metodos del ExternalDataManager
extension MoviesViewController: ExternalDataSource{
    func getDataFromServer(datos: [Movie]) {
        self.movies = datos
       DispatchQueue.main.async {
            self.collectionView.reloadData()
            //se oculta el loader
             self.detenerLoader()
        }
    }
}

