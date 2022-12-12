//
//  LibraryViewModel.swift
//  Doesaegim
//
//  Created by Jaehoon So on 2022/12/12.
//

import Foundation


final class LibraryViewModel: LibraryViewModelProtocol {
    
    var delegate: LibraryViewModelDelegate?
    var licenseInfos: [LibraryInfoViewModel]
    
    init() {
        licenseInfos = [
            LibraryInfoViewModel(
                name: "Firebase",
                version: "9.6.0",
                description:
                """
                Firebase is an app development platform with tools to help you build, grow and
                monetize your app. More information about Firebase can be found on the
                """
            ),
            LibraryInfoViewModel(
                name: "SnapKit",
                version: "5.6.0",
                description:
                """
                SnapKit is a DSL to make Auto Layout easy on both iOS and OS X.
                """
            ),
            LibraryInfoViewModel(
                name: "SwiftProtobuf",
                version: "1.20.3",
                description:
                """
                This project provides both the command-line program that adds Swift code generation to Google's protoc and the runtime library that is necessary for using the generated code.
                After using the protoc plugin to generate Swift code from your .proto files, you will need to add this library to your project.
                """
            ),
            LibraryInfoViewModel(
                name: "Promises",
                version: "2.1.1",
                description:
                """
                Promises is a modern framework that provides a synchronization construct for Objective-C and Swift to facilitate writing asynchronous code.
                """
            ),
            LibraryInfoViewModel(
                name: "nanopb",
                version: "2.30909.0",
                description:
                """
                Nanopb is a small code-size Protocol Buffers implementation in ansi C. It is especially suitable for use in microcontrollers, but fits any memory restricted system.
                """
            ),
            LibraryInfoViewModel(
                name: "leveldb",
                version: "1.22.2",
                description:
                """
                LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.
                """
            ),
            LibraryInfoViewModel(
                name: "GTMSessionFetcher",
                version: "2.3.0",
                description:
                """
                GTMSessionFetcher makes it easy for Cocoa applications to perform http operations. The fetcher is implemented as a wrapper on NSURLSession, so its behavior is asynchronous and uses operating-system settings.
                """
            ),
            LibraryInfoViewModel(
                name: "gRPC",
                version: "1.44.3-grpc",
                description:
                """
                RPC is a modern open source high performance Remote Procedure Call (RPC) framework that can run in any environment. It can efficiently connect services in and across data centers with pluggable support for load balancing, tracing, health checking and authentication.
                """
            ),
            LibraryInfoViewModel(
                name: "GoogleUtilities",
                version: "7.10.0",
                description:
                """
                GoogleUtilities provides a set of utilities for Firebase and other Google SDKs for Apple platform development.
                """
            ),
            LibraryInfoViewModel(
                name: "GoogleDataTransport",
                version: "9.2.0",
                description:
                """
                This library is for internal Google use only. It allows the logging of data and telemetry from Google SDKs.
                """
            ),
            LibraryInfoViewModel(
                name: "GoogleAppMeasurement",
                version: "9.6.0",
                description:
                """
                GoogleAppMeasurement is not supported for direct usage by non-Google libraries. Any issues should be reported to the product that is using GoogleAppMeasurement.
                """
            ),
            LibraryInfoViewModel(
                name: "BoringSSL-GRPC",
                version: "0.9.1",
                description:
                """
                The source here should mirror what is released in the BoringSSL-GRPC CocoaPods used. There should be no changes to this repo other than updates from its mirror and Swift Package Manager specific items.
                
                Versioning should follow normal sem-ver, as dependencies on this package are locked to the patch version. Non breaking edits to the Package manifest alone should be a patch version update.
                """
            ),
            LibraryInfoViewModel(
                name: "abseil",
                version: "0.20220203.2",
                description:
                """
                The repository contains the Abseil C++ library code. Abseil is an open-source collection of C++ code (compliant to C++11) designed to augment the C++ standard library.
                """
            ),
        ]
    }
}

extension LibraryViewModel {
    
    func loadData() {
        delegate?.licenseViewShouldUpdated()
    }
    
}
