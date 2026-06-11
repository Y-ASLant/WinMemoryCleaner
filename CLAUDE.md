# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Windows Memory Cleaner (WMC) is a free, portable RAM optimization tool that uses native Windows API functions to clean memory areas. It requires administrator privileges and supports Windows XP through 11 (and Server 2003-2025).

## Build Commands

```powershell
# Restore NuGet packages
nuget restore src\WinMemoryCleaner.sln

# Build (Release)
msbuild src\WinMemoryCleaner.sln /m /p:Configuration=Release /p:Platform="Any CPU"

# Build (Debug)
msbuild src\WinMemoryCleaner.sln /m /p:Configuration=Debug /p:Platform="Any CPU"

# Run tests
src\packages\NUnit.Runners.2.6.4\tools\nunit-console.exe src\bin\Release\WinMemoryCleaner.exe /xml:TestResults.xml
```

## Architecture

- **Target Framework**: .NET Framework 4.0 (C# language version 4)
- **UI Framework**: WPF with MVVM pattern
- **Tests**: NUnit 2.6.4 (tests are embedded in the main assembly under `src\Test\`)

### Key Layers

- `Core/` - Cross-cutting concerns: IoC container (`DependencyInjection`), settings, localization, logging, theme management
- `Model/` - Domain models: Computer, Memory stats, OperatingSystem info
- `Service/` - Business logic: `ComputerService` (memory operations), `HotkeyService`, `NotificationService`
- `ViewModel/` - MVVM view models: `MainViewModel` is the primary orchestrator
- `View/` - WPF windows and controls (MainWindow, DonationWindow, TrayIconContextMenu)
- `Interop/` - P/Invoke declarations for Windows API (NativeMethods, ShellInterop)
- `WindowsService/` - Windows Service support for background operation

### Dependency Injection

Uses a custom lightweight IoC container in `Core\DependencyInjection.cs`. Services are registered and resolved via `DependencyInjection.Container`.

### Memory Optimization

The core functionality calls Windows API functions via P/Invoke to clean specific memory areas (CombinedPageList, ModifiedFileCache, StandbyList, etc.). Each area has minimum Windows version requirements defined in `Core\Enums.cs`.

## Code Style

- XML documentation comments on all public members
- `#region` blocks for code organization
- Warnings treated as errors (`TreatWarningsAsErrors=true`)
- Code analysis enabled with FxCop analyzers
