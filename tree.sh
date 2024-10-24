#!/bin/bash

function show_help() {
	echo "Displays a tree structure of files and directories for a specified path."
	echo "If path is not specified, displays the structure of current directory."
	echo
	echo "Usage:"
	echo "		bash tree.sh [OPTIONS] [PATH]"
	echo
	echo "Examples:"
	echo "		bash tree.sh -h"
	echo "		bash tree.sh /dev/"
	echo "		bash tree.sh -d 3 /boot/"
	echo "		bash tree.sh -l 10 /bin/"
	echo
	echo "OPTIONS:"
	echo -e "	-h, --help		shows this help"
	echo -e "	-t, --top		displays only the top level of files and directories"
	echo -e "	-d N, --depth N		limits search recursion to N levels depth"
	echo -e "	-l N, --limit N		don't display directories with more that N elements"
}

function print_files() {
	local location=$1
	declare -a pref=$2
	local depth=$3
	
	local next_depth=$(( depth + 1 ))

	local postf=""

	IFS=$'\n'
	declare -a files=( $(ls $location) )
	unset IFS

	local files_count=${#files[@]}
	
	local limit_flag=0
	if [[ $files_limit -ne 0 ]] && [[ $files_count -gt $files_limit ]]; then
		limit_flag=1
	fi
	
	if [[ $files_count -gt 0 ]]; then
		local last="${files[$(( files_count - 1 ))]}"
		
		for file in "${files[@]}"; do
			for pr in ${pref[@]}; do
				if [[ $pr == "1" ]]; then
					echo -n "│  "
				else
					echo -n "   "
				fi
			done

			if [[ "$file" == "$last" ]] || [[ $limit_flag -eq 1 ]]; then
				postf=" 0"
				echo -n "└─ "
			else
				postf=" 1"
				echo -n "├─ "
			fi
			
			if [[ $limit_flag -eq 1 ]]; then
				echo "... ($files_count)"
				return
			else
				echo "$file"
			fi

			if [[ $max_depth -eq 0 ]] || [[ $next_depth -le $max_depth ]]; then
				if [[ -d "$location/$file" ]]; then
					print_files "$location/$file" "${pref[@]}$postf" $next_depth
				fi
			fi
		done
	fi
}

function validate_argument() {
	if [[ -z $1 ]]; then
		echo "Invalid argument"
		exit 1
	fi
}

function main() {
	local path="$1"
	if [[ -z $path ]]; then
		path=$(pwd);
	fi
	
	echo "."
	print_files "$path" "" 1
}

max_depth=0
files_limit=0

for opt in "$@"; do
	case $opt in
		-h|--help)
			show_help
			exit 0 ;;
		-t|--top)
			max_depth=1
			shift ;;
		-d|--depth)
			validate_argument $2
			max_depth=$2
			shift 2 ;;
		-l|--limit)
			validate_argument $2
			files_limit=$2
			shift 2 ;;
		-*|--*)
			echo "Unknown option: $opt"
			exit 1 ;;
		*)
			;;
	esac
done

main "$1"
