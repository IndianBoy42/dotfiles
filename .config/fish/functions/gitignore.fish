function gitignore
	set tmpfile (mktemp)
	curl https://www.toptal.com/developers/gitignore/api/$argv > $tmpfile
	cat $tmpfile | grep "!! ERROR"
	set errlines (cat $tmpfile | grep "!! ERROR" | wc -l)
	echo $errlines
	if [ $errlines -gt 0 ]
		echo "Not copying .gitignore as you have errors"
	else 
		cp $tmpfile ./.gitignore
	end
end
