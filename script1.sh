#!/bin/bash
#Developed by Bogatov Vladimir Vladimirovich

host=localhost
dbuser=Your database user
dbbase=Name of your database
i=1

#Checking for files data(i).txt in the catalog
while [[ -e /local/files/data$i.txt ]] ; do
    let i++
done

#Entering variables to create an SQL query
echo "Enter the required table SQL"
read table
#If we have not entered the FROM condition, then abort the operation and exit the script
if [ "$table" == "" ]
then
    echo "WARNING! SQL FROM condition not entered !"
    exit 1
fi

echo "Enter the required columns SQL"
read dannye
#If we have not entered the SELECT condition, then output all the data from the table
if [ "$dannye" == "" ]
then
    dannye="*"
fi

echo "Enter the required condition SQL"
read uslovie
#If we have not entered the WHERE condition, then output all the data from the table
if [ "$uslovie" == "" ]
then
    uslovie="id=id"
fi

sql_data=$(mysql -h $host -u $dbuser -p $dbbase -e "select "$dannye" from "$table" where "$uslovie"" 2>/dev/null -N -s -B | tr '\t' ' ')
if [ "$sql_data" == "" ]
then
    echo "WARNING! Incorrect data is specified in the SQL query!"
    exit 1
else
    echo "$sql_data" >> data$i.txt
fi

#while [[ -e /local/files/data$i.txt ]] ; do
#    let i++
    if ((i==4))
    then
        for ((c=1; c < 5; c++))
        do
            tar -cf archive$c.tar data$c.txt
            mv archive$c.tar /local/backups/archive$c-$(date +%k:%M:%S-%d_%m_%y).tar
            rm -rf /local/files/data$c.txt
        done
    fi
#done
