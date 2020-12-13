# Modular Architecture on iOS
Building Large Scale Modular iOS Apps And Frameworks

# Dedication 
"To my Mom and Dad, because they really tried."

&&

"To all my non-tech friends whom I am fixing problems with not enough disk space, printers, forgotten passcodes etc."

&&

"To all passionate engineers who are solving tough problems on a daily basis with a smile, it is great pleasure for everyone to work with you!"

&&

"Finally, to whoever my current girlfriend is..."

# What is this book about?
This book describes essentials about building modular architecture on iOS. You will find examples of different approaches, framework types, pros and cons, common problems and so on. By the end of this book you should have a very good understanding of what benefits will bring such architecture to your project, whether it is necessary at all or which would be the best way for modularising your project.

At the end of this book, you can read experiences from top notch iOS engineers working across numerous different projects.

# About the author
Cyril Cermak is a software engineer by heart and author of this book. Most of his professional career was spent by building iOS apps or iOS frameworks. Beginning by Skoda Auto Connect App in Prague, continuing building iOS platform for Freelancer Ltd in Sydney and as of now being an iOS TechLead in Stuttgart for Porsche AG. In this book, Cyril describes different approaches for building modular iOS architecture so as some mechanisms and essential knowledge that should help you, the reader, to decide which approach would fit in the best or should be considered on your project.

## Reviewers
Joerg Nestele
... Ask Joerg whether he wants do be the reviewer. 

# Table Of Contents
- Introduction
- Modular Architecture 
  - Motivation
  - Workflow
  - Scalability
  - Pros And Cons
  - Limitations 
    - Monolit
    - Modularity
    
- Highlevel Overview
  - Architecture
  - Layers
    - App Layer
    - Domain Layer
    - Service Layer
    - Core Layer
    - Shared Layer
  - Ground Rules
  - Application Framework
    - Distribution 
    - The Software Foundation
    
- Frameworks on iOS
  - Dynamic
  - Static
  - Linker and Compiler
    
- Dependency Managers
  - Cocopods
  - Carthage
  - SwiftPM
    
- Development
  - Dynamic CocoaTouch Framework
  - Workspace and projects
      - xcodegen
  - Contributions 
    - Mono-repository 
    - Versionised frameworks
  - Common Problems
  - Handling Secrets
    - Mobile Secrets
  
- Distribution
  - Frameworks
  - XCFrameworks
  - Static Library
  - Open sourcing
  
- Project Automation
  - Motivation
  - Fastlane
  - Translations, Stages, Configurations etc.
  - Ruby

- CI/CD
  - Scripts execution

- GitFlow

- Profesional Experience
  - Joerg Nestele: iOS Tech Lead - Porsche AG
  - Majd Alfhailly: Senior iOS Engineer - Blinkst
  - Daniel Williams: Senior iOS Engineer - Canva
  - Aldrich Co: iOS Tech Lead - Freelancer Ltd.
  - Gleb Arkhipov: iOS Tech Lead - STRV
  
# Introduction





