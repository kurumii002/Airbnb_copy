import UIKit

class CheckDateViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var lblDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
    }
    
    func setUpView(){
        //se especifica el nombre de la imagen que esta en assets
        closeButton.setImage(UIImage(named: "cancel"), for: .normal)
        closeButton.setTitle("", for: .normal)
    }
    

    @IBAction func onClickClose(_ sender: Any) {
        //cuando se presione el boton, que cierre la ventana actual
        dismiss(animated: true, completion: nil)
    }
    
    //cuando se selecciona una fecha, que este se refleje en el label
    @IBAction func onClickCalendar(_ sender: Any) {
        //se define un formato para la fecha obtenida del datePicker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        //se asigna la fecha formateada al label
        lblDate.text = dateFormatter.string(from: datePicker.date)
    }
}
