//
//  FlickrViewController.swift
//  RxNetWorking
//
//  Created by Jun Dang on 2018-09-23.
//  Copyright © 2018 Jun Dang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftMessages

class FlickrViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    var reachability: Reachability?
    let messages = SwiftMessages()    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1
        reachability = Reachability()
        try? reachability?.startNotifier()
        //2
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        backgroundImageView.addSubview(activityIndicator)
        activityIndicator.frame = backgroundImageView.bounds
        activityIndicator.center = view.center
        //3
        searchTextField.rx.controlEvent(.editingDidEndOnExit).asObservable()
            .map { self.searchTextField.text }
            .filter { ($0 ?? "").count > 0 }
            .flatMap() {text -> Observable<UIImage> in
                activityIndicator.startAnimating()
                return ViewModel(searchText: text ?? "", apiType: InternetService.self).flickrImageObservable
        }
        .asDriver(onErrorJustReturn: UIImage(named: "banff")!)
        .drive(onNext: { [weak self] flickrImage in
            let resizedImage = flickrImage.scaled(CGSize(width: (self?.backgroundImageView.frame.width)!, height: (self?.backgroundImageView.frame.height)!))
            self?.backgroundImageView.image = resizedImage
            activityIndicator.stopAnimating()
        })
        .disposed(by: bag)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //1
        Reachability.rx.isDisconnected
            .subscribe(onNext:{
                let error = MessageView.viewFromNib(layout: .tabView)
                error.configureTheme(.error)
                error.configureContent(title: "Error", body: "Not connected to the network!")
                error.button?.setTitle("Stop", for: .normal)
                SwiftMessages.show(view: error)
            })
            .disposed(by:bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let info = MessageView.viewFromNib(layout: .messageView)
        info.configureTheme(.info)
        info.button?.isHidden = true
        info.configureContent(title: "Search a picture", body: "Please input search text in the search bar.")
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .center
        infoConfig.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: infoConfig, view: info)
    }
}
