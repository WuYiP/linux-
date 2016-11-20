#!/bin/bash

oldIFS=$IFS
IFS=$(echo -en "\n\b")
#支持文件含有空格的

n=0
m=0	
if [ $# -lt 2 ] 
#参数个数小于2
then 
    echo "no file in backup"
    exit 1
fi

if [ ! -f  "/tmp/a.txt" ]   
#如果不存在a.txt文本的话,就copy文件到备份文件夹中
then
	for i in $@
    do
	    if  [ "$i" = "$1" ] 
		#设第一个参数是备份路径
		then
		    echo $1 "is backup"
		else 
		    if [ ! -e $i ]   
			#参数路径不存在的情况下
			then
		    echo $i "is no exit"
			else
			#先清空备份目录再进行备份
			    rm -rf $1/*
		        path1="$1$i"
				mkdir -p $path1
				path1=$(dirname $path1)
				
				cp -r $i $path1
				if [ $n -eq 0 ]  
				#第二个参数保存在a.txt中
				then              
					echo $i > /tmp/a.txt
					n=$((n+1))
				else             
				#后面的参数追加保存在a.txt中
                    echo $i >> /tmp/a.txt	
                fi
            fi				
		fi	
    done
else
#如果存在a.txt文本的话,就把传入的参数存到b.txt文本中

	for i in $@
    do
	    if  [ "$i" = "$1" ] 
		#设第一个参数是备份路径
		then
		    echo $1 "is backup"
		else 
		    if [ ! -e $i ]   
			#参数路径不存在的情况下
			then
		    echo $i "is no exit"
			else
			#传入的参数写入b.txt文本中
		       
				if [ $m -eq 0 ] 
				then
					echo $i > /tmp/b.txt
					m=$((m+1))
				else
					echo $i >> /tmp/b.txt
				fi
				
			fi
                           			
		fi
    done
        #统计a.txt和b.txt文本内容的数量	
        num1=$(cat "/tmp/a.txt"|wc -l)  
		num2=$(cat "/tmp/b.txt"|wc -l) 
		if  [ $num1 -ne $num2 ]
		#a.txt文本和b.txt文本进行数量比较
		then
		rm -rf $1/*
		#先删除再解析参数进行数据备份
		for i in $@
        do
		if  [ "$i" = "$1" ] 
		#设第一个参数是备份路径
		then
		    echo $1 "is backup"
		else 
		    if [ ! -e $i ]   
			#参数路径不存在的情况下
			then
		    echo $i "is no exit"
			else

			path2="$1$i"
			mkdir -p $path2
			path2=$(dirname $path2)
			cp -r $i $path2 
			fi
		fi	
		done	
			if [ $n -eq 0 ]  
			#第二个参数保存在a.txt中
			then              
				echo $i > /tmp/a.txt
				n=$((n+1))
			else             
			#后面的参数追加保存在a.txt中
				echo $i >> /tmp/a.txt	
			fi
		else
            grep -vFf  "/tmp/a.txt" "/tmp/b.txt"   1>/dev/null 2>&1 && result=0 || result=1
			#a.txt和b.txt中内容文件名字是否相同
			if [ "$result" == 0 ]
			#如果不同的话就先删再copy保存
            then
			    rm -rf $1/*
				for i in $@
				do
				
				if  [ "$i" = "$1" ] 
				#设第一个参数是备份路径
				then
					echo $1 "is backup"
				else 
				    if [ ! -e $i ]   
					#参数路径不存在的情况下
					then
					echo $i "is no exit"
					else

					path="$1$i"
					mkdir -p $path
					path=$(dirname $path)
					cp -r $i $path 
					fi
				fi	
				done	
					if [ $n -eq 0 ]  
					#第二个参数保存在a.txt中
					then              
						echo $i > /tmp/a.txt
						n=$((n+1))
					else             
					#后面的参数追加保存在a.txt中
						echo $i >> /tmp/a.txt	
					fi
				
			else
			#如果相同的话再进去比较文件的内容是否一致
              
			   for i in $@
			   do
			   if  [ "$i" = "$1" ] 
			   #设第一个参数是备份路径
			   then
				   echo $1 "is backup"
			   else 
				   if [ ! -e $i ]   
				   #参数路径不存在的情况下
				   then
				   echo $i "is no exit"
				   else
   			           path="$1$i"
					   diff -arq  $i $path 1>/dev/null 2>&1 && result=0 || result=1
					   #比较文件夹中文件的内容是否一致
					   if [ "$result" == 1 ]
					   #注意if语句括号内的空格
					   #不同的话,退出循环
					   then
					      break 
						else
						#相同的话就输出结果
						    echo "they are the same"
							
                        fi						  
					fi
                fi
                done	
                       			
   			           
					   if [ "$result" == 1 ]
					   #文件不同先进行删除,后再备份
					   then
					       rm -rf $1/*
					       for i in $@
						   do
						   
						   if [ "$i" = "$1" ] 
							#设第一个参数是备份路径
							then
								echo $1 "is backup"
							else 
							   if [ ! -e $i ]   
							   #参数路径不存在的情况下
							   then
							   echo $i "is no exit"
							   else
								   
								   path="$1$i"
								   mkdir -p $path
								   path=$(dirname $path)
								   cp -r $i $path 
								fi 
                            fi	
                            done	
								if [ $n -eq 0 ]  
								#第二个参数保存在a.txt中
								then              
									echo $i > /tmp/a.txt
									n=$((n+1))
								else             
								#后面的参数追加保存在a.txt中
									echo $i >> /tmp/a.txt	
								fi							
						
                       fi							
				   
               				
			fi	
		fi	                 
                            cp -f  $"/tmp/b.txt" $"/tmp/a.txt"		
fi	


IFS=$oldIFS				
				
				

	
