//
//  ViewController.swift
//  Japan
//
//  Created by stone on 5/25/19.
//  Copyright © 2019 stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//  override func viewDidLoad() {
//    super.viewDidLoad()
//    // Do any additional setup after loading the view.
//  }
  @IBOutlet weak var canvas: UIView!
  @IBOutlet weak var resultImage: UIImageView!
  //@IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var recognizeButton: UIButton!
  
  var path = UIBezierPath()
  var startPoint = CGPoint()
  var touchPoint = CGPoint()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    canvas.clipsToBounds = true
    canvas.isMultipleTouchEnabled = true
    resultImage.isHidden = true
    styleButtons()
  }
  
  func styleButtons() {
    clearButton.makeRounded()
    clearButton.addBorder(color: UIColor.cherryPink)
    clearButton.setTitleColor(UIColor.cherryPink, for: .normal)
    recognizeButton.makeRounded()
    recognizeButton.backgroundColor = UIColor.cherryPink
    recognizeButton.setTitleColor(UIColor.white, for: .normal)
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    if let point = touch?.location(in: canvas) {
      startPoint = point
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    if let point = touch?.location(in: canvas) {
      touchPoint = point
    }
    
    path.move(to: startPoint)
    path.addLine(to: touchPoint)
    startPoint = touchPoint
    draw()
  }
  
  
  func draw() {
    let strokeLayer = CAShapeLayer()
    strokeLayer.fillColor = nil
    strokeLayer.lineWidth = 8
//
//    if segmentedControl.selectedSegmentIndex == 0 {
//      strokeLayer.strokeColor = UIColor.orange.cgColor
//    } else {
//      strokeLayer.strokeColor = UIColor.yellow.cgColor
//    }
    strokeLayer.strokeColor = UIColor.white.cgColor
    strokeLayer.path = path.cgPath
    canvas.layer.addSublayer(strokeLayer)
    
  }
  
  @IBAction func recognizePressed(_ sender: UIButton) {
    resultImage.image = UIImage.init(view: canvas)
    let pixelBuffer = resultImage.image?.pixelBuffer()
    let model = hiraganeModel()
    //let model = hiraganaModel()
    let output = try? model.prediction(image: pixelBuffer!)
    informResultPopUp(message: (output?.classLabel)!)
    print(output?.classLabel as Any)
    
  }
  
  func informResultPopUp(message: String) {
    let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default, handler: { action in
      self.dismiss(animated: true, completion: nil)
    })
    alertController.addAction(ok)
    self.present(alertController, animated: true) { () in
    }
  }
  
  @IBAction func clearPressed(_ sender: UIButton) {
    path.removeAllPoints()
    canvas.layer.sublayers = nil
    canvas.setNeedsDisplay()
  }

}

