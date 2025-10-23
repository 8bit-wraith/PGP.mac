#!/bin/bash

#################################################################################
# PGP.mac Management Script
#
# Your one-stop-shop for all PGP.mac operations!
# Build it, run it, test it, ship it - all with style and color!
#
# Partners: Hue & Aye @ 8b.is
# With special thanks to Trisha from Accounting for insisting on color 🎨
#################################################################################

# Color codes - because life is too short for boring terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Emoji support - because why not?
ROCKET="🚀"
CHECK="✅"
CROSS="❌"
GEAR="⚙️"
BROOM="🧹"
PACKAGE="📦"
TEST="🧪"
LOCK="🔐"
SPARKLES="✨"

#################################################################################
# Helper Functions
#################################################################################

# Print a fancy header
print_header() {
    echo -e "\n${PURPLE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}${SPARKLES}  $1${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════${NC}\n"
}

# Print success message
success() {
    echo -e "${GREEN}${CHECK} $1${NC}"
}

# Print error message
error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

# Print info message
info() {
    echo -e "${BLUE}${GEAR} $1${NC}"
}

# Print warning message
warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

#################################################################################
# Build Functions
#################################################################################

build() {
    print_header "Building PGP.mac"

    info "Resolving Swift package dependencies..."
    swift package resolve

    if [ $? -ne 0 ]; then
        error "Failed to resolve dependencies"
        exit 1
    fi
    success "Dependencies resolved!"

    info "Building the project..."
    swift build

    if [ $? -ne 0 ]; then
        error "Build failed!"
        exit 1
    fi

    success "Build complete! ${ROCKET}"
}

build_release() {
    print_header "Building PGP.mac (Release)"

    info "Resolving Swift package dependencies..."
    swift package resolve

    if [ $? -ne 0 ]; then
        error "Failed to resolve dependencies"
        exit 1
    fi
    success "Dependencies resolved!"

    info "Building release configuration..."
    swift build -c release

    if [ $? -ne 0 ]; then
        error "Release build failed!"
        exit 1
    fi

    success "Release build complete! ${ROCKET}"
}

#################################################################################
# Run Functions
#################################################################################

run() {
    print_header "Running PGP.mac"

    info "Building first..."
    swift build

    if [ $? -ne 0 ]; then
        error "Build failed!"
        exit 1
    fi

    info "Launching PGP.mac..."
    swift run
}

#################################################################################
# Test Functions
#################################################################################

test() {
    print_header "Running Tests ${TEST}"

    info "Running all tests..."
    swift test

    if [ $? -ne 0 ]; then
        error "Tests failed!"
        exit 1
    fi

    success "All tests passed! ${CHECK}"
}

test_verbose() {
    print_header "Running Tests (Verbose) ${TEST}"

    info "Running all tests with verbose output..."
    swift test --verbose

    if [ $? -ne 0 ]; then
        error "Tests failed!"
        exit 1
    fi

    success "All tests passed! ${CHECK}"
}

#################################################################################
# Clean Functions
#################################################################################

clean() {
    print_header "Cleaning Build Artifacts ${BROOM}"

    info "Removing .build directory..."
    rm -rf .build
    success "Build directory cleaned!"

    info "Cleaning Swift package cache..."
    swift package clean
    success "Package cache cleaned!"

    success "All clean! ${SPARKLES}"
}

deep_clean() {
    print_header "Deep Cleaning Everything ${BROOM}"

    info "Removing .build directory..."
    rm -rf .build

    info "Removing Package.resolved..."
    rm -f Package.resolved

    info "Cleaning Swift package..."
    swift package clean

    info "Resetting Swift package..."
    swift package reset

    success "Deep clean complete! Everything is sparkling! ${SPARKLES}"
}

#################################################################################
# Update Functions
#################################################################################

update_deps() {
    print_header "Updating Dependencies ${PACKAGE}"

    info "Updating Swift package dependencies..."
    swift package update

    if [ $? -ne 0 ]; then
        error "Update failed!"
        exit 1
    fi

    success "Dependencies updated! ${CHECK}"
}

#################################################################################
# Format Functions
#################################################################################

format() {
    print_header "Formatting Code ${SPARKLES}"

    if ! command -v swiftformat &> /dev/null; then
        warning "swiftformat not found. Install with: brew install swiftformat"
        exit 1
    fi

    info "Running swiftformat..."
    swiftformat Sources/ Tests/

    success "Code formatted! Looking good! ${SPARKLES}"
}

#################################################################################
# Lint Functions
#################################################################################

lint() {
    print_header "Linting Code"

    if ! command -v swiftlint &> /dev/null; then
        warning "swiftlint not found. Install with: brew install swiftlint"
        exit 1
    fi

    info "Running swiftlint..."
    swiftlint

    if [ $? -ne 0 ]; then
        warning "Linting found issues"
    else
        success "Code looks great! ${CHECK}"
    fi
}

#################################################################################
# App Bundle Functions
#################################################################################

create_app() {
    print_header "Creating App Bundle ${PACKAGE}"

    info "Building release version..."
    swift build -c release

    if [ $? -ne 0 ]; then
        error "Build failed!"
        exit 1
    fi

    APP_NAME="PGP.mac"
    APP_DIR="build/${APP_NAME}.app"

    info "Creating app bundle structure..."
    mkdir -p "${APP_DIR}/Contents/MacOS"
    mkdir -p "${APP_DIR}/Contents/Resources"

    info "Copying executable..."
    cp ".build/release/PGPmac" "${APP_DIR}/Contents/MacOS/${APP_NAME}"

    info "Creating Info.plist..."
    cat > "${APP_DIR}/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>PGP.mac</string>
    <key>CFBundleIdentifier</key>
    <string>is.8b.pgpmac</string>
    <key>CFBundleName</key>
    <string>PGP.mac</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>© 2025 Hue &amp; Aye @ 8b.is</string>
</dict>
</plist>
EOF

    success "App bundle created at ${APP_DIR}! ${ROCKET}"
    info "You can now run: open ${APP_DIR}"
}

#################################################################################
# Help Function
#################################################################################

show_help() {
    print_header "PGP.mac Management Script ${LOCK}"

    echo -e "${WHITE}Usage:${NC} ./manage.sh [command]"
    echo ""
    echo -e "${CYAN}Build Commands:${NC}"
    echo -e "  ${GREEN}build${NC}          Build the project (debug)"
    echo -e "  ${GREEN}release${NC}        Build the project (release)"
    echo -e "  ${GREEN}app${NC}            Create a .app bundle"
    echo ""
    echo -e "${CYAN}Run Commands:${NC}"
    echo -e "  ${GREEN}run${NC}            Build and run the app"
    echo ""
    echo -e "${CYAN}Test Commands:${NC}"
    echo -e "  ${GREEN}test${NC}           Run all tests"
    echo -e "  ${GREEN}test-v${NC}         Run all tests (verbose)"
    echo ""
    echo -e "${CYAN}Clean Commands:${NC}"
    echo -e "  ${GREEN}clean${NC}          Clean build artifacts"
    echo -e "  ${GREEN}deep-clean${NC}     Deep clean everything"
    echo ""
    echo -e "${CYAN}Maintenance Commands:${NC}"
    echo -e "  ${GREEN}update${NC}         Update dependencies"
    echo -e "  ${GREEN}format${NC}         Format code with swiftformat"
    echo -e "  ${GREEN}lint${NC}           Lint code with swiftlint"
    echo ""
    echo -e "${CYAN}Other:${NC}"
    echo -e "  ${GREEN}help${NC}           Show this help message"
    echo ""
    echo -e "${PURPLE}Made with ${RED}❤️${PURPLE} by Hue & Aye @ 8b.is${NC}"
    echo ""
}

#################################################################################
# Main Script
#################################################################################

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    error "Package.swift not found! Are you in the project root?"
    exit 1
fi

# Parse command
case "${1:-help}" in
    build)
        build
        ;;
    release)
        build_release
        ;;
    run)
        run
        ;;
    test)
        test
        ;;
    test-v)
        test_verbose
        ;;
    clean)
        clean
        ;;
    deep-clean)
        deep_clean
        ;;
    update)
        update_deps
        ;;
    format)
        format
        ;;
    lint)
        lint
        ;;
    app)
        create_app
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac

exit 0
