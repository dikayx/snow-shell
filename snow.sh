#!/usr/bin/env zsh

# Default configurations
SPEED=4
PARTICLE="*"
COLUMNS=$(tput cols)
ROWS=$(tput lines)
COLORS=("red" "green" "yellow" "blue" "cyan" "white")
COLOR="white"

# Function to clear the screen
clear_screen() {
    tput clear
}

# Function to get a random color from the list
get_random_color() {
    echo "${COLORS[RANDOM % ${#COLORS[@]}]}"
}

# Function to print a character at a specific position
print_character() {
    local row=$1
    local col=$2
    local char=$3
    local color=$4

    tput cup "$row" "$col" # Move cursor to position
    case "$color" in
        "red") echo -ne $'\e[31m'"$char"$'\e[0m' ;;
        "green") echo -ne $'\e[32m'"$char"$'\e[0m' ;;
        "yellow") echo -ne $'\e[33m'"$char"$'\e[0m' ;;
        "blue") echo -ne $'\e[34m'"$char"$'\e[0m' ;;
        "cyan") echo -ne $'\e[36m'"$char"$'\e[0m' ;;
        "white") echo -ne $'\e[37m'"$char"$'\e[0m' ;;
        *) echo -n "$char" ;;
    esac
}

# Function to draw the Christmas tree
draw_christmas_tree() {
    local tree_base_row=$((ROWS - 10))
    local tree_base_col=$((COLUMNS / 2))
    local tree_height=8

    # Draw the tree layers
    for i in {0..7}; do
        local start_col=$((tree_base_col - i))
        local end_col=$((tree_base_col + i))
        for j in $(seq $start_col $end_col); do
            print_character $((tree_base_row + i)) $j "^" "green"
        done
    done

    # Draw the trunk
    local trunk_start=$((tree_base_col - 1))
    local trunk_end=$((tree_base_col + 1))
    for i in {0..1}; do
        for j in $(seq $trunk_start $trunk_end); do
            print_character $((tree_base_row + tree_height + i)) $j "|" "yellow"
        done
    done

    # Add the star on top
    print_character $((tree_base_row - 1)) $tree_base_col "*" "yellow"

    # Add blinking ornaments (random colored balls) within the tree bounds
    for _ in {1..15}; do
        local layer=$((RANDOM % tree_height)) # Random tree layer (0 to tree_height - 1)
        local start_col=$((tree_base_col - layer))
        local end_col=$((tree_base_col + layer))
        local ornament_col=$((start_col + RANDOM % (end_col - start_col + 1)))
        local ornament_row=$((tree_base_row + layer))
        local color=$(get_random_color)
        print_character $ornament_row $ornament_col "o" $color
    done
}

# Function to create snowfall
snowfall() {
    clear_screen

    # Snowflake positions
    declare -A snowflakes

    while true; do
        # Draw the Christmas tree
        draw_christmas_tree

        # Randomly add new snowflakes
        col=$((RANDOM % (COLUMNS - 1) + 1))

        # Add a new snowflake if there's no existing one in that column
        if [[ -z ${snowflakes[$col]} ]]; then
            snowflakes[$col]=1
            print_character 1 $col $PARTICLE $COLOR
        fi

        # Move all snowflakes down
        for key in ${(k)snowflakes}; do
            row=${snowflakes[$key]}
            print_character $row $key " " $COLOR  # Erase the old snowflake

            # Move snowflake down if it's not at the bottom
            if (( row < ROWS - 1 )); then
                snowflakes[$key]=$((row + 1))
                print_character $((row + 1)) $key $PARTICLE $COLOR
            else
                # Reset the snowflake to the top after it reaches the bottom
                snowflakes[$key]=1
                print_character 1 $key $PARTICLE $COLOR
            fi
        done

        sleep $((1.0 / SPEED))
    done
}

# Run snowfall
snowfall

# TODO: Add a bottom layer of snow on the ground
# TODO: Make the snowflakes fall slower than the tree ornaments blink
# TODO: Hide snowflakes if they are behind the tree
