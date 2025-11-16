#!/bin/bash

pkill ollama

start_ollama() {
    echo "Starting Ollama server..."
    ollama serve &  # Run in the background
    sleep 1  # Give it a moment to initialize
}

run_model() {
    local model=$1
    echo "Running model: $model"
    ollama run "$model"
}

# Start the server
start_ollama

# Display the menu
display_menu() {    
    # Fetch the list of models and store them in an array
    models=($(ollama list | awk 'NR > 1 {print $1}'))

    # Check if there are any models available
    if [ ${#models[@]} -eq 0 ]; then
      echo "No models available."
      exit 1
    fi

    echo "Available models:"
    for i in {1..${#models[@]}}; do
      echo "$i) ${models[$i]}"
    done

    echo -n "Pick the model you want to run: "
    read selection

    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#models[@]} ]; then
      echo "Invalid selection. Please enter a number between 1 and ${#models[@]}."
      exit 1
    fi

    # Get the selected model name
    selected_model=${models[$selection]}

    run_model "$selected_model"
}

# Check for -s flag
if [[ "$1" == "-s" ]]; then
    display_menu
else
    clear
    run_model qwen3:1.7b
fi
