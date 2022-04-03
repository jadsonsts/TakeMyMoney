//
//  PaymentTypeCollectionViewCell.swift
//  TakeMyMoney
//
//  Created by Jadson on 31/03/22.
//

import UIKit

class PaymentTypeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var typeName: UILabel!
    
    func updateView(paymentType: PaymentMethods) {
        typeName.text = paymentType.description()
    }
    
}
