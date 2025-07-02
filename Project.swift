import ProjectDescription

let project = Project(
    name: "GitUserSearch",
    targets: [
        // Main App Target
        .target(
            name: "GitUserSearch",
            destinations: .iOS,
            product: .app,
            bundleId: "com.gitusersearch.app",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen",
                    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
                ]
            ),
            sources: ["Sources/App/**"],
            resources: ["Sources/App/Resources/**"],
            dependencies: [
                .target(name: "PresentationLayer"),
                .target(name: "DomainLayer"),
                .target(name: "DataLayer")
            ]
        ),
        
        // Presentation Layer
        .target(
            name: "PresentationLayer",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.gitusersearch.presentation",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/PresentationLayer/**"],
            dependencies: [
                .target(name: "DomainLayer")
            ]
        ),
        
        // Domain Layer
        .target(
            name: "DomainLayer", 
            destinations: .iOS,
            product: .framework,
            bundleId: "com.gitusersearch.domain",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/DomainLayer/**"]
        ),
        
        // Data Layer
        .target(
            name: "DataLayer",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.gitusersearch.data",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/DataLayer/**"],
            dependencies: [
                .target(name: "DomainLayer")
            ]
        ),
        
        // Test Targets
        .target(
            name: "GitUserSearchTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.gitusersearch.tests",
            deploymentTargets: .iOS("17.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "GitUserSearch"),
                .target(name: "DomainLayer"),
                .target(name: "DataLayer"),
                .target(name: "PresentationLayer")
            ]
        )
    ]
) 