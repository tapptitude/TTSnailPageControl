//
//  ViewController.swift
//  TTSnailPageControlExample
//
//  Created by Efraim Budusan on 2/16/21.
//

import UIKit
import TTSnailPageControl

class ViewController: UIViewController {

    @IBOutlet weak var pageControl: SnailPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.scrollView = scrollView
        pageControl.configuration.itemsCount = 4
        pageControl.configuration.itemSize = CGSize(width: 20, height: 10)
        pageControl.configuration.spacing = 10.0
        pageControl.configuration.layerConfiguration { (layer, index) in
            layer.backgroundColor = UIColor(named: "Unselected")?.cgColor
            layer.cornerRadius = 5
            
        }
        pageControl.configuration.selectionLayerConfiguration { (layer) in
            layer.backgroundColor = UIColor(named: "Selected")?.cgColor
            layer.cornerRadius = 5
        }
    }
    @IBAction func redrawAction(_ sender: Any) {
        pageControl.configuration.itemsCount += 1
        pageControl.frame.size = pageControl.fittingSize
        
    }
}

