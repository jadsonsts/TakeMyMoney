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
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var payButton: UIButton!
    
    var selectedPaymentType: PaymentMethods!
    var paymentInfo: PaymentDetails!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var paymentIconName = ""
        switch selectedPaymentType {
        case .creditCard:
            paymentIconName = "creditcard.png"
        case .payPal:
            paymentIconName = "paypal.png"
        case .bankTransfer:
            payButton.setTitle("Make Transfer", for: .normal)
            paymentIconName = "banktransfer.png"
        default:
             break
        }
        
        paymentImageView.image = UIImage(named: paymentIconName)
        cardHolderLabel.text = paymentInfo.username
        cardNumberLabel.text = paymentInfo.payDetails
        let color = UIColor(red: 255/255, green: 134/255, blue: 94/255, alpha: 1.0)
        cardNumberLabel.textColor = color
        cardHolderLabel.textColor = color
        
        payButton.layer.cornerRadius = 15
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    @IBAction func payButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Sorry 😢", message: "Your payment has failed" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Delegate Methods
    
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
