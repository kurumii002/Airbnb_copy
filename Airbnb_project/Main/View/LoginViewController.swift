import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //el viewDidLoad se ejecuta una vez que la vista ya cargó
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //se ejecuta antes de renderizar la vista
    override func viewDidAppear(_ animated: Bool) {
        validateSession()
    }
    
    @IBAction func onClickAction(_ sender: Any) {
        //capturar el texto d elos inputs
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        login(email: email, password: password)
    }
    
    //funcion para registrar un usuario
    func storeUser(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password){
            authResponse, error in
            
            if error == nil{
                //tiene que ir a la vista del home
                self.goHome()
            }
        }
    }
    
    //funcion para realizar el login
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){
            authResponse, error in
            
            if error == nil{
                self.goHome()
            }
        }
    }
    
    func validateSession(){
        if Auth.auth().currentUser != nil{
            //el usuario está en la sesion
            self.goHome()
        }
    }
    
    func goHome(){
        self.performSegue(withIdentifier: "segueLogin", sender: nil)
    }
}

