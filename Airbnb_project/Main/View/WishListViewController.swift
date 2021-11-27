import UIKit
import FirebaseFirestore
import SkeletonView

class WishListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var placesOfWish = [Wish]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getWishList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isSkeletonable = true
        //tableView.showSkeleton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //tableView.stopSkeletonAnimation()
        //tableView.hideSkeleton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //tableView.stopSkeletonAnimation()
        //tableView.hideSkeleton()
    }
    
    func setUp(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getWishList(){
        db.collection("wishlist").getDocuments(){
            querySnapshot, err in
            
            if let err = err {
                print(err.localizedDescription)
            }else{
                self.placesOfWish.removeAll() //para rellenar de nuevo el array
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let documentId = document.documentID
                    let name = data["name"] as? String
                    let photo = data["photo"] as? String
                    let rating = data["rating"] as? String
                    let userRatingsTotal = data["userRatingsTotal"] as? String
                    let address = data["address"] as? String
                    let favorite = Wish(documentId: documentId, name: name!, address: address!, rating: rating!, userRatingsTotal: userRatingsTotal!, photo: photo!)
                    
                    self.placesOfWish.append(favorite)
                }
                //self.tableView.stopSkeletonAnimation()
                //self.view.hideSkeleton()
                self.tableView.reloadData()
            }
        }
    }
    
    func resizeImage(name: String, for size: CGSize) -> UIImage {
        let image = UIImage(named: name)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { (context) in
            image?.draw(in: CGRect(origin: .zero, size: size))
            
        }
    }
}

extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /*func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }*/
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cell"
    }
    
    //numero de filas de la tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return placesOfWish.count
    }
    
    //controla el contenida de la celda de una fila
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let object = placesOfWish[indexPath.section]
        
        cell.textLabel?.text = object.name
        cell.detailTextLabel?.text = object.address
        
        //estilos de la imagen
        cell.imageView?.layer.cornerRadius = 8.0
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.contentMode = .scaleAspectFit
        
        //se setean las imágenes
        setUpImage(photo: object.photo, image: cell.imageView!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        return headerView
    }
    
    //este evento capta el click de cada fila
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //se debe obtener el ide de la fila y pasarle a Firestore
        let object = placesOfWish[indexPath.section]
                
        let alert = UIAlertController(title: "Eliminar", message: "Seguro que desea eliminar?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Sí", style: .default) {_ in
            self.db.collection("wishlist").document(object.documentId).delete(){
                err in
                if let err = err {
                    print(err.localizedDescription)
                }else{
                    self.getWishList()
                }
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
