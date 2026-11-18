import ProjectDescription

let deploymentTarget: DeploymentTargets = .iOS("18.0")
let developmentTeam = "6P8L9SND3U"

// Every bundle id and the App Group come from this prefix, the same way Flourish does it.
let bundleIdPrefix = "com.renaissance.montessorikeyboard"
let appGroupId = "group.\(bundleIdPrefix)"
let marketingVersion = "1.0.0"

let baseSettings: SettingsDictionary = [
    "SWIFT_VERSION": "6.0",
    "DEVELOPMENT_TEAM": SettingValue(stringLiteral: developmentTeam),
    "CODE_SIGN_STYLE": "Automatic",
    "MARKETING_VERSION": SettingValue(stringLiteral: marketingVersion),
    "CURRENT_PROJECT_VERSION": "1",
    "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
    "SWIFT_STRICT_CONCURRENCY": "complete",
    "ASSETCATALOG_COMPILER_GENERATE_ASSET_SYMBOLS": "NO",
    "TARGETED_DEVICE_FAMILY": "1,2",
]

let fonts: [ResourceFileElement] = ["Sources/Shared/Fonts/*.otf", "Sources/Shared/Fonts/*.ttf"]
let fontList: Plist.Value = .array([
    "AlloLearner-Regular.otf", "AlloLearner-Medium.otf", "AlloLearner-SemiBold.otf", "AlloLearner-Bold.otf",
    "PlaywriteUSTrad.ttf",
])

let appInfoPlist: InfoPlist = .extendingDefault(with: [
    "CFBundleDisplayName": "Montessori Keyboard",
    "CFBundleShortVersionString": "$(MARKETING_VERSION)",
    "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
    "ITSAppUsesNonExemptEncryption": false,
    "LSRequiresIPhoneOS": true,
    "NSFaceIDUsageDescription": "Face ID lets a grown-up open the keyboard's settings.",
    "UIAppFonts": fontList,
    "UILaunchScreen": .dictionary([
        "UIColorName": "LaunchBackground"
    ]),
    "UISupportedInterfaceOrientations": .array(["UIInterfaceOrientationPortrait"]),
    "UISupportedInterfaceOrientations~ipad": .array([
        "UIInterfaceOrientationPortrait",
        "UIInterfaceOrientationPortraitUpsideDown",
        "UIInterfaceOrientationLandscapeLeft",
        "UIInterfaceOrientationLandscapeRight",
    ]),
])

let project = Project(
    name: "MontessoriKeyboard",
    organizationName: "Renaissance",
    options: .options(
        automaticSchemesOptions: .disabled,
        developmentRegion: "en"
    ),
    settings: .settings(base: baseSettings),
    targets: [
        // Pure Swift: layouts, colors, rhymes, phonograms, number words, settings. No UIKit, so it tests fast.
        .target(
            name: "MontessoriCore",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).core",
            deploymentTargets: deploymentTarget,
            sources: ["Sources/Core/**"]
        ),
        // The SwiftUI keyboard, shared by the extension and the app's preview and Pad.
        .target(
            name: "MontessoriUI",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "\(bundleIdPrefix).ui",
            deploymentTargets: deploymentTarget,
            sources: ["Sources/UI/**"],
            dependencies: [.target(name: "MontessoriCore")]
        ),
        .target(
            name: "Keyboard",
            destinations: .iOS,
            product: .appExtension,
            productName: "Keyboard",
            bundleId: "\(bundleIdPrefix).keyboard",
            deploymentTargets: deploymentTarget,
            infoPlist: .file(path: "Sources/Keyboard/Info.plist"),
            sources: ["Sources/Keyboard/**/*.swift"],
            resources: .resources(fonts + ["Sources/Keyboard/PrivacyInfo.xcprivacy"]),
            entitlements: .file(path: "Sources/Keyboard/Keyboard.entitlements"),
            dependencies: [
                .target(name: "MontessoriCore"),
                .target(name: "MontessoriUI"),
            ],
            settings: .settings(base: [
                "APPLICATION_EXTENSION_API_ONLY": "YES"
            ])
        ),
        .target(
            name: "MontessoriKeyboard",
            destinations: .iOS,
            product: .app,
            productName: "MontessoriKeyboard",
            bundleId: bundleIdPrefix,
            deploymentTargets: deploymentTarget,
            infoPlist: appInfoPlist,
            sources: ["Sources/App/**/*.swift"],
            resources: .resources(fonts + ["Sources/App/Assets.xcassets", "Sources/App/PrivacyInfo.xcprivacy"]),
            entitlements: .file(path: "Sources/App/MontessoriKeyboard.entitlements"),
            dependencies: [
                .target(name: "MontessoriCore"),
                .target(name: "MontessoriUI"),
                .target(name: "Keyboard"),
            ],
            settings: .settings(base: [
                "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": "AccentColor",
            ])
        ),
        .target(
            name: "CoreTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleIdPrefix).coretests",
            deploymentTargets: deploymentTarget,
            sources: ["Tests/CoreTests/**"],
            dependencies: [.target(name: "MontessoriCore")]
        ),
    ],
    schemes: [
        .scheme(
            name: "MontessoriKeyboard",
            shared: true,
            buildAction: .buildAction(targets: ["MontessoriKeyboard"]),
            testAction: .targets(["CoreTests"]),
            runAction: .runAction(executable: "MontessoriKeyboard")
        ),
        .scheme(
            name: "Keyboard",
            shared: true,
            buildAction: .buildAction(targets: ["Keyboard"]),
            runAction: .runAction(executable: "MontessoriKeyboard")
        ),
    ]
)
