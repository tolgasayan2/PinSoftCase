//
//  EmptyViewController.swift
//  PinSoftCase
//
//  Created by Tolga Sayan on 21.12.2021.
//

import UIKit
import Firebase
import FirebaseAnalytics

class DetailViewController: UIViewController {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  @IBOutlet weak var releaseLabel: UILabel!
  @IBOutlet weak var directorLabel: UILabel!
  @IBOutlet weak var director: UILabel!
  @IBOutlet weak var actors: UILabel!
  @IBOutlet weak var actorLabel: UILabel!
  
  var data: Displayable?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.clear
    let newView = GradientView(frame: CGRect.zero)
    newView.frame = view.bounds
    view.insertSubview(newView, at: 0
    )
    
    commonInıt()
  }
  
  @IBAction func close(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func commonInıt() {
    guard let data =  data else {return}
    titleLabel.text = data.titleLabel
    genreLabel.text = data.genreText
    releaseLabel.text = data.release
    director.text = data.directorLabel
    actorLabel.text = data.actorLabel
    
    Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
      AnalyticsParameterItemID: "id-\(titleLabel.text!)",
      AnalyticsParameterItemName: titleLabel.text!,
      AnalyticsParameterContentType: "cont",
    ])
  }
}

