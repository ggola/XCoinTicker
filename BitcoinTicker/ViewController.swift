//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Giulio Gola on 11.04.19.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, changeTicker {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    let currencyArray = ["USD","EUR","GBP","AUD","BRL","CAD","CNY","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    let currencySymbol = ["$", "€", "£", "$", "R$", "$", "¥", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "R"]
    var symbol = ""
    var pickerRow : Int = 0
    var ticker = ""
    var finalURL = ""

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinPriceVariation: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        tickerLabel.text = ""
        bitcoinPriceLabel.text = ""
        bitcoinPriceVariation.text = ""
        
        ticker = "BTC"
        
        symbol = currencySymbol[0]
        finalURL = baseURL + ticker + currencyArray[0]
        getPrice(url: finalURL)
    }
    
    //MARK: - Change Ticker
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeTicker" {
            let destinationVC = segue.destination as! changeTickerViewController
            destinationVC.delegate = self
        }
    }
    
    //MARK: - Swipe to change ticker
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer){
        if sender.direction == .left {
            performSegue(withIdentifier: "changeTicker", sender: self)
        }
        
    }

    //MARK: - Picker view delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerRow = row
        symbol = currencySymbol[row]
        finalURL = baseURL + ticker + currencyArray[row]
        getPrice(url: finalURL)
    }
    
    //MARK: - Change ticker delegate
    func changeTickerAndGetPrice(tickerPassed : String) {
        ticker = tickerPassed
        symbol = currencySymbol[pickerRow]
        finalURL = baseURL + ticker + currencyArray[pickerRow]
        getPrice(url: finalURL)
    }

    //MARK: - Networking
    func getPrice(url: String) {
        Networking().getData(url: url) { (dataJSON) in
            if let priceJSON = dataJSON {
                // UI updates on the main thread
                DispatchQueue.main.async {
                    self.parseData(json : priceJSON)
                }
            } else {
                DispatchQueue.main.async {
                    self.tickerLabel.text = ""
                    self.bitcoinPriceLabel.text = "No data"
                    self.bitcoinPriceVariation.text = ""
                }
            }
        }
    }
    
    //MARK: - JSON Parsing and UI Update
    func parseData(json : JSON) {
        if let price = json["bid"].float {
            tickerLabel.text = ticker
            bitcoinPriceLabel.text = symbol + String(price)
            let percent = json["changes"]["percent"]["day"].floatValue
            if json["changes"]["percent"]["day"].floatValue >= 0 {
                bitcoinPriceVariation.text = "+" + String(percent) + "%"
                bitcoinPriceVariation.textColor = UIColor.darkGray
                bitcoinPriceVariation.backgroundColor = UIColor(red: 0/255, green: 148/255, blue: 50/255, alpha: 1.0)
            } else {
                bitcoinPriceVariation.text = String(percent) + "%"
                bitcoinPriceVariation.textColor = UIColor.white
                bitcoinPriceVariation.backgroundColor = UIColor.red
            }
        }
        else {
            tickerLabel.text = ""
            bitcoinPriceLabel.text = "No data"
            bitcoinPriceVariation.text = ""
        }
    }
}
