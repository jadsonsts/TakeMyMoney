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
    var isEditingExpirationDate: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var cardRowSection = (row: 1, section: 2)
    var expirationDateRowSection = (row: 1, section: 3)
    var paypalRowSection = (row: 1, section: 4)
    var bankTransferRowSection = (row: 1, section: 5)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentTypeCollectionView.dataSource = self
        paymentTypeCollectionView.delegate = self
        paymentTypeCollectionView.allowsSelection = true
        
        proceedPaymentButton.layer.cornerRadius = 15
        
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none


    }
    
//    func updateView() {
//        if let cardPayment = cardPayment {
//            cardNumberTextField.text = String(cardPayment.cardNumber)
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .short
//            expirationDateTextField.text = dateFormatter.string(from: cardPayment.expDate)
//            CVVTextField.text = String(cardPayment.CVV)
//            cardHolderNameTextField.text = cardPayment.cardHolderName
//        } else if let payPalPayment = payPalPayment {
//            payPalLoginTextField.text = payPalPayment.login
//            payPalPasswordTextField.text = payPalPayment.password
//        }
//    }
    
    func updateExpireDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        expirationDateTextField.text = String(dateFormatter.string(from: expireDatePicker.date).dropFirst(3))
        
        disableProceedButton()
    }
    
    func disableProceedButton() {
        
    }
    
    
    @IBAction func proceedButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateExpireDate()
        
    }
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row, indexPath.section) {
        case (cardRowSection.row, cardRowSection.section):
            return 280
        case (expirationDateRowSection.row, expirationDateRowSection.section):
            return expireDatePicker.frame.height
            
        case (paypalRowSection.row, paypalRowSection.section):
            return 130
            
        case (bankTransferRowSection.row, bankTransferRowSection.section):
            return 52
            
        default:
            return 280.0
        }
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
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 0.5
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
