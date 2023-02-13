#!/bin/bash

# Check if pacman is installed
if ! command -v pacman &> /dev/null
then
    echo "Pacman is not installed. This script is for Arch Linux systems only."
    exit 1
fi

# Check if rust is installed
if ! command -v rustc &> /dev/null
then
    echo "Installing rust..."
    sudo pacman -S rust
fi

# Check if gtk4 is installed
if ! pacman -Q gtk4 &> /dev/null
then
    echo "Installing gtk4 for rust..."
    sudo pacman -S gtk4 base-devel
fi

# Check if the project is a cargo project
if ! [ -e "Cargo.toml" ]
then
    echo "This is not a cargo project. Please navigate to a cargo project and try again."
    exit 1
fi

# Compile the project in release mode
echo "Compiling project in release mode..."
cargo build --release
if [ $? -ne 0 ]
then
    echo "Compilation failed. Please fix any errors and try again."
    exit 1
fi

echo "Compilation successful."

# Copy the executable file to the project root folder
EXECUTABLE=$(ls target/release/* | head -n 1)
if [ -z "$EXECUTABLE" ]
then
    echo "Executable file not found. Compilation may have failed."
    exit 1
fi

echo "Copying executable file to project root folder..."
cp "$EXECUTABLE" .

echo "Done."
