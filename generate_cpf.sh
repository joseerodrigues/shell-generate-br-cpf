#!/bin/bash

# Check if the user provided three digits
if [[ $# -ne 1 || ! $1 =~ ^[0-9]{3}$ ]]; then
    echo "Usage: $0 <first_three_digits>"
    echo "Please provide the first three digits (0-999) of the CPF."
    exit 1
fi

first_three_digits=$1

generate_random_digits() {
    # Generate six random digits (0-9)
    for i in {1..6}; do
        echo -n $(( RANDOM % 10 ))
    done
}

generate_cpf() {
    # Start with the provided first three digits
    local cpf="${first_three_digits}"

    # Append 6 random digits
    local random_digits=$(generate_random_digits)
    cpf+="${random_digits}"

    # Calculate the first verifier digit
    local sum=0
    for i in {0..8}; do
        sum=$((sum + ${cpf:i:1} * (10 - i)))
    done
    local first_digit=$(( (sum * 10) % 11 ))
    if [[ $first_digit -ge 10 ]]; then
        first_digit=0
    fi

    # Append the first verifier digit
    cpf+=$first_digit

    # Calculate the second verifier digit
    sum=0
    for i in {0..9}; do
        sum=$((sum + ${cpf:i:1} * (11 - i)))
    done
    local second_digit=$(( (sum * 10) % 11 ))
    if [[ $second_digit -ge 10 ]]; then
        second_digit=0
    fi

    # Append the second verifier digit
    cpf+=$second_digit

    # Format and print the CPF
    echo "$cpf"
}

# Generate and display a valid CPF
CPF=$(generate_cpf)
echo "Generated CPF: $CPF"