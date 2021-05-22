//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
//import CounterCore
//import CounterPresentation
//import CounterAPI
//import HTTPClient
//import CounterStore
//import CounterUI
//import CounterTests

public protocol ViewConfiguration {
    func setupHierarchy()
    func setupConstraints()
    func setupViews()
}

public extension ViewConfiguration {
    
    func setup() {
        setupHierarchy()
        setupConstraints()
        setupViews()
    }
    
    func setupConstraints() {}
    
    func setupViews() {}
}

public class ViewConfigurationController<View: UIView & ViewConfiguration>: UIViewController {
    
    public var contentView: View {
        return view as! View
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func loadView() {
        view = View()
    }
}

private extension CounterView {
    
    enum Layout {
        
        enum Root {
            static let radius: CGFloat = 8
            static let color = UIColor.systemBackground.cgColor
        }
    
        enum Counter {
            static let top: CGFloat = 15
            static let left: CGFloat = 14
            static let right: CGFloat = -10
            static let font: UIFont = .systemFont(ofSize: 24, weight: .semibold)
            static let kern: CGFloat = -0.41
            static let paragraph: CGFloat = 0.77
            static let color = UIColor(named: "AccentColor")
        }
        
        enum Separator {
            static let width: CGFloat = 2
            static let left: CGFloat = 59
            static let color = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        }
        
        enum Title {
            static let top: CGFloat = 16
            static let left: CGFloat = 10
            static let bottom: CGFloat = -60
            static let right: CGFloat = -14
            static let font: UIFont = .systemFont(ofSize: 17, weight: .regular)
            static let kern: CGFloat = 0.34
        }
        
        enum Stepper {
            static let bottom: CGFloat = -14
            static let right: CGFloat = -14
        }
        
        enum Shadow {
            static let opacity: Float = 1
            static let radius: CGFloat = 16 // B
            static let offset = CGSize(width: 0, height: 4) // X, Y
            static let color = UIColor(white: 0, alpha: 0.02).cgColor // Color, Opacity
        }
    }
}

final class CounterView: UIView {
    
    // MARK: - Properties
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Layout.Counter.color
        label.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: Layout.Counter.font)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Layout.Separator.color
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: Layout.Title.font)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var counterStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.addTarget(self, action: #selector(didTapOnStepper(_:)), for: .valueChanged)
        return stepper
    }()
    
    private lazy var shapeLayer = CAShapeLayer()
    
    private lazy var shadowLayer: CALayer = {
        let contentLayer = CALayer()
        contentLayer.shadowColor = Layout.Shadow.color
        contentLayer.shadowOpacity = Layout.Shadow.opacity
        contentLayer.shadowRadius = Layout.Shadow.radius
        contentLayer.shadowOffset = Layout.Shadow.offset
        return contentLayer
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Actions
    
    @objc private func didTapOnStepper(_ stepper: UIStepper) {
        print(stepper.value)
    }
}

// MARK: - Public Implementation

extension CounterView {
    
    struct ViewModel: Hashable {
        let counter: String
        let title: String
        let enabled: Bool
    }
    
    public func configure(with viewModel: ViewModel) {
        counterLabel.attributedText = .init(
            string: viewModel.counter,
            attributes: [
                .kern: Layout.Counter.kern,
//                .paragraphStyle: Layout.Counter.paragraph
            ]
        )
        titleLabel.attributedText = .init(string: viewModel.title, attributes: [.kern: Layout.Title.kern])
        counterStepper.isEnabled = viewModel.enabled
    }
}

extension CounterView: ViewConfiguration {
    
    func setupHierarchy() {
        addSubview(counterLabel)
        addSubview(separatorView)
        addSubview(titleLabel)
        addSubview(counterStepper)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            counterLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Layout.Counter.top
            ),
            counterLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Layout.Counter.left
            ),
            counterLabel.trailingAnchor.constraint(
                equalTo: separatorView.leadingAnchor,
                constant: Layout.Counter.right
            ),
            separatorView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            separatorView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Layout.Separator.left
            ),
            separatorView.bottomAnchor.constraint(
                equalTo: bottomAnchor
            ),
            separatorView.widthAnchor.constraint(
                equalToConstant: Layout.Separator.width
            ),
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Layout.Title.top
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: separatorView.trailingAnchor,
                constant: Layout.Title.left
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: Layout.Title.bottom
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: Layout.Title.right
            ),
            counterStepper.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: Layout.Stepper.bottom
            ),
            counterStepper.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: Layout.Stepper.right
            ),
        ])
    }
    
    func setupViews() {
        clipsToBounds = false
        
        layer.insertSublayer(shadowLayer, at: 0)
        layer.insertSublayer(shapeLayer, at: 1)
        
        shapeLayer.fillColor = Layout.Root.color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: Layout.Root.radius)
    
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.bounds = bounds
        shadowLayer.position = bounds.center()
        
        shapeLayer.path = path.cgPath
        shapeLayer.bounds = bounds
        shapeLayer.position = bounds.center()
    }
}

public extension CGRect {
    
    func center() -> CGPoint {
        
        let x = size.width / 2
        let y = size.height / 2
        
        return CGPoint(x: x, y: y)
    }
}


class MyViewController : UIViewController {
    
    private lazy var counterView: CounterView = {
        let counterView = CounterView()
        counterView.translatesAutoresizingMaskIntoConstraints = false
        return counterView
    }()
    
    private lazy var counterView2: CounterView = {
        let counterView = CounterView()
        counterView.translatesAutoresizingMaskIntoConstraints = false
        return counterView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [counterView, counterView2]
        )
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
        
        counterView.configure(with: .init(counter: "5", title: "Number of times I’ve forgotten my mother’s name because I was high on Frugelés.", enabled: false))
        counterView2.configure(with: .init(counter: "10", title: "Records played", enabled: true))
    }
}

final class CounterCell: UITableViewCell {
    
    lazy var counterView: CounterView = {
        let counterView = CounterView()
        counterView.translatesAutoresizingMaskIntoConstraints = false
        return counterView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(counterView)
        contentView.backgroundColor = .systemGroupedBackground
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            counterView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            counterView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 12
            ),
            counterView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -8
            ),
            counterView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12
            ),
        ])
    }
    
    required init?(coder: NSCoder) { nil }
}

protocol CountersViewDelegate: AnyObject {
    func countersViewDidBeginEditing(_ view: CountersView)
    func countersViewDidEndEditing(_ view: CountersView)
    func countersViewDidSendAdd(_ view: CountersView)
    func countersViewDidSendAction(_ view: CountersView)
    func countersViewDidSendTrash(_ view: CountersView)
}

final class CountersView: UIView {
    
    weak var delegate: CountersViewDelegate?
    
    private(set) lazy var editButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapOnEditButton(_:)))
        return barButton
    }()
    
    private(set) lazy var doneButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapOnDoneButton(_:)))
        return barButton
    }()
    
    private(set) lazy var selectAllButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(didTapOnSelectAllButton(_:)))
        return barButton
    }()
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CounterCell.self, forCellReuseIdentifier: "CounterCell")
        tableView.backgroundColor = Layout.TableView.color
        tableView.estimatedRowHeight = Layout.TableView.estimatedRowHeight
        tableView.rowHeight = Layout.TableView.rowHeight
        tableView.separatorStyle = Layout.TableView.separatorStyle
        tableView.contentInset = Layout.TableView.contentInset
        tableView.allowsMultipleSelectionDuringEditing = true
        return tableView
    }()
    
    private(set) lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.setItems([.init(systemItem: .fixedSpace), .init(systemItem: .flexibleSpace), summaryButton, .init(systemItem: .flexibleSpace), addButton], animated: false)
        return toolbar
    }()
    
    private(set) lazy var trashButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapOnTrashButton(_:)))
        return barButton
    }()

    private(set) lazy var actionButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapOnActionButton(_:)))
        return barButton
    }()
    
    private(set) lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "4 items · Counted 16 times"
        label.textAlignment = .center
        return label
    }()
    
    private(set) lazy var summaryButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(customView: summaryLabel)
        return barButton
    }()
    
    private(set) lazy var addButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnAddButton(_:)))
        return barButton
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Actions
    
    @objc private func didTapOnEditButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidBeginEditing(self)
        toolbar.setItems([trashButton, .init(systemItem: .flexibleSpace), actionButton], animated: true)
        tableView.setEditing(true, animated: true)
    }
    
    @objc private func didTapOnDoneButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidEndEditing(self)
        toolbar.setItems([.init(systemItem: .fixedSpace), .init(systemItem: .flexibleSpace), summaryButton, .init(systemItem: .flexibleSpace), addButton], animated: true)
        tableView.setEditing(false, animated: true)
    }
    
    @objc private func didTapOnSelectAllButton(_ sender: UIBarButtonItem) {
        tableView.allIndexPaths.forEach {
            tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
        }
    }
    
    @objc private func didTapOnAddButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidSendAdd(self)
    }
    
    @objc private func didTapOnTrashButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidSendTrash(self)
    }
    
    @objc private func didTapOnActionButton(_ sender: UIBarButtonItem) {
        delegate?.countersViewDidSendAction(self)
    }
}

extension CountersView: ViewConfiguration {
    
    func setupHierarchy() {
        addSubview(tableView)
        addSubview(toolbar)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension CountersView {
    
    enum Layout {
        
        enum TableView {
            static let color = UIColor.red //.systemBackground
            static let estimatedRowHeight = CGFloat(120)
            static let rowHeight = UITableView.automaticDimension
            static let separatorStyle = UITableViewCell.SeparatorStyle.none
            static let contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        }
    }
}

extension UITableView {
    
    var allIndexPaths: [IndexPath] {
        let indexPaths = (0..<numberOfSections).map({ (section) -> [IndexPath] in
            let rows = numberOfRows(inSection: section)
            return (0..<rows).map({ IndexPath(row: $0, section: section) })
        })
        
        return indexPaths.reduce([], +)
    }
    
    var indexPathForNonVisibleRows: [IndexPath]? {
        return indexPathsForVisibleRows
            .flatMap(Set.init)
            .flatMap({ $0.intersection(Set(allIndexPaths)) })
            .map(Array.init)
    }
}

final class MyTableViewController: UITableViewController {
    
    let viewModels = (0..<10).map({
        CounterView.ViewModel(counter: $0.description, title: "Counter \($0)", enabled: $0 % 2 == 0)
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(CounterCell.self, forCellReuseIdentifier: "CounterCell")
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 8, left: 0, bottom: 8, right: 0)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CounterCell") as! CounterCell
        let viewModel = viewModels[indexPath.row]
        cell.counterView.configure(with: viewModel)
        
        return cell
    }
}

final class CountersViewController: UIViewController {
    
    private lazy var contentView = CountersView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        navigationItem.title = "Counters"
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.leftBarButtonItem = contentView.editButton
    }
}

extension CountersViewController: CountersViewDelegate {
    
    func countersViewDidBeginEditing(_ view: CountersView) {
        navigationItem.setLeftBarButton(view.doneButton, animated: true)
        navigationItem.setRightBarButton(view.selectAllButton, animated: true)
        view.summaryLabel.text = "Editing"
    }
    
    func countersViewDidEndEditing(_ view: CountersView) {
        navigationItem.setLeftBarButton(view.editButton, animated: true)
        navigationItem.setRightBarButton(nil, animated: false)
        view.summaryLabel.text = "Done"
    }
    
    func countersViewDidSendAdd(_ view: CountersView) {
        present(UIViewController(), animated: true)
    }
    
    func countersViewDidSendAction(_ view: CountersView) {
        let shareVC = UIActivityViewController(activityItems: ["Hey i'm sharing"], applicationActivities: nil)
        present(shareVC, animated: true)
    }
    
    func countersViewDidSendTrash(_ view: CountersView) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(.init(title: "Delete", style: .destructive, handler: nil))
        alertVC.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertVC, animated: true)
    }
}

let countersVC = CountersViewController()

let countersNC = UINavigationController(rootViewController: countersVC)
countersNC.navigationBar.prefersLargeTitles = true

let (parent, child) = playgroundControllers(device: .phone5_5inch, orientation: .portrait, child: countersNC, additionalTraits: .init())

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = parent



public enum Device {
  case phone3_5inch
  case phone4inch
  case phone4_7inch
  case phone5_5inch
  case pad
  case pad12_9inch
}

public enum Orientation {
  case portrait
  case landscape
}

/**
 Creates a controller that represents a specific device, orientation with specific traits.
 - parameter device:           The device the controller should represent.
 - parameter orientation:      The orientation of the device.
 - parameter child:            An optional controller to put inside the parent controller. If omitted
 a blank controller will be used.
 - parameter additionalTraits: An optional set of traits that will also be applied. Traits in this collection
 will trump any traits derived from the device/orientation comboe specified.
 - returns: Two controllers: a root controller that can be set to the playground's live view, and a content
 controller which should have UI elements added to it
 */
public func playgroundControllers(device: Device = .phone4_7inch,
                                  orientation: Orientation = .portrait,
                                  child: UIViewController = UIViewController(),
                                  additionalTraits: UITraitCollection = .init())
  -> (parent: UIViewController, child: UIViewController) {

    let parent = UIViewController()
    parent.addChild(child)
    parent.view.addSubview(child.view)

    child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    let traits: UITraitCollection
    switch (device, orientation) {
    case (.phone3_5inch, .portrait):
      parent.view.frame = .init(x: 0, y: 0, width: 320, height: 480)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .compact),
        .init(verticalSizeClass: .regular),
        .init(userInterfaceIdiom: .phone)
        ])
    case (.phone3_5inch, .landscape):
      parent.view.frame = .init(x: 0, y: 0, width: 480, height: 320)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .compact),
        .init(verticalSizeClass: .compact),
        .init(userInterfaceIdiom: .phone)
        ])
    case (.phone4inch, .portrait):
      parent.view.frame = .init(x: 0, y: 0, width: 320, height: 568)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .compact),
        .init(verticalSizeClass: .regular),
        .init(userInterfaceIdiom: .phone)
        ])
    case (.phone4inch, .landscape):
      parent.view.frame = .init(x: 0, y: 0, width: 568, height: 320)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .compact),
        .init(verticalSizeClass: .compact),
        .init(userInterfaceIdiom: .phone)
        ])
    case (.phone4_7inch, .portrait):
      parent.view.frame = .init(x: 0, y: 0, width: 375, height: 667)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .compact),
        .init(verticalSizeClass: .regular),
        .init(userInterfaceIdiom: .phone)
        ])
    case (.phone4_7inch, .landscape):
      parent.view.frame = .init(x: 0, y: 0, width: 667, height: 375)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .compact),
        .init(verticalSizeClass: .compact),
        .init(userInterfaceIdiom: .phone)
        ])
    case (.phone5_5inch, .portrait):
      parent.view.frame = .init(x: 0, y: 0, width: 414, height: 736)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .compact),
        .init(verticalSizeClass: .regular),
        .init(userInterfaceIdiom: .phone)
        ])
    case (.phone5_5inch, .landscape):
      parent.view.frame = .init(x: 0, y: 0, width: 736, height: 414)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .regular),
        .init(verticalSizeClass: .compact),
        .init(userInterfaceIdiom: .phone)
        ])
    case (.pad, .portrait):
      parent.view.frame = .init(x: 0, y: 0, width: 768, height: 1024)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .regular),
        .init(verticalSizeClass: .regular),
        .init(userInterfaceIdiom: .pad)
        ])
    case (.pad, .landscape):
      parent.view.frame = .init(x: 0, y: 0, width: 1024, height: 768)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .regular),
        .init(verticalSizeClass: .regular),
        .init(userInterfaceIdiom: .pad)
        ])
    case (.pad12_9inch, .portrait):
      parent.view.frame = .init(x: 0, y: 0, width: 1024, height: 1366)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .regular),
        .init(verticalSizeClass: .regular),
        .init(userInterfaceIdiom: .pad)
        ])
    case (.pad12_9inch, .landscape):
      parent.view.frame = .init(x: 0, y: 0, width: 1366, height: 1024)
      traits = .init(traitsFrom: [
        .init(horizontalSizeClass: .regular),
        .init(verticalSizeClass: .regular),
        .init(userInterfaceIdiom: .pad)
        ])
    }

    child.view.frame = parent.view.frame
    parent.preferredContentSize = parent.view.frame.size
    parent.view.backgroundColor = .white

    let allTraits = UITraitCollection.init(traitsFrom: [traits, additionalTraits])
    parent.setOverrideTraitCollection(allTraits, forChild: child)

    return (parent, child)
}
