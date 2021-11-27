import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblFullname: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    //se recupera al usuario de sesion y se obtiene sus datos
    func setUpView(){
        //dar a la img un borde de colr negro de 1px
        imgProfile.layer.borderWidth = 1
        //bordes redondeados
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2
        
        let user = Auth.auth().currentUser
        
        if let user = user{
            lblEmail.text = user.email
            
            if let name = user.displayName{
                lblFullname.text = name
            }
            
            if let imageUrl = user.photoURL{
                setImageFromURL(url: imageUrl, image: imgProfile)
            }
        }
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        //se borra la sesion del usuario actual
        let auth = Auth.auth()
        
        do{
            try auth.signOut()
            
            //manda la vista inicial
            dismiss(animated: true)
            
        }catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    

}
