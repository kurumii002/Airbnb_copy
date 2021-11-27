import UIKit
import MapKit
import SkeletonView

class ExplorerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var name: String? = nil
    var address: String? = nil
    var rating: String? = nil
    var userRatingsTotal: String? = nil
    var photo: String? = nil
    
    //var shouldAnimate = true
    
    //instancia dle viewModel
    let venueVModel = VenueViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        setupTable()
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }*/
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //metodo que activa la peticion
    func configure(){
        //hace el llamada a la urlAPI
        venueVModel.getVenues()
    }
    
    //metodo para obtener la data que se guardó en el array
    func bind(){
        venueVModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                //self?.shouldAnimate = false
                self?.tableView.reloadData()
            }
        }
    }
}

extension ExplorerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueVModel.arrayVenues.count
    }
    
    /*func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venueVModel.arrayVenues.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "cellExplorer"
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //se vincula la celda con el archivo tableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellExplorer", for: indexPath) as! ExploreTableViewCell
        
        //se obtiene la data del array de Venues en forma de objeto
        let object = venueVModel.arrayVenues[indexPath.row]
        
        //se setean los datos en cada label
        cell.lblTitle.text = object.name
        cell.lblAddres.text = object.address
        cell.lblRating.text = String(object.rating)
        cell.lblCountRating.text = "(\(object.userRatingsTotal))"
        
        //se setea la imagen
        setUpImage(photo: object.photo, image: cell.exploreImage)
        
        //estilos de la celda
        let cellView = UIView()
        cellView.backgroundColor = UIColor.systemBackground
        cell.selectedBackgroundView = cellView
        
        return cell
    }
    
    //cuando se haga click en una fila esta vaya a una pantlla de detalle
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = venueVModel.arrayVenues[indexPath.row]
        
        self.name = object.name
        self.address = object.address
        self.rating = String(object.rating)
        self.userRatingsTotal = "(\(object.userRatingsTotal))"
        self.photo = object.photo
        
        //se define el segue (otra vista)
        self.performSegue(withIdentifier: "exploreSegue", sender: self)
    }
    
    //preapra lso datos para la otra vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exploreSegue"  {
            if let destVC = segue.destination as? ExploreDetailViewController {
                destVC.name = self.name
                destVC.rating = self.rating
                destVC.address = self.address
                destVC.userRatingsTotal = self.userRatingsTotal
                destVC.photo = self.photo
            }
        }
    }
}
