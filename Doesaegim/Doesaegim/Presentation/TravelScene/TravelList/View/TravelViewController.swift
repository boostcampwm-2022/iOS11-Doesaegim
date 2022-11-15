////
////  TravelViewController.swift
////  Doesaegim
////
////  Created by Jaehoon So on 2022/11/15.
////
//
//import UIKit
//
//private let reuseIdentifier = "Cell"
//
//class TravelViewController: UICollectionViewController {
//
//    private typealias DataSource = UICollectionViewDiffableDataSource<String, TravelInfoViewModel>
//    private typealias Snapshot = NSDiffableDataSourceSnapshot<String, TravelInfoViewModel>
//    
//    private var dataSource: DataSource?
//    
//    init() {
//        
//        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        listConfiguration.showsSeparators = false
//        listConfiguration.headerMode = .firstItemInSection
//        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
//        super.init(collectionViewLayout: listLayout)
//        
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("TravelViewController를 사용할 때는 init()으로 초기화 해주세요.")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureCell()
//        configureNavigationBar()
//        
//        updateSnapshotForView()
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//
//        // Do any additional setup after loading the view.
//    }
//    
//    // MARK: - Configure
//    
//    private func configureCell() {
//        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
//        dataSource = DataSource(collectionView: collectionView, cellProvider: {
//            collectionView, indexPath, identifier in
//            return collectionView.dequeueConfiguredReusableCell(
//                using: cellRegistration,
//                for: indexPath,
//                item: identifier
//            )
//        })
//    }
//    
//    private func configureNavigationBar() {
//        navigationItem.title = "여행 목록"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            barButtonSystemItem: .add,
//            target: self,
//            action: #selector(didAddTravelButtonTap)
//        )
//    }
//    
//    // MARK: - Collection View Handler
//    
//    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, )
//    
//    
//    // MARK: - Actions
//    
//    @objc didAddTravelButtonTap() {
//        print("버튼 탭")
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using [segue destinationViewController].
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//    // MARK: UICollectionViewDataSource
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//    
//        // Configure the cell
//    
//        return cell
//    }
//
//    // MARK: UICollectionViewDelegate
//
//    /*
//    // Uncomment this method to specify if the specified item should be highlighted during tracking
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment this method to specify if the specified item should be selected
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    */
//
//    /*
//    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
//        return false
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//    
//    }
//    */
//
//}
