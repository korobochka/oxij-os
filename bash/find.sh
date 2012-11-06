#!/bin/bash
# Find script

list()
{
    #if [-d $1] then
        for file in $1*
        do
            echo $file
            if [ -d $file ] 
            then 
                if [ $1 != $file ] 
                then 
                    list $file/
                fi
            fi
        done
    #fi


}

echo "Hello!"
list "/home/korobochka/temp/dmd2/"
echo "World!"
