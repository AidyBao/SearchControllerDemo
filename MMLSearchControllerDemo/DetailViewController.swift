//
//  DetailViewController
//  SearchControllerDemo
//
//  Created by webwerks on 20/08/17.
//  Copyright © 2017 smart. All rights reserved.
//


import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var candyImageView: UIImageView!
  
  var detailEmployee: Employee? {
    didSet {
      configureView()
    }
  }
  
  func configureView() {
    if let detailEmployee = detailEmployee {
      if let detailDescriptionLabel = detailDescriptionLabel, let candyImageView = candyImageView {
        detailDescriptionLabel.text = detailEmployee.name
        candyImageView.image = UIImage(named: detailEmployee.name)
        title = detailEmployee.department
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

