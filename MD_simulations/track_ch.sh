#!/bin/bash

file=$1 

# chain A 
awk '{if ($3 == "A") {a=1}; if ($3 == "B") {a=2}; if (a==1) {print}}' $file | tail -n 1 > chainA.txt 
# chain B 
awk '{if ($3 == "B") {a=1}; if ($3 == "C") {a=2}; if (a==1) {print}}' $file | tail -n 1 > chainB.txt 
# chain C 
awk '{if ($3 == "C") {a=1}; if ($3 == "A") {a=2}; if (a==1) {print}}' $file | tail -n 1 > chainC.txt 
