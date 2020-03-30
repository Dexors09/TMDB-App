
import UIKit
extension UIViewController{

    /**
        Función que inicia el loader
        */
       func iniciarLoader(imagen: UIImageView){
           
           blurEffectView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
           blurEffectView.frame = view.bounds
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           blurEffectView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
           view.addSubview(blurEffectView)
           view.addSubview(imagen)
           someImageViewConstraints(image: imagen)
           //UIApplication.shared.beginIgnoringInteractionEvents()
           
       }
       
       /**
        Función que detiene el loader
        */
       func detenerLoader(){
           
           for v in view.subviews{
               if v.tag == 5000{
                   v.removeFromSuperview()
                   blurEffectView.removeFromSuperview()
                   //UIApplication.shared.endIgnoringInteractionEvents()
               }
           }
       }
       
       /**
        Función que crea un componente UIImageView con gif asignada.
        */
       func crearImagenGif() -> UIImageView {
           let jeremyGif = UIImage.gifImageWithName("loader")
           let imageView = UIImageView(image: jeremyGif)
           imageView.translatesAutoresizingMaskIntoConstraints = false
           
           imageView.tag = 5000
           
           return imageView
       }
       
    func someImageViewConstraints(image: UIImageView) {
           image.widthAnchor.constraint(equalToConstant: 100).isActive = true
           image.heightAnchor.constraint(equalToConstant: 100).isActive = true
           image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 28).isActive = true
       }
}
