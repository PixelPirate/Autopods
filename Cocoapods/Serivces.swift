enum Services {

    static let fileWatch = FileWatchService()
    static let cocoapods = CocoapodsService()
    static let coordinator = CoordinatorService()
    static let podfiles = PodfilesService()
    static let userInterfaceService = UIService()
    static let configuration = ConfigurationService()
}
