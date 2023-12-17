#!/bin/bash -e

input=$1

if [ ! -e $input ]
then
	echo "Такого файла не существует"
	exit 1
fi

output=$(grep -o "&Output:\w*[.]*\w*" $input | cut -d ':' -f 2)

if [ -z $output ]
then
  echo "Нельзя прочитать файл вывода"
  exit 2
fi

if [ -e $output ] 
then
	rm $output
fi

workDir=$(pwd)
tempDir=$(mktemp -d)         
trap "rm -rf ${tempDir}" EXIT HUP INT QUIT PIPE TERM

cp -a $input $tempDir
cd $tempDir

g++ $input -o $output
if [ $? -ne 0 ]
then
	echo "Компиляция не удалась, произошла какая-то ошибка"
	exit 3
fi

mv $output $workDir
cd $workDir

echo "Компиляция произошла успешно"
exit 0