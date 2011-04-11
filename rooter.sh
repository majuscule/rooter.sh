# cd to the project root (identified by the presence of a SCM directory, like
# .git, or .bzr)
#
# INSTALL:
#   * put something like this in your .bashrc:
#     . /path/to/cdr.sh
#
#   This installs the 'cdr' command for use.
#
# USE:
#   $ pwd
#   /home/yeban/drizzle/drizzle/libdrizzle-2.0/libdrizzle
#   $ cdr
#   $ pwd
#   /home/yeban/src/drizzle/drizzle

# array of some known SCM directories
declare -a scmdirs=('.git' '.bzr')

# return true if the given directory has an SCM subdirectory
_has_scm_dir() {
	if [ -d $1 ]
	then
		for scmdir in $scmdirs
		do
			if [ -d "$1/$scmdir" ]
			then
				return 0
			fi
		done
	fi
	
	return 1
}

_get_root_dir() {
	root_dir=$1
	
	if [ -d $dir ]
	then
		while [ $dir != "/" ]
		do
			if _has_scm_dir $dir
			then
				root_dir=$dir
				return 0
			fi
			dir=$(dirname $dir)
		done
	fi
	
	return 1
}

# cd to the project root
cdr() {
	# use the first argument or the current working directory
	[[ -n "$1" ]] && dir="$1" || dir="$(pwd)"
	
	[[ "$dir" = ".." ]] && dir="$(dirname `pwd`)"
	[[ "$dir" = "."  ]] && dir="$(pwd)"
	
	if [ -d $dir ]
	then
		_get_root_dir $dir
	fi
	
	echo $root_dir
	
	cd $root_dir
}
