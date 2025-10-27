import ProjectDescription

let defaultSettings: SettingsDictionary = [:]
    .marketingVersion("8.3.0")
    .currentProjectVersion("1.0.0")
    .swiftObjcBridgingHeaderPath("MoEngageTestApp/MoEngageTestApp-Bridging-Header.h")
    .merging([
        "GENERATE_INFOPLIST_FILE": true,
        "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES": true
    ])

let project = Project(
    name: "MoEngagePluginBase",
    packages: [
        .local(path: "../"),
        .local(path: "../../apple-plugin-cards"),
        .local(path: "../../apple-plugin-geofence"),
        .local(path: "../../apple-plugin-inbox"),
    ],
    targets: [
        // Sample Apps
        .target(
            name: "MoEngagePluginBaseCocoaiOS",
            destinations: .iOS,
            product: .app,
            bundleId: "com.alphadevs.MoEngage",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "MoEngagePluginBase/Info.plist",
            sources: [
                "MoEngagePluginBase/**/*.{swift,h,m}"
            ],
            resources: [
                "MoEngagePluginBase/**/*.{xib,storyboard,xcassets,png,gpx,wav,mp3,ttf}",
            ],
            headers: .headers(public: "MoEngagePluginBase/**/*.h"),
            entitlements: "MoEngagePluginBase/MoEngagePluginBase.entitlements",
            settings: .settings(base:defaultSettings)
        ),
        .target(
            name: "MoEngagePluginBaseSPM",
            destinations: .iOS,
            product: .app,
            bundleId: "com.alphadevs.MoEngage",
            deploymentTargets: .iOS("13.0"),
            infoPlist: "MoEngagePluginBase/Info.plist",
            sources: [
                "MoEngagePluginBase/**/*.{swift,h,m}"
            ],
            resources: [
                "MoEngagePluginBase/**/*.{xib,storyboard,xcassets,png,gpx,wav,mp3,ttf}",
            ],
            headers: .headers(public: "MoEngagePluginBase/**/*.h"),
            entitlements: "MoEngagePluginBase/MoEngagePluginBase.entitlements",
            dependencies: [
                .package(product: "MoEngagePluginBase", type: .runtime),
                .package(product: "MoEngagePluginCards", type: .runtime),
                .package(product: "MoEngagePluginGeofence", type: .runtime),
                .package(product: "MoEngagePluginInbox", type: .runtime),
            ],
            settings: .settings(base:defaultSettings)
        ),
    ],
    additionalFiles: ["../Utilities", "../Rakefile", "../LICENSE", "../package.json", "../*.md"],
    resourceSynthesizers: []
)
