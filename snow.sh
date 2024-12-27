#!/usr/bin/env zsh

# Default configurations
SPEED=14
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

# Function to create snowfall
snowfall() {
    clear_screen

    # Snowflake positions
    declare -A snowflakes

    while true; do
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

# TODO: Color change doesn't work right now. Fix it. (example: ./snow.sh --speed 20 --particle "*" --color "cyan")
# TODO: Add a chistmas tree at the bottom center of the screen. Should be green with random colored balls that blink and a star on top.
