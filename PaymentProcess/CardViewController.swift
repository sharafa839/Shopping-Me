//
//  CardViewController.swift
//  Shopping
//
//  Created by ahmed on 20/02/2021.
//  Copyright © 2021 ahmed. All rights reserved.
//

import UIKit
import Stripe

protocol cardViewControllerDelegate {
    func clickDoneButton(_ token:STPToken)
      func clickCanceButton()
}

class CardViewController: UIViewController {


    @IBOutlet weak var DoneButton:UIButton!
    
    let paymentCardTextField = STPPaymentCardTextField()
    var delegate:cardViewControllerDelegate?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentCardTextField.delegate = self

        // Do any additional setup after loading the view.
        view.addSubview(paymentCardTextField)
        paymentCardTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .top, relatedBy: .equal, toItem: DoneButton, attribute: .bottom, multiplier: 1, constant: 40))
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -20))
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 20))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelButtonPressed(_ sender:UIButton){
        dismiss()
    }
    
    
    
    @IBAction func DoneButtonPressed(_ sender:UIButton){
        
        cardProcess()
    }
    
    
    private func dismiss(){
        delegate?.clickCanceButton()
        dismiss(animated: true, completion: nil)
    }
    
    
    private func cardProcess(){
        let cardParms = STPCardParams()
        cardParms.number = paymentCardTextField.cardNumber
        cardParms.expMonth = paymentCardTextField.expirationMonth
        cardParms.expYear = paymentCardTextField.expirationYear
        cardParms.cvc = paymentCardTextField.cvc
        
        STPAPIClient.shared().createToken(withCard: cardParms) { (token, error) in

            if error == nil{
                self.delegate?.clickDoneButton(token!)
                self.dismiss(animated: true, completion: nil)
            }else{
                print("error in get token\(error!.localizedDescription)")
            }
        }
    }
    
}
extension CardViewController : STPPaymentCardTextFieldDelegate{
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        DoneButton.isEnabled = textField.isValid 
    }
}
