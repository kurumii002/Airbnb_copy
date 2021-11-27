import UIKit
import FirebaseAuth
import FirebaseStorage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imagePrfile: UIImageView!
    @IBOutlet weak var btnOpenImage: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    
    //para usar la camara/galeria
    var imagePicker = UIImagePickerController()
    
    var imagePathName: URL? = nil
    
    let storage = Storage.storage()
    
    var imageURLFirebase: URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getUser()
    }

    func setUpView(){
        btnOpenImage.setTitle("", for: .normal)
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        if imagePathName == nil {
            upsertProfile(url: imageURLFirebase)
        }else{
            uploadPhoto()
        }
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //este boton debe mostrar 2 opciones para abrir la camara o la galeria
    @IBAction func onClickNewImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let openCamera = UIAlertAction(title: "Cámara", style: .default, handler: nil)
        let openGallery = UIAlertAction(title: "Galería", style: .default) { _ in
            self.openGallery()
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        //agregar las acciones a la alerta
        alert.addAction(openCamera)
        alert.addAction(openGallery)
        alert.addAction(cancel)
        
        //para que se meustre
        present(alert, animated: true, completion: nil)
    }
    
    func openGallery(){
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagePrfile.image = image
        }
    
        imagePathName = (info[UIImagePickerController.InfoKey.imageURL] as? URL)!
        
        //se debe cerrar el album despues de escoger una foto
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func getUser(){
        if let user = Auth.auth().currentUser{
            txtEmail.text = user.email
            
            if let name = user.displayName{
                txtFullname.text = name
            }
            
            if let profile = user.photoURL{
                imageURLFirebase = profile
                setImageFromURL(url: profile, image: imagePrfile)
            }
        }
    }
    
    func uploadPhoto(){
        //obtener la imagen de la galeria y enviarlo a firebase
        let fileExtension = imagePathName!.pathExtension
        let fileName = "image\(Int.random(in: 1...10000)).\(fileExtension)"
        
        let storageRef = storage.reference()
        let profileRef = storageRef.child("profile").child(fileName)
        
        profileRef.putFile(from: imagePathName!, metadata: nil){
            metadata, error in
            
            if let error = error {
                print("Error!!! \(error.localizedDescription)")
            }else{
                profileRef.downloadURL{ (url, error) in
                    
                    //retorna la URL de la foto
                    print(String(describing: url!))
                    //sube la foto
                    self.upsertProfile(url: url!)
                }
            }
        }
    }
    
    func upsertProfile(url: URL?){
        let name = txtFullname.text
        
        //actualizar los datos dle perfil
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.photoURL = url
        
        changeRequest?.commitChanges{ error in
            
            if let error = error {
                print("Error UPSERT: \(error.localizedDescription)")
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
