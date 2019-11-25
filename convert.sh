#!/bin/bash
for file in ./data/*
do
    if test -f $file
    then
        if [ "${file##*.}" = "pimg" ];
        then
            ./expimg.exe $file
        fi
    fi
done

for file in ./data/*
do
    if test -f $file
    then
        if [ "${file##*.}" = "tlg" ];
        then
            ./tlg2png $file "${file%.*}.png"
        fi
    fi
done

for file in ./data/*
do
    if test -f $file
    then
        if [ "${file##*.}" = "txt" ];
        then
            ./merge_pimg.pl $file
        fi
    fi
done
