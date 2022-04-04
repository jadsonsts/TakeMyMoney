//
//  PaymentTableVC.swift
//  TakeMyMoney
//
//  Created by Jadson on 3/04/22.
//

import UIKit

class PaymentTableVC: UITableViewController {
    
    @IBOutlet weak var cardHolderLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var payPalUserLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    var cardPayment: CardPayment? {
        didSet {
            cardHolderLabel.text = cardPayment?.cardHolderName
            cardNumberLabel.text = "\(String(describing: cardPayment?.cardNumber))"
            payPalUserLabel.text = ""
            
        }
    }
    
    var payPal: PayPalPayment? {
        didSet {
            cardHolderLabel.text = ""
            cardNumberLabel.text = ""
            payPalUserLabel.text = payPal?.login
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payButton.layer.cornerRadius = 15
    }

    // MARK: - Table view data source


    @IBAction func payButtonPressed(_ sender: UIButton) {
        
    }
}
