//
//  ViewController.swift
//  WindowAddSubview
//
//  Created by Kolyutsakul, Thongchai on 2/8/24.
//

import UIKit

class ViewController: UIViewController {

  var customWindow: CustomWindow?

  lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .red
    label.backgroundColor = .gray
    label.text = "Test test test"
    return label
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    // Create the button
    let button = UIButton(type: .system)
    button.setTitle("Present Modal", for: .normal)
    button.addTarget(self, action: #selector(presentModal), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false

    // Add the button to the view
    view.addSubview(button)

    // Center the button in the view
    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  @objc func presentModal() {
    let dummyVC = DummyViewController()
    dummyVC.modalPresentationStyle = .fullScreen

    addButtonToCustomWindow()
    present(dummyVC, animated: true, completion: nil)
  }

  func addButtonToCustomWindow() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return
    }

    customWindow = CustomWindow(windowScene: windowScene)
    customWindow?.frame = UIScreen.main.bounds
    customWindow?.isHidden = false

    let button = UIButton(type: .system)
    button.setTitle("Print to Console", for: .normal)
    button.addTarget(self, action: #selector(printToConsole), for: .touchUpInside)
    button.backgroundColor = .black
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false

    customWindow?.addSubview(button)

    NSLayoutConstraint.activate([
      button.centerXAnchor.constraint(equalTo: customWindow!.centerXAnchor),
      button.centerYAnchor.constraint(equalTo: customWindow!.centerYAnchor, constant: 100),
      button.widthAnchor.constraint(equalToConstant: 200),
      button.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  @objc func printToConsole() {
    print("Button on window tapped!")
  }

}

class DummyViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .green

    // Create the dismiss button
    let dismissButton = UIButton(type: .system)
    dismissButton.setTitle("Dismiss", for: .normal)
    dismissButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    dismissButton.translatesAutoresizingMaskIntoConstraints = false

    // Add the button to the view
    view.addSubview(dismissButton)

    // Center the button in the view
    NSLayoutConstraint.activate([
      dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      dismissButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }

  @objc func dismissModal() {
    dismiss(animated: true, completion: nil)
  }
}


class CustomWindow: UIWindow {
  override init(windowScene: UIWindowScene) {
    super.init(windowScene: windowScene)
    self.windowLevel = UIWindow.Level.alert + 1
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.windowLevel = UIWindow.Level.alert + 1
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    if hitView == self {
      return nil // Pass the touch through if it's not on a subview
    }
    return hitView
  }
}
