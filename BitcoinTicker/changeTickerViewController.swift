//
//  changeTickerViewController.swift
//  BitcoinTicker
//
//  Created by Giulio Gola on 11.04.19.
//

import UIKit

protocol changeTicker {
    func changeTickerAndGetPrice(tickerPassed : String)
}

class changeTickerViewController: UIViewController {

    var delegate : changeTicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .right {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func changeButtonPressed(_ sender: AnyObject) {
        if let newTicker = sender.titleLabel?.text {
            delegate?.changeTickerAndGetPrice(tickerPassed: newTicker)
            navigationController?.popViewController(animated: true)
        }
    }
}
