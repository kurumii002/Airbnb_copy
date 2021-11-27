import UIKit
import FirebaseFirestore

class ExploreDetailViewController: UIViewController {

    var name: String? = nil
    var address: String? = nil
    var rating: String? = nil
    var userRatingsTotal: String? = nil
    var photo: String? = nil
    
    @IBOutlet weak var ImageBG: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnLiked: UIButton!
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView(){
        lblTitle.text = name!
        lblAddress.text = address!
        
        //establecer la imagen
        setUpImage(photo: photo!, image: ImageBG)
        
        //setear la accion a la imagen
        let actionImage = UITapGestureRecognizer(target: self, action: #selector(self.imageClick))
        ImageBG.addGestureRecognizer(actionImage)
        ImageBG.isUserInteractionEnabled = true
        //btnLiked.setImage(UIImage(named: "heart_line"), for: .normal)
        btnLiked.setTitle("", for: .normal)
    }

    @objc func imageClick(sender: UITapGestureRecognizer){
        dismiss(animated: true)
    }
    
    @IBAction func onClickAddWish(_ sender: Any) {
        btnLiked.setImage(UIImage(named: "heart_fill"), for: .normal)
        
        //cuando se hace click en el boton, se debe agregar el item a la db
        let data: [String: Any] = [
            "name": name!,
            "address": address!,
            "rating": rating!,
            "userRatingsTotal": userRatingsTotal!,
            "photo": photo!
        ]
        
        db.collection("wishlist").addDocument(data: data){
            err in
            if let err = err {
                print("Error \(err.localizedDescription)")
            }else{
                //crear alerta de exito
                let alert = UIAlertController(title: "Felicidades", message: "Se agregó \(self.name!) a tu lista de deseos", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) {_ in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
