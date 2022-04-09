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
    
    var selectedPaymentType = PaymentMethods.creditCard
    
    var cardPayment: CardPayment? {
        didSet {
            showCreditCard()
        }
    }
    
    var payPal: PayPalPayment? {
        didSet {
            showPayPal()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardHolderLabel.text = cardPayment?.cardHolderName
        let cardNumberString = cardPayment?.cardNumber
        cardNumberLabel.text = "\(String(describing: cardNumberString))"
        
        payButton.layer.cornerRadius = 15
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func showCreditCard() {
        cardHolderLabel.text = cardPayment?.cardHolderName
        cardNumberLabel.text = "\(String(describing: cardPayment?.cardNumber))"
        payPalUserLabel.text = ""
    }
    
    func showPayPal() {
        cardHolderLabel.text = ""
        cardNumberLabel.text = ""
        payPalUserLabel.text = payPal?.login
    }
    
    func showBankTransfer(){
        
    }

    // MARK: - Table view data source

    @IBAction func payButtonPressed(_ sender: UIButton) {
        
    }
    
    //MARK: - Delegate Methods
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch selectedPaymentType {
//        case .creditCard:
//            return 50
//        case .payPal:
//            return 50
//        case .bankTransfer:
//            return 50
//        }
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3.0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20.0
        }
        return 4.0
    }
}
