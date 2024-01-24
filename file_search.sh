#!/bin/bash

DATABASE="file_database.csv"

search_file() {
    local filename="$1"

    grep -q ",$filename," "$DATABASE"
    local found_in_database=$?

     if [ $found_in_database -eq 0 ]; then
        echo "Van ilyen fajl az adatbazisban:"
        cat "$DATABASE" | grep ",$filename,"
    else
        echo "Nincs ilyen fajl az adatbazisban kereses a teljes rendszerben"
        search_result=$(find / -type f -name "$filename" 2>/dev/null | head -n 1)

        if [ -n "$search_result" ]; then
            echo "Fajl megtalalva a teljes rendszerben:"
            file_info=$(stat -c "%n,%F,%s,%U" "$search_result")
            echo "$file_info"

            echo "$file_info" >>"$DATABASE"
            echo "Az adatbazis frissitve."
        else
            echo "A keresett fajl nem talalhato."
        fi
    fi
}


if [ $# -eq 0 ]; then
    echo "Nem adott meg parametert: $0 <fajl_neve>"
    exit 1
fi

filename="$1"
search_file "$filename"
