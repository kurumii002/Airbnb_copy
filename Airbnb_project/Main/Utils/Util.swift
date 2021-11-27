import Foundation
import UIKit

extension UIViewController{
    func setUpImage(photo: String, image: UIImageView){
        let urlImage = URL(string: photo)
        
        setImageFromURL(url: urlImage!, image: image)
    }
    
    func setImageFromURL(url: URL, image: UIImageView){
        let data = try? Data(contentsOf: url)
        
        if let imageData = data{
            image.image = UIImage(data: imageData)
        }
    }
}
