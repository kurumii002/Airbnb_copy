import Foundation

class VenueViewModel {
    let urlAPI = "https://615ccfdcc29813001773631d.mockapi.io/api/v1/places"
    
    var refreshData = {
        () -> () in
    }
    
    var arrayVenues: [Venues] = [] {
        didSet{
            refreshData()
        }
    }
    
    //metodo que hace la peticion a la URL y la serializacion de los datos segun el modelo
    func getVenues() {
        //en caso la url sea null, el guard terminará la ejecución(return)
        guard let url = URL(string: urlAPI) else { return }
        
        //URLSession -> permite crear una entre la app y el API
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            //se valida que no sea nulo
            guard let dataJSON =  data else { return }
            
            //se realiza la serializacion
            let decoder = JSONDecoder()
            
            do{
                //se asignan los datos, recibe el modelo y de donde viene la data
                self.arrayVenues = try decoder.decode([Venues].self, from: dataJSON)
                
            }catch{
                print(String(describing: error))
            }
            
        }.resume() //indica el fin de la peticion
    }
}
