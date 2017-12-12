# Welcome!
This project is for my own personal website for hosting projects, using as a sandbox, as a blog, or whatever purpouse I can find. Mainly, to learn.

## Scaffolded Swift Kitura server application

[![](https://img.shields.io/badge/bluemix-powered-blue.svg)](https://bluemix.net)
[![Platform](https://img.shields.io/badge/platform-swift-lightgrey.svg?style=flat)](https://developer.ibm.com/swift/)

### Table of Contents
* [Summary](#summary)
* [Requirements](#requirements)
* [Project contents](#project-contents)
* [Configuration](#configuration)
* [Run](#run)
* [Generator](#generator)

### Summary
This scaffolded application provides a starting point for creating Swift applications running on [Kitura](https://developer.ibm.com/swift/kitura/).

### Requirements
* [Swift 4](https://swift.org/download/)

### Project contents
This application has been generated with the following capabilities and services:

* [CloudConfiguration](#configuration)
* [Embedded metrics dashboard](#embedded-metrics-dashboard)

#### Embedded metrics dashboard
This application uses the [SwiftMetrics package](https://github.com/RuntimeTools/SwiftMetrics) to gather application and system metrics.

These metrics can be viewed in an embedded dashboard on `/swiftmetrics-dash`. The dashboard displays various system and application metrics, including CPU, memory usage, HTTP response metrics and more.

### Configuration
Your application configuration information is stored in the `config.json` in the project root directory. This file is in the `.gitignore` to prevent sensitive information from being stored in git.

The connection information for any configured services, such as username, password and hostname, is stored in this file.

The application uses the [CloudConfiguration package](https://github.com/IBM-Swift/CloudConfiguration) to read the connection and configuration information from the environment and this file.

### Run
To build and run the application:
1. `swift build`
1. `.build/debug/website`

**NOTE**: On macOS you will need to add options to the `swift build` command: `swift build -Xlinker -lc++`

### Generator
This project was generated with [generator-swiftserver](https://github.com/IBM-Swift/generator-swiftserver) v4.2.0.
