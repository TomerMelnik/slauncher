#!/bin/bash

# Welcome screen message
welcome_message="Welcome to the SLURM Interactive Job Launcher\n\n\
This script helps you request an interactive SLURM job by selecting the following resources:\n\
1. Number of CPUs\n\
2. Number of GPUs\n\
3. GPU type (default is any)\n\n\
Press any key to start selecting your resources."

# Show the welcome message using fzf (it will proceed once the user presses a key)
echo -e "$welcome_message" | fzf --height=40% --layout=reverse --info=inline --border --margin=1 --prompt="Press any key to continue: " --expect=enter > /dev/null

# Define available CPU and GPU options
cpu_options="1\n2\n4\n8\n16"
gpu_options="0\n1\n2\n4"

# Extract GPU types from the command and filter out '(null)' entries
gpu_types=$(scontrol show nodes | grep "Gres=gpu" | grep -v "(null)" | awk -F"=" '{print $2}' | awk -F":" '{print $2}' | sort | uniq)
gpu_type_options="any\n$(echo "$gpu_types" | uniq)"

# Select number of CPUs using fzf
cpu=$(echo -e "$cpu_options" | fzf --height=40% --layout=reverse --info=inline --border --margin=1 --prompt="Select number of CPUs: ")

# Select number of GPUs using fzf
gpu=$(echo -e "$gpu_options" | fzf --height=40% --layout=reverse --info=inline --border --margin=1 --prompt="Select number of GPUs: ")

# Select GPU type using fzf (default: any)
gpu_type=$(echo -e "$gpu_type_options" | fzf --height=40% --layout=reverse --info=inline --border --margin=1 --prompt="Select GPU type (default: any): ")

# Check if user made a selection
if [ -z "$cpu" ] || [ -z "$gpu" ]; then
    echo "Selection canceled."
    exit 1
fi

# Construct the SLURM options depending on the GPU type
if [ "$gpu_type" == "any" ]; then
    # If GPU type is 'any', don't specify the type
    echo "Requesting interactive job with $cpu CPUs and $gpu GPUs"
    srun --cpus-per-task="$cpu" --gres=gpu:"$gpu" --pty bash
else
    # If GPU type is selected, include it in the request
    echo "Requesting interactive job with $cpu CPUs, $gpu GPUs of type $gpu_type"
    srun --cpus-per-task="$cpu" --gres=gpu:"$gpu_type:$gpu" --pty bash
fi

