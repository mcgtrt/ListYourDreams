//
//  ItemCell.swift
//  ListYourDreams
//
//  Created by Maciej Marut on 26.01.2017.
//  Copyright © 2017 Maciej Marut. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    //MARK: - Cell outlets
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!

    func configureCell(item: Item) {
        title.text = item.title
        price.text = "\(item.price) zł"
        details.text = item.details
    }
}
