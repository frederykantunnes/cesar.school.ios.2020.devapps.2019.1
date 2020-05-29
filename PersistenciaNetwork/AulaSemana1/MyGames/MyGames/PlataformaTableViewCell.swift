//
//  PlataformaTableViewCell.swift
//  MyGames
//
//  Created by Frederyk Antunnes on 28/05/20.
//  Copyright © 2020 Douglas Frari. All rights reserved.
//

import UIKit

class PlataformaTableViewCell: UITableViewCell {

    @IBOutlet weak var ivConsole: UIImageView!
    @IBOutlet weak var tfNome: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with console: Console) {
        tfNome.text = console.name ?? ""
        if let image = console.capa as? UIImage {
            ivConsole.image = image
        } else {
            ivConsole.image = UIImage(named: "noCover")
        }
    }

}
