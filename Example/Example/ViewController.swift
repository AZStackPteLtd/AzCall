//
//  ViewController.swift
//  Example
//
//  Created by Luong Van Lam on 6/11/18.
//  Copyright © 2018 lamlv. All rights reserved.
//

import AzCall
import AzCore
import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    @IBOutlet var loadingView: UIView!
    
    enum SectionIndex: Int {
        case rtcVideoCall = 0
        case rtcAudioCall = 1
        case freeSwitchCall = 2
        
        var title: String? {
            let data = ["WebRTC Video Call", "WebRTC Audio Call", "Free Switch Call"]
            return data[hashValue]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let attr = NSAttributedString(string: "Sign Out", attributes: [
            NSAttributedStringKey.foregroundColor: UIColor.blue
        ])
        
        let btnSignOut = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        btnSignOut.setAttributedTitle(attr, for: .normal)
        btnSignOut.sizeToFit()
        btnSignOut.addTarget(self, action: #selector(signOutOnClick), for: .touchUpInside)
        btnSignOut.tintColor = UIColor.blue
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnSignOut)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard AzStackManager.shared.networkManager.socketIsConnected == false else { return }
        
        if AzStackManager.shared.userId != "", AzStackManager.shared.userCredentials != "" {
            startAuth(userId: AzStackManager.shared.userId, credentials: AzStackManager.shared.userCredentials)
        } else {
            showInputName()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showInputName() {
        guard AzStackManager.shared.networkManager.socketIsConnected == false else { return }
        
        let alert = UIAlertController(title: "User Information", message: "Select your user to work with AzStack", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "Input your AzStack's userId"
        })
        
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "Input your credentials"
        })
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
            let userId = alert.textFields?[0].text ?? ""
            let credentials = alert.textFields?[1].text ?? ""
            
            self.startAuth(userId: userId, credentials: credentials)
        })
        
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(with msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func startAuth(userId: String, credentials: String) {
        self.indicator.startAnimating()
        self.loadingView.isHidden = false
        AzStackManager.shared.connectWithAzStack(
            userId: userId,
            userCredentials: credentials,
            fullname: "Demo User - \(userId)",
            additionInfo: nil,
            completion: { result in
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.loadingView.isHidden = true
                    
                    if let err = result.error {
                        self.showAlert(with: err.localizedDescription)
                    } else {
                        self.title = result.userId
                        self.loadingView.isHidden = true
                    }
                }
            }
        )
    }
    
    @objc func signOutOnClick() {
        AzStackManager.shared.logOut({ error in
            guard error == nil else {
                return self.showAlert(with: error!.localizedDescription)
            }
            
            self.showInputName()
        })
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let sectionIndex = SectionIndex(rawValue: indexPath.section) else {
            fatalError()
        }
        
        switch sectionIndex {
        case .rtcVideoCall:
            selectUserForRtcCall(true)
            
        case .rtcAudioCall:
            selectUserForRtcCall(false)
            
        case .freeSwitchCall:
            AzCallManager.shared.showFreeSwitchCall(true, completionPresent: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func selectUserForRtcCall(_ hasVideo: Bool) {
        let alert = UIAlertController(title: "Partner AzUsreId", message: "Select your friend id to make a call", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textfield in
            textfield.placeholder = "Partner's AzUserId"
        })
        
        let confirm = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            guard let azUserId = alert.textFields?.first?.text, azUserId != "" else {
                return
            }
            
            self.showRtcCall(with: azUserId, hasVideo: hasVideo)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showRtcCall(with azUserId: String, hasVideo: Bool) {
        AzCallManager.shared.startRtcCallWith(
            azUserId,
            hasVideo: hasVideo,
            animatedPresent: false,
            completionPresent: nil
        )
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionIndex.freeSwitchCall.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SectionIndex(rawValue: indexPath.section) else {
            fatalError()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = section.title
        
        return cell
    }
}
