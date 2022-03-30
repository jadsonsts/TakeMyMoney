//
//  PaymentDataTableVC.swift
//  TakeMyMoney
//
//  Created by Jadson on 28/03/22.
//

import UIKit

class PaymentDataTableVC: UITableViewController {
    
    @IBOutlet weak var paymentTypeCollectionView: UICollectionView!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet weak var CVVTextField: UITextField!
    @IBOutlet weak var cardHolderNameTextField: UITextField!
    @IBOutlet weak var expireDatePicker: UIDatePicker!
    @IBOutlet weak var payPalLoginTextField: UITextField!
    @IBOutlet weak var payPalPasswordTextField: UITextField!
    @IBOutlet weak var proceedPaymentButton: UIButton!
    
    
    
    struct PropertyKeys {
       static let paymentTypesId = "paymentCell"
    }
    
    var typeOfPayment: PaymentMethods!
    var bankPayment: BankTransferPayment!
    var cardPayment: CardPayment?
    var payPalPayment: PayPalPayment?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentTypeCollectionView.dataSource = self
        paymentTypeCollectionView.delegate = self
        paymentTypeCollectionView.allowsSelection = true

        
        proceedPaymentButton.layer.cornerRadius = 15
//        proceedPaymentButton.layer.borderWidth = 1
        
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none

    }

}

extension PaymentDataTableVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PaymentMethods.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.paymentTypesId, for: indexPath) as? PaymentTypeCollectionViewCell {
            let text = PaymentMethods.all[indexPath.row]
            cell.updateView(paymentType: text)
            
            if cell.isSelected {
                cell.backgroundColor = .blue
            }
            return cell
        }
        return PaymentTypeCollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = PaymentMethods.all[indexPath.row]
        print("clicou aqui = \(type)")
        //collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}
