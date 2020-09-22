#!/bin/bash

set -e

typeset -r root="/srv/vrpserv.e"
typeset -r graph_dir_rel="/srv/roads/Texas"
typeset -r report_name="rast-report.csv"
typeset -r rastxopt_rel="/srv/rastxopt-dto.0/rastxopt"
typeset -r elf_resolver_rel="/lib/x86_64-linux-gnu/ld-2.13.so"
typeset -r log_file="/srv/vrpserv.e/home/y.kuznetsov/assign.log"
typeset -r rxpt_stderr="rxpt_stderr.txt"
typeset -r rxpt_stdout="rxpt_stdout.txt"
typeset -r subtractor="/srv/vrpserv.e/home/y.kuznetsov/PerlUtils/sol_subtracktor.pl"
typeset -r presenter="/srv/vrpserv.e/home/y.kuznetsov/PerlUtils/sol_presenter.pl"

[[ -n "$1" && -n "$2" && -n "$3"  ]] || { print_usage && exit 1; }
for fn in "$1" "$2"
do
	[[ -f "$fn" ]] || { echo unable to locate file "'$fn'" && exit 1; }
done
[[ -d "$3" ]] || { echo unable to locate working directory "'$3'" && exit 1; }


typeset -r task_pname="$1"
typeset -r conf_pname="$2"
typeset -r work_dir="$3"
typeset -r task_pname_rel=${task_pname#"$root"}
typeset -r conf_pname_rel=${conf_pname#"$root"}




print_usage() { echo \<rast-task\> \<rast-config\> \<work_directory\>; }

# $1 = rast_task $2 = rast_config $3 = solution_xml $4 = working_directory
solve_with_rast()
{
	[[ -f "$1" ]] || { echo unable to locate file "'$1'" 29084289 && exit 1; }
	[[ -f "$2" ]] || { echo unable to locate file "'$2'" 67290054 && exit 1; }

	work_dir_rel=${4#"$root"}
	chroot "$root"  "$elf_resolver_rel" "$rastxopt_rel" -gdir "$graph_dir_rel" -file "$work_dir_rel/$1" -conf "$work_dir_rel/$2" -output "$work_dir_rel/$report_name" -solxml "$work_dir_rel/$3" 1>>"$4/$rxpt_stdout" 2>>"$4/$rxpt_stderr"

	echo chroot "$root"  "$elf_resolver_rel" "$rastxopt_rel" -gdir "$graph_dir_rel" -file "$work_dir_rel/$1" -conf "$work_dir_rel/$2" -output "$work_dir_rel/$report_name" -solxml "$work_dir_rel/$3" >> "$log_file"
	echo >> "$log_file"
}

# $1 = solution.xml
clear_solution()
{
	[[ -f "$1" ]] || { echo unable to locate file "'$1'" 23478 && exit 1; }

	# <rtept lon="-95.26043000" lat="29.76079400" />
	sed -i "s/<rtept[^<>\/]*\/>//g" "$1"
	sed -i "/^\s*$/d" "$1"
	echo "clear '$1' from <rtept.../>" >> "$log_file"
	echo >> "$log_file"
}

# $1 = solution_name $2 = presentation_name
present_solution()
{
	[[ -f "$1" ]] || { echo unable to locate file "'$1'" 283746 && exit 1; }

	# ./sol_presenter.pl:  [-ooo <its value>] [-sol-xml <its value>]
	"$presenter" -sol-xml "$1" -no-term  > "$2"
	echo "$presenter" -sol-xml "$1" -no-term \> "$2" >> "$log_file"
	echo >> "$log_file"
}

# $1 = task $2 = solution $3 = new_task
subtract_solution()
{
	[[ -f "$1" ]] || { echo unable to locate file "'$1'" 0988924 && exit 1; }
	[[ -f "$2" ]] || { echo unable to locate file "'$2'" 6589713 && exit 1; }

	"$subtractor" -task "$1" -sol-xml "$2" -no-term  > "$3"
	echo "$subtractor" -task "$1" -sol-xml "$2" -no-term  \> "$3" >> "$log_file"
	echo >> "$log_file"
}

# task_pname config_pname work_dir



# proc_assign.sh /srv/vrpserv.e/home/y.kuznetsov/dto_july_24/rast-task.csv /srv/vrpserv.e/home/y.kuznetsov/dto_july_24/rast-config.txt /srv/vrpserv.e/home/y.kuznetsov/work 



pushd "$work_dir"

seconds=$(date +%s)
uuid=$(uuidgen | tr -d '-' | cut -b 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16)
temp_subdir="$seconds-$uuid"
if [[ -n `find . -maxdepth 1 -type f` ]];
then
	mkdir "$temp_subdir"
	find . -maxdepth 1 -type f -print0 | xargs -0 mv -t "./$temp_subdir"
fi


ln "$task_pname" "task-1.csv"
ln "$conf_pname" "config.txt"


echo "*****  $(date +'%Y-%M-%d %H:%M:%S') *****" >> "$log_file" 
echo "TASK = $task_pname" >> "$log_file"
echo "CONFIG = $conf_pname" >> "$log_file"
echo >> "$log_file"

###### 1
echo 'step 1...' >> "$log_file"
echo >> "$log_file"
# $1 = rast_task $2 = rast_config $3 = solution_xml $4 = working_directory
solve_with_rast "task-1.csv"  "config.txt" "sol-1.xml" "$work_dir"
clear_solution "sol-1.xml"
present_solution "sol-1.xml" "_routes_1.csv"
subtract_solution "task-1.csv" "sol-1.xml" "task-2.csv"


###### 2
echo 'step 2...' >> "$log_file"
echo >> "$log_file"
# $1 = rast_task $2 = rast_config $3 = solution_xml $4 = working_directory
solve_with_rast "task-2.csv"  "config.txt" "sol-2.xml" "$work_dir"
clear_solution "sol-2.xml"
present_solution "sol-2.xml" "_routes_2.csv"
subtract_solution "task-2.csv" "sol-2.xml" "task-3.csv"

###### 3
echo 'step 3...' >> "$log_file"
echo >> "$log_file"
# $1 = rast_task $2 = rast_config $3 = solution_xml $4 = working_directory
solve_with_rast "task-3.csv"  "config.txt" "sol-3.xml" "$work_dir"
clear_solution "sol-3.xml"
present_solution "sol-3.xml" "_routes_3.csv"
subtract_solution "task-3.csv" "sol-3.xml" "task-4.csv"


###### 4
echo 'step 4...' >> "$log_file"
echo >> "$log_file"
# $1 = rast_task $2 = rast_config $3 = solution_xml $4 = working_directory
solve_with_rast "task-4.csv"  "config.txt" "sol-4.xml" "$work_dir"
clear_solution "sol-4.xml"
present_solution "sol-4.xml" "_routes_4.csv"
subtract_solution "task-4.csv" "sol-4.xml" "task-5.csv"


###### 5
echo 'step 5...' >> "$log_file"
echo >> "$log_file"
# $1 = rast_task $2 = rast_config $3 = solution_xml $4 = working_directory
solve_with_rast "task-5.csv"  "config.txt" "sol-5.xml" "$work_dir"
clear_solution "sol-5.xml"
present_solution "sol-5.xml" "_routes_5.csv"


echo "finish as OK" >> "$log_file"

popd


