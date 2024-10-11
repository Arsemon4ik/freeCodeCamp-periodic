#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
input_arg="$1"

if [[ -z $input_arg ]]; then
  echo "Please provide an element as an argument."
  exit
fi

get_data() {
  
  # if input is a number
  if [[ "$input_arg" =~ ^-?[0-9]+$ ]]; then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$input_arg;")
  # if input is a character or a string
  elif [[ "$input_arg" =~ ^[a-zA-Z]+$ ]]; then
    ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$input_arg' or name='$input_arg';")
  fi

    
  # If the atomic number doesn't exist, output error
  if [[ -z "$ATOMIC_NUMBER" ]]; then
    echo "I could not find that element in the database."
    exit
  fi

  # get data from DB
  SYMBOL=$($PSQL "select symbol from elements where atomic_number=$ATOMIC_NUMBER;")
  NAME=$($PSQL "select name from elements where atomic_number=$ATOMIC_NUMBER;")
  MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ATOMIC_NUMBER;")
  MELTING_POINT=$($PSQL "select melting_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
  BOILING_POINT=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ATOMIC_NUMBER;")
  TYPE_ID=$($PSQL "select type_id from properties where atomic_number=$ATOMIC_NUMBER;")
  TYPE=$($PSQL "select type from types where type_id=$TYPE_ID;")

  # return output
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

}

get_data
