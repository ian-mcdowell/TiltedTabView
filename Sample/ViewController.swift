import TiltedTabView

class ViewController: TiltedTabViewController {
    
    var tabs: [String]
    
    override init() {
        self.tabs = ["Tilted", "Tab", "View"]
        super.init()
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.barStyle = .blackTranslucent
        self.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTab)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
    }
    
    @objc private func addNewTab() {
        self.addTab(atIndex: tabs.count)
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
        let tab = tabs.remove(at: fromIndex)
        tabs.insert(tab, at: toIndex)
    }
    
}

extension ViewController: TiltedTabViewControllerDelegate {
    func tabSelected(atIndex index: Int) {
        
    }

}
