#!/bin/bash

# Lisa Plugin Setup Script
# Automates installation of Lisa for Claude Code
# Supports: macOS, Linux, WSL

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Progress indicators
print_step() {
    echo -e "\n${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew (macOS only)
install_homebrew() {
    if ! command_exists brew; then
        print_step "Installing Homebrew (macOS package manager)..."
        print_info "This will ask for your password - this is normal and safe"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        print_success "Homebrew installed"
    fi
}

# Install git
install_git() {
    if ! command_exists git; then
        print_step "Installing git..."

        if [[ "$OS" == "macos" ]]; then
            brew install git
        elif [[ "$OS" == "linux" ]]; then
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y git
            elif command_exists yum; then
                sudo yum install -y git
            else
                print_error "Could not install git. Please install manually: https://git-scm.com/downloads"
                exit 1
            fi
        fi

        print_success "git installed"
    else
        print_success "git already installed ($(git --version))"
    fi
}

# Install Python 3
install_python() {
    if ! command_exists python3; then
        print_step "Installing Python 3..."

        if [[ "$OS" == "macos" ]]; then
            brew install python3
        elif [[ "$OS" == "linux" ]]; then
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y python3 python3-pip
            elif command_exists yum; then
                sudo yum install -y python3 python3-pip
            else
                print_error "Could not install Python. Please install manually: https://www.python.org/downloads/"
                exit 1
            fi
        fi

        print_success "Python 3 installed"
    else
        PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
        print_success "Python 3 already installed (v$PYTHON_VERSION)"

        # Check version is 3.8+
        PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
        PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

        if [[ "$PYTHON_MAJOR" -lt 3 ]] || [[ "$PYTHON_MAJOR" -eq 3 && "$PYTHON_MINOR" -lt 8 ]]; then
            print_warning "Python version is below 3.8. Lisa requires Python 3.8+"
            print_info "Attempting to upgrade..."

            if [[ "$OS" == "macos" ]]; then
                brew upgrade python3
            elif [[ "$OS" == "linux" ]]; then
                if command_exists apt-get; then
                    sudo apt-get update && sudo apt-get upgrade -y python3
                fi
            fi
        fi
    fi
}

# Install jq
install_jq() {
    if ! command_exists jq; then
        print_step "Installing jq (JSON processor)..."

        if [[ "$OS" == "macos" ]]; then
            brew install jq
        elif [[ "$OS" == "linux" ]]; then
            if command_exists apt-get; then
                sudo apt-get update && sudo apt-get install -y jq
            elif command_exists yum; then
                sudo yum install -y jq
            else
                print_error "Could not install jq. Please install manually: https://jqlang.github.io/jq/"
                exit 1
            fi
        fi

        print_success "jq installed"
    else
        print_success "jq already installed ($(jq --version))"
    fi
}

# Install Node.js and npm
install_node() {
    if ! command_exists node; then
        print_step "Installing Node.js (required for Claude Code CLI)..."

        if [[ "$OS" == "macos" ]]; then
            brew install node
        elif [[ "$OS" == "linux" ]]; then
            # Install Node.js 20.x
            if command_exists apt-get; then
                print_info "Setting up Node.js repository..."
                curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
                sudo apt-get install -y nodejs
            elif command_exists yum; then
                curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
                sudo yum install -y nodejs
            else
                print_error "Could not install Node.js. Please install manually: https://nodejs.org/"
                exit 1
            fi
        fi

        print_success "Node.js installed"
    else
        NODE_VERSION=$(node --version)
        print_success "Node.js already installed ($NODE_VERSION)"
    fi

    # Verify npm is available
    if ! command_exists npm; then
        print_error "npm not found. Please reinstall Node.js: https://nodejs.org/"
        exit 1
    fi
}

# Install Claude Code CLI
install_claude_code() {
    if ! command_exists claude; then
        print_step "Installing Claude Code CLI..."
        print_info "This may take a minute..."

        npm install -g @anthropic-ai/claude-code

        if command_exists claude; then
            print_success "Claude Code CLI installed"
        else
            print_warning "Claude Code CLI installation completed, but 'claude' command not found"
            print_info "You may need to restart your terminal or add npm global bin to PATH"
            print_info "Try running: export PATH=\"\$(npm config get prefix)/bin:\$PATH\""
        fi
    else
        print_success "Claude Code CLI already installed ($(claude --version 2>&1 || echo 'installed'))"
    fi
}

# Clone or update Lisa repository
setup_lisa_repo() {
    print_step "Setting up Lisa plugin..."

    TEMP_DIR="/tmp/lisa-plugin-install"

    # Clean up any previous install attempts
    rm -rf "$TEMP_DIR"

    # Clone repository
    print_info "Downloading Lisa from GitHub..."
    git clone https://github.com/kenziecreative/lisa.git "$TEMP_DIR" 2>/dev/null || {
        print_error "Failed to clone repository. Check your internet connection."
        exit 1
    }

    # Create Claude plugins directory if it doesn't exist
    mkdir -p "$HOME/.claude/plugins"

    # Copy Lisa to plugins directory
    print_info "Installing Lisa to ~/.claude/plugins/lisa..."

    if [ -d "$HOME/.claude/plugins/lisa" ]; then
        print_warning "Existing Lisa installation found. Backing up to ~/.claude/plugins/lisa.backup..."
        rm -rf "$HOME/.claude/plugins/lisa.backup"
        mv "$HOME/.claude/plugins/lisa" "$HOME/.claude/plugins/lisa.backup"
    fi

    cp -r "$TEMP_DIR" "$HOME/.claude/plugins/lisa"

    # Clean up temp directory
    rm -rf "$TEMP_DIR"

    print_success "Lisa plugin copied to ~/.claude/plugins/lisa"
}

# Install Python dependencies
install_python_deps() {
    print_step "Installing Python dependencies..."

    cd "$HOME/.claude/plugins/lisa"

    if [ -f "scripts/requirements.txt" ]; then
        pip3 install -r scripts/requirements.txt --quiet
        print_success "Python dependencies installed (textstat, beautifulsoup4, markdown)"
    else
        print_error "requirements.txt not found. Installation may be incomplete."
        exit 1
    fi
}

# Verify installation
verify_installation() {
    print_step "Verifying installation..."

    local all_good=true

    # Check Python dependencies
    if python3 -c "import textstat, bs4, markdown" 2>/dev/null; then
        print_success "Python dependencies verified"
    else
        print_error "Python dependencies missing"
        all_good=false
    fi

    # Check Lisa plugin directory
    if [ -d "$HOME/.claude/plugins/lisa" ]; then
        print_success "Lisa plugin directory exists"
    else
        print_error "Lisa plugin directory not found"
        all_good=false
    fi

    # Check for key Lisa files
    if [ -f "$HOME/.claude/plugins/lisa/.claude-plugin/plugin.json" ]; then
        print_success "Lisa plugin configuration found"
    else
        print_error "Lisa plugin configuration missing"
        all_good=false
    fi

    if [ "$all_good" = true ]; then
        return 0
    else
        return 1
    fi
}

# Main installation flow
main() {
    clear
    echo ""
    echo "╔════════════════════════════════════════╗"
    echo "║                                        ║"
    echo "║   Lisa Plugin Setup for Claude Code    ║"
    echo "║                                        ║"
    echo "╚════════════════════════════════════════╝"
    echo ""

    print_info "This script will install everything needed to run Lisa"
    print_info "You may be asked for your password - this is normal"
    echo ""

    # Detect operating system
    detect_os

    if [[ "$OS" == "unknown" ]]; then
        print_error "Unsupported operating system: $OSTYPE"
        print_info "Please install manually. See: https://github.com/kenziecreative/lisa"
        exit 1
    fi

    print_info "Detected OS: $OS"
    echo ""

    # Install prerequisites
    if [[ "$OS" == "macos" ]]; then
        install_homebrew
    fi

    install_git
    install_python
    install_jq
    install_node
    install_claude_code

    # Set up Lisa
    setup_lisa_repo
    install_python_deps

    # Verify everything works
    echo ""
    if verify_installation; then
        echo ""
        echo "╔════════════════════════════════════════╗"
        echo "║                                        ║"
        echo "║   ✓ Lisa Installation Complete!        ║"
        echo "║                                        ║"
        echo "╚════════════════════════════════════════╝"
        echo ""
        print_success "Lisa is ready to use with Claude Code"
        echo ""
        print_info "Next steps:"
        echo "  1. Create a campaign brief (see examples/)"
        echo "  2. Run: claude code"
        echo "  3. Use Lisa slash commands: /marketing, /pr, or /branding"
        echo ""
        print_info "Documentation: https://github.com/kenziecreative/lisa"
        print_info "Need help? Check the troubleshooting guide in the README"
        echo ""
    else
        echo ""
        print_error "Installation verification failed"
        print_info "Some components may not have installed correctly"
        print_info "Please check the errors above and try again"
        print_info "Or install manually: https://github.com/kenziecreative/lisa"
        echo ""
        exit 1
    fi
}

# Run main installation
main
