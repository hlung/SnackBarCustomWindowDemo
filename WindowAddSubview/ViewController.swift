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
    button.setTitle("Present Modal and Snack Bar", for: .normal)
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
    let dummyVC = DummyModalViewController()
    dummyVC.modalPresentationStyle = .fullScreen

    showSnackBar()
    present(dummyVC, animated: true, completion: nil)
  }

  func showSnackBar() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return
    }

    let window = CustomWindow(windowScene: windowScene)
    window.isHidden = false
    self.customWindow = window

    let vc = SnackBarViewController()
    window.rootViewController = vc
    vc.dismissButton.addTarget(self, action: #selector(onDismissSnackbar), for: .touchUpInside)
  }

  @objc func onDismissSnackbar() {
    self.customWindow?.isHidden = true
    self.customWindow = nil
  }

}

class DummyModalViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .darkGray

    // Create the dismiss button
    let dismissButton = UIButton(type: .system)
    dismissButton.setTitle("Dismiss Modal", for: .normal)
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

class SnackBarViewController: UIViewController {

  private let messageLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  let dismissButton: UIButton = {
    let button = UIButton(type: .system)
    return button
  }()

  private let containerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 8
    view.clipsToBounds = true
    view.backgroundColor = .brown
    return view
  }()

  override func loadView() {
    view = IgnoreTouchView()
  }

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    setupConstraints()
  }

  private func setupViews() {
    messageLabel.text = "Snack Bar"
    dismissButton.setTitle("Dismiss snack bar", for: .normal)
    dismissButton.addTarget(self, action: #selector(dismissSnackBar), for: .touchUpInside)

    containerView.addSubview(messageLabel)
    containerView.addSubview(dismissButton)
    view.addSubview(containerView)
  }

  private func setupConstraints() {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    dismissButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

      messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
      messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

      dismissButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
      dismissButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
      dismissButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
    ])
  }

  @objc private func dismissSnackBar() {
    dismiss(animated: true, completion: nil)
  }
}

class IgnoreTouchView: UIView {

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let hitView = super.hitTest(point, with: event)
    if hitView == self {
      return nil
    }
    return hitView
  }

}
