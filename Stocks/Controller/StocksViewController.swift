//
//  ViewController.swift
//  Stocks
//
//  Created by Ivan on 11/09/2018.
//  Copyright © 2018 Ivan Sorokoletov. All rights reserved.
//

import UIKit

class StocksViewController: UIViewController
{    
    var stockService: StocksService?
    var companyArray: [Company] = []
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.stockService = StocksService()
        self.stockService?.delegate = self
    }

    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stockService?.loadCompanies()
        
    }
    
    //MARK: - private Methods
    
    private func displayStockInfo(quote: Quote) {
        self.displayStockInfo(companyName: quote.companyName,
                              symbol: quote.symbol, price: quote.latestPrice,
                              priceChange: quote.change)
    }
    
    private func displayStockInfo(companyName: String, symbol: String, price: Double, priceChange: Double) {
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
        self.companySymbolLabel.text = symbol
        self.priceLabel.text = "\(price)"
        self.priceChangeLabel.text = "\(priceChange)"
        
        // solution of ex. 1
        if priceChange > 0 {
            self.priceChangeLabel.textColor = UIColor.green
        } else if priceChange < 0 {
            self.priceChangeLabel.textColor = UIColor.red
        } else {
            self.priceChangeLabel.textColor = UIColor.black
        }
    }
    
    
    private func requestQuoteUpdate()
    {
        self.resetUI()
        
        let selectedRow = self.companyPickerView.selectedRow(inComponent: 0)
        let company = self.companyArray[selectedRow]
        let selectedSymbol = company.symbol
        self.stockService?.requestQuote(for: selectedSymbol)
        self.stockService?.requestQuoteLogo(for: selectedSymbol)
    }
    
    private func resetUI() {
        self.activityIndicator.startAnimating()
        self.companyNameLabel.text = "-"
        self.companySymbolLabel.text = "-"
        self.priceLabel.text = "-"
        self.priceChangeLabel.text = "-"
        
        // solution of ex. 1
        self.priceChangeLabel.textColor = UIColor.black
        
    }
}

extension StocksViewController : StockServiceDelegate
{
    func didReceivedQuote(quote: Quote)
    {
        DispatchQueue.main.async {
            self.displayStockInfo(quote: quote)
        }
    }
    
    func didReceivedCompaniesList(companies: [Company])
    {
        self.companyArray = companies

        DispatchQueue.main.async {
            self.companyPickerView.reloadAllComponents()
            self.requestQuoteUpdate()
        }
    }
    
    func didReceivedQuoteLogo(dataLogo: Data)
    {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: dataLogo)
        }
    }
}

extension StocksViewController : UIPickerViewDataSource, UIPickerViewDelegate
{
    //MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companyArray.count
    }
    
    //MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = companyArray[row].companyName
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.requestQuoteUpdate()
    }
}
