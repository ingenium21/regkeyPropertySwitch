<#
Author: Renato Regalado
Date: 05/17/2019
Description: Switches the first number of the DWORD name from 1 to 2 and vice versa
#>

#set the path of the key whose properties you want to edit
$path = "HKCU:\Software\Microsoft\Shared Tools\Proofing Tools\1.0\Custom Dictionaries\"

#set this variable and use the -expandProperty parameter of select-object to only get the properties' names
$properties = get-item -Path $path | Select-Object -ExpandProperty Property

#create two arrays of the two different types of properties
$1_properties = $properties | Select-String "1_"
$2_properties = $properties | Select-string "2_"

<#use foreach to iterate through the array, create a string variable of the item, createa  new string variable that replaces it
then use rename-itemProperty to renmae it with the new string variable#>

foreach ($i in $1_properties){
    [string] $stringvar1 = $i
    $newStringVar1 = $stringvar1.replace("1_","1a_")
    Rename-ItemProperty -Path $path -Name $stringvar1 -NewName $newStringVar1
}

#we changed 1_ to 1a_ to avoid duplicates causing the 2_'s to disappear

foreach ($j in $2_properties) {
    [string] $stringvar2 = $j
    $newStringVar2 = $stringvar2.replace("2_","1_")
    Rename-ItemProperty -Path $path -Name $stringvar2 -NewName $newStringVar2
}

# Refreshing $properties variable as the values have changed
$properties = get-item -Path $path | Select-Object -ExpandProperty Property

# Getting new 1a_ prefix values
$1a_properties = $properties | Select-String "1a_"

#running last foreach loop to replace 1a_ to 2_
foreach ($i in $1a_properties){
    [string] $stringvar3 = $i
    $newStringVar3 = $stringvar3.replace("1a_","2_")
    Rename-ItemProperty -Path $path -Name $stringvar3 -NewName $newStringVar3
}
