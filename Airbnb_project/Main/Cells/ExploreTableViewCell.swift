import UIKit

class ExploreTableViewCell: UITableViewCell {

    @IBOutlet weak var exploreImage: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblCountRating: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAddres: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        //esta funcion es similar al viewDidLoad
        super.awakeFromNib()
        
        //estilos de la foto
        exploreImage.layer.cornerRadius = 15
        exploreImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
