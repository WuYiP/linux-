#!/bin/bash
#备份文件，并把所有非相关文件和文件夹删除。
#
oldIFS=$IFS
IFS=$(echo -en "\n\b")
function diff1(){
files=$(ls "$1")
for file in $files
do
  filepath=$1/${file}
  file_desc=$2/${file}
  if [ -f  "$filepath" ] 
  then
	echo 22
    diff -arq  "${filepath}" "${file_desc}" 1>/dev/null 2>&1 && result=0 || result=1
      echo 33
	  if [ "$result" == 1 ];then
          cp "$filepath" "$file_desc"
      else
          echo $file_desc 'is the same'
      fi
  else

	if [ -d "$filepath" ] 
	then
	mkdir -p "$file_desc"
    diff1 "$filepath" "$file_desc"
	fi
  fi
done
}

function rm1(){
files=$(ls "$1")
for file in $files
do
  filepath=$1/${file}
  file_desc=$2/${file}
  if [ ! -f  "$file_desc" ] 
  then
	if [ -d "$file_desc" ]
	then
	rm1 "$filepath" "$file_desc"
	else
	rm -rf "$filepath"
	fi
 fi
done
}

if [ $# -lt 2 ];then
    echo "no backup list"
else
	a=($@)                      #由$@取到所有参数,并将参数存入a
	for i in ${a[@]};do               #使用i在各个参数中循环
	  if [ "$i" = "$1" ]
	  then
	  echo 'this is' $1
	  else
		if [ -d $i ] 
		then
		  filename=$(basename $i)
		  path="$1/$filename"
		  mkdir -p "$path"
		  echo 11 
		  diff1 $i $path 
		  rm1   $path $i
		  shell="|grep -v"
		  fileold="$shell \"$filename\"" 
		  rmfile="$rmfile $fileold"
		else 
		  echo $i 'is no exist'
		fi
	 fi
	done  
	echo $rmfile
	cd $1
	shell="ls $rmfile|xargs rm -rf"
	echo $shell
	eval $shell
fi
IFS=$oldIFS