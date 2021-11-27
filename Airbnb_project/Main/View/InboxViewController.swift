import UIKit

class InboxViewController: UIViewController{
    
    let people=["Seele Vollerei", "Mirai Kuriyama", "Mashu Kyrielight", "Keqing"]
    let messages=["Hola", "Como estas", "Aea", "a"]
    let notifications=["Nuevo mensaje", "Alerta de seguridad", "Reunion"]
    let notiDetail=["Recuerda xd", "alerta", ":'v"]
    
    //se encarga de brindar el indice del click
    @IBOutlet weak var segmentOptions: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        print(segmentOptions.selectedSegmentIndex)
    }
    
    //configuracion del tableView
    func setup(){
        tableView.delegate=self
        tableView.dataSource=self
    }

    //action, cuando se hace click en el segmentController, que refesque la data
    @IBAction func onClickSegment(_ sender: Any) {
        tableView.reloadData()
    }
}

extension InboxViewController: UITableViewDelegate, UITableViewDataSource {
    
    //funcion que controlla el numero de filas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //si se selecciona el primer item del segment, que devuelva la cuenta de personas
        if segmentOptions.selectedSegmentIndex == 0 {
            return people.count
            
        }else{ //si es otro item, que devuelva la cuenta de notificaciones
            return notifications.count
        }
        
    }
    
    //funcion que controlla la celda de un fila
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        //si el segment es el 1er item, setea los datos correspondientes en la celda
        if segmentOptions.selectedSegmentIndex == 0 {
            //setea los textos en los labels
            cell.textLabel?.text=people[indexPath.row] //el nombre de la persona
            cell.detailTextLabel?.text=messages[indexPath.row] //el mensaje de dicha persona
            
        }else{
            cell.textLabel?.text=notifications[indexPath.row] //el titulo de la notificacion
            cell.detailTextLabel?.text=notiDetail[indexPath.row] //el detalle
        }
        
        return cell
    }
}
