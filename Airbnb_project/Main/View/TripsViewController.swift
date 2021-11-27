import UIKit
import MapKit
import CoreLocation

class TripsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    let venueVModel = VenueViewModel()
    
    //para poder saber la ubicacion de un usuario se debe pedir permiso (en info.plist) y luego obtener su longitud y latitud
    
    var locationManager: CLLocationManager?
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        configure()
        bind()
        setUpView()
    }
    
    //se valida al usuario que brindó el permiso
    func requestLocation(){
        mapView.delegate = self
        
        guard CLLocationManager.locationServicesEnabled() else {return}
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    func configure(){
        //hace el llamada a la urlAPI
        venueVModel.getVenues()
    }
    
    func bind(){
        venueVModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.createAnnotation()
            }
        }
    }
    
    func setUpView(){
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(getLocationOnLongClick(longGesture:)))
        mapView.addGestureRecognizer(longGesture)
        
        contentView.layer.cornerRadius=8
        contentView.layer.masksToBounds=true
        contentView.isHidden=true
    }
    
    func setAnnotation(coordinates: CLLocationCoordinate2D, title: String, subtitle: String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = title
        annotation.subtitle = subtitle
        
        mapView.addAnnotation(annotation) //agrega la anotacion al mapa
    }
    
    //obtener la ubicacion de un lugar al dar un click largo en el mapa
    @objc func getLocationOnLongClick(longGesture: UIGestureRecognizer){
        let touchPoint = longGesture.location(in: mapView)
        
        //coordenadas del lugar donde se seleccionó
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        //crear annotation
        setAnnotation(coordinates: coordinates, title: "Get Point", subtitle: "\(coordinates.latitude) \(coordinates.longitude)")
    }
}

//extension del locationManager
extension TripsViewController: CLLocationManagerDelegate {
    //para poder centrar la ubicacion en el mapa se debe obtener la longitud y latitud
    
    //funcion que brinda las coordenadas el usuario en timepo real
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else {return} //se solicita la ultima ubicacion
        
        print(userLocation.coordinate.latitude)
        print(userLocation.coordinate.longitude)
        
        //centrar el mapa en la ubicacion del usuario
        let localArea: CLLocationCoordinate2D = manager.location!.coordinate
        
        //span: distancia entre el mapa y el usuario
        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
        
        let region = MKCoordinateRegion(center: localArea, span: span)
        mapView.setRegion(region, animated: true) //asignar la region al mapa
    }
    
    //crear un marcador en el mapa (annotation)
    func createAnnotation(){
        let places = venueVModel.arrayVenues
        
        for place in places{
            let coordinates = CLLocationCoordinate2D(latitude: Double(place.latitude)!, longitude: Double(place.longitude)!)
            
            setAnnotation(coordinates: coordinates, title: place.name, subtitle: "\(place.rating)")
        }
        
    }
}

extension TripsViewController: MKMapViewDelegate{
    //la funcion didSelect captura el clikc de los annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.contentView.isHidden=false
        
        //obtener los datos del annotation
        self.lblRating.text = (view.annotation?.subtitle)!
        self.lblName.text = (view.annotation?.title)!
    }
}

