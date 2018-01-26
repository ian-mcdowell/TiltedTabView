import TiltedTabView

class ViewController: UIViewController {
    
    let tiltedTabViewController: TiltedTabViewController
    
    var tabs: [String]
    
    init() {
        self.tiltedTabViewController = TiltedTabViewController()
        self.tabs = ["Tilted", "Tab", "View"]
        super.init(nibName: nil, bundle: nil)
        
        tiltedTabViewController.delegate = self
        tiltedTabViewController.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tilted tab view controller to self
        addChildViewController(tiltedTabViewController)
        self.view.addSubview(tiltedTabViewController.view)
        tiltedTabViewController.didMove(toParentViewController: self)
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.barStyle = .blackTranslucent
        self.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTab)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
    }
    
    @objc private func addTab() {
        self.tiltedTabViewController.addTab(atIndex: tabs.count)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension ViewController: TiltedTabViewControllerDataSource {
    func numberOfTabsInTiltedTabViewController() -> Int {
        return tabs.count
    }
    
    func snapshotForTab(atIndex index: Int) -> UIImage? {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return #imageLiteral(resourceName: "snapshot_ipad")
        }
        return #imageLiteral(resourceName: "snapshot")
    }
    
    func titleForTab(atIndex index: Int) -> String? {
        return tabs[index]
    }
    
    func indexForActiveTab() -> Int? {
        return nil
    }
    
    func tabAdded(atIndex index: Int) {
        tabs.append("Tab")
    }
    
    func tabRemoved(atIndex index: Int) {
        tabs.removeLast()
    }
    
    func tabMoved(fromIndex: Int, toIndex: Int) {
        print("Tab moved: \(fromIndex) \(toIndex)")
    }
    
}

extension ViewController: TiltedTabViewControllerDelegate {
    func tabSelected(atIndex index: Int) {
        
    }

}
