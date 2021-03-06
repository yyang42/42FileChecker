#!/bin/bash

if [ "$FILECHECKER_SH" == "1" ]
then

	COLUMNS=`tput cols`
	if [ "$COLUMNS" == "" ]
	then
		$COLUMNS=80;
	fi

	if [ "$OPT_NO_COLOR" == "0" ]
	then
		C_BLACKBG="\033[40m\033[37m"
		C_CLEAR="\033[0m"$C_BLACKBG
		C_YELLOW=$C_BLACKBG"\033[33;1m"
		C_RED=$C_BLACKBG"\033[31m\033[38;5;160m"
		C_GREEN=$C_BLACKBG"\033[32m\033[38;5;70m"
		C_CYAN=$C_BLACKBG"\033[36;1m"
		C_WHITE=$C_BLACKBG"\033[37;1m"
		C_BLUE=$C_BLACKBG"\033[34;1m"
		C_GREY=$C_BLACKBG"\033[1;30m"
		C_GREY=$C_BLACKBG"\033[38;5;239m"
		C_BLACK="\033[30;1m"
		C_INVERT="\033[48;5;17m""\033[38;5;104m"
		C_INVERTGREY="\033[48;5;233m""\033[38;5;95m"
	fi

	function display_error
	{
		echo $C_RED"  !!! $1 !!!"$C_CLEAR
	}

	function display_hr
	{
		local MARGIN
		(( MARGIN= $COLUMNS ))
		if [ "$1" == "" ]
		then
			printf $C_GREY""
		else
			printf "$1"
		fi
		printf "%"$MARGIN"s" "" | sed s/' '/"${c:=_}"/g | cut -c1-$MARGIN
		printf "$C_CLEAR"
	}

	function display_hr2
    {
        local MARGIN
        (( MARGIN= $COLUMNS ))
        printf $C_GREY""
	    printf "%"$MARGIN"s" "" | sed s/' '/"${c:=¯ }"/g | cut -c1-$MARGIN
	    printf $C_CLEAR""
	    if [ "$1" != "" ]
	    then
		    echo "$1";
		fi
	}

	function display_righttitle
	{
		local LEN MARGIN
		if [ "$1" != "" ]
		then
			LEN=${#1}
			(( MARGIN= $COLUMNS - $LEN))
			printf "%"$MARGIN"s" " "
			printf "$1\n"
		else
			printf "\n"
		fi
	}

	function display_center
	{
	    local LEN MARGIN
	    if [ "$1" != "" ]
		then
		    LEN=${#1}
		    (( MARGIN= ($COLUMNS - $LEN) / 2 ))
		    printf "%"$MARGIN"s" " "
			printf "$1"
			(( MARGIN= $MARGIN + ($COLUMNS - $LEN - $MARGIN * 2) ))
			printf "%"$MARGIN"s" " "
		else
			printf "\n"
		fi
	}

	function display_header
	{
		local MARGIN
		echo "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
		echo "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n "
		clear
		printf $C_INVERT""
		display_righttitle "V1.r$CVERSION"
		display_center "  _  _  ____  _____ _ _       ____ _               _              "
		display_center " | || ||___ \|  ___(_) | ___ / ___| |__   ___  ___| | _____ _ __  "
		display_center " | || |_ __) | |_  | | |/ _ \ |   | '_ \ / _ \/ __| |/ / _ \ '__| "
		display_center " |__   _/ __/|  _| | | |  __/ |___| | | |  __/ (__|   <  __/ |    "
		display_center "    |_||_____|_|   |_|_|\___|\____|_| |_|\___|\___|_|\_\___|_|    "
		display_center "    jgigault @ student.42.fr                    06 51 15 98 82    "
		display_center " "
		printf $C_CLEAR""
	}

	function display_footer
	{
		echo $C_WHITE""
		printf "%"$COLUMNS"s" "" | sed s/' '/"${c:=#}"/g | cut -c1-$COLUMNS
		echo $C_CLEAR""
	}

	function ft_atoi
	{
		local SELN
		if [ "$1" != "1" -a "$1" != "2" -a "$1" != "3" -a "$1" != "4" -a "$1" != "5" -a "$1" != "6" -a "$1" != "7" -a "$1" != "8" -a "$1" != "9" ]
		then
			SELN=`LC_CTYPE=C printf '%d' "'$1"`
			if (( $SELN >= 65 )) && (( $SELN <= 90 ))
			then
				(( SELN=$SELN - 65 + 10 ))
				printf "$SELN"
			else
				if (( $SELN >= 97 )) && (( $SELN <= 122 ))
				then
					(( SELN=$SELN - 97 + 10 ))
					printf "$SELN"
				else
					printf "0"
				fi
			fi
		else
			printf "$1"
		fi
	}

	function display_menu
	{
		local -a MENU FUNCS
		local TOTAL SEL LEN SELN TITLE
		SEL=""
		shift 1
		printf $C_INVERT""
		printf "%"$COLUMNS"s" " "
		printf "\n"
		while (( $# > 0 ))
        do
			if [ "$1" == "_" ]
			then
				printf "%"$COLUMNS"s" " "
				shift 1
			else
				(( TOTAL += 1 ))
				FUNCS[$TOTAL]="$1"
				MENU[$TOTAL]="$2"
				TITLE=`echo "$2" | sed 's/%/%%/g'`
				if (( $TOTAL < 10 ))
				then
					SELN=$TOTAL
				else
					(( SELN=65 + $TOTAL - 10 ))
					SELN=`echo "$SELN" | awk '{printf("%c", $0)}'`
				fi
				(( LEN=$COLUMNS - ${#2} - 9 ))
				printf "  "$SELN")    $TITLE "
				printf "%"$LEN"s" " "
				printf "\n"
				shift 2
			fi
        done
		printf "%"$COLUMNS"s" " "
		printf $C_CLEAR"\n"
		read -s -n 1 SEL
		SEL=`ft_atoi "$SEL"`
		while [ -z "${MENU[$SEL]}" -o "$(echo "${FUNCS[$SEL]}" | grep '^open ')" != "" ]
		do
			printf "\a"
			if [ "$(echo "${FUNCS[$SEL]}" | grep '^open ')" != "" ]
			then
				if [ -f "$(echo "${FUNCS[$SEL]}" | sed 's/^open //')" -o "$(echo "${FUNCS[$SEL]}" | grep http)" != "" ]
				then
					eval ${FUNCS[$SEL]}
				fi
			fi
			SEL=""
			read -s -n 1 SEL
			SEL=`ft_atoi "$SEL"`
		done
		printf "\n"
		if [ "${FUNCS[$SEL]}" != "" ]
		then
			eval ${FUNCS[$SEL]}
		fi
	}

	function get_config
	{
		local MYFILE MYPATH RET0
		MYFILE=`printf "$RETURNPATH/.my$1" | sed 's/ /\\ /g'`
#		MYFILE="$RETURNPATH/.my"$1
		if [ ! -f "$MYFILE" ]
		then
			touch "$MYFILE"
		fi
		MYPATH=`cat "$MYFILE"`
		if [ ! -d "$MYPATH" ]
		then
			printf "" > "$MYFILE"
			MYPATH=""
		fi
		printf "$MYPATH"
	}

	function save_config
	{
		local MYFILE RET0
		MYFILE=".my$1"
		RET0=`printf "$RETURNPATH/$MYFILE" | sed 's/ /\\ /g'`
		RET0=`echo "printf \"$2\" > \"$RET0\""`
		eval $RET0
	}

	function exit_checker
	{
		printf "\n"
		display_hr
		printf "\n\n\n\n\033[0m"
		tput cnorm
		clear
		exit
	}

	function configure_moulitest
	{
		display_header
		display_righttitle "$0 -> LIBFT MENU"
		check_libft_top "$2"
		printf $C_BLUE"  Configuring 'moulitest'...\n\n"$C_CLEAR
		case "$1" in
			"libft")
				echo "LIBFT_PATH = \"$2\"" > "$RETURNPATH"/moulitest/config.ini
				;;
			"gnl")
				echo "GET_NEXT_LINE_PATH = \"$2\"" > "$RETURNPATH"/moulitest/config.ini
				;;
			"ft_ls")
				echo "FT_LS_PATH = \"$2\"" > "$RETURNPATH"/moulitest/config.ini
				;;
			"ft_printf")
				echo "FT_PRINTF_PATH = \"$2\"" > "$RETURNPATH"/moulitest/config.ini
				;;
		esac
	}

	function check_norme
	{	if [ "$OPT_NO_NORMINETTE" == "0" ]; then
		local RET0 RET2 RET3 RET4 TOTAL TOTA2
		rm -f "$RETURNPATH"/.mynorminette
		cd "$MYPATH"
		RET0=$(find . -type f | sed '/^\.\/\./d' | grep -E \\.\[hc\]$ | tr '\n' ' ')
		RET2=`norminette "$RET0" 2>&1`
		cd "$RETURNPATH"
		echo "$RET2" > "$RETURNPATH"/.mynorminette
		RET2=`cat .mynorminette | grep Error`
		RET3=`cat .mynorminette | grep Warning`
		RET4=`cat .mynorminette | grep "command not found"`
		if [ "$RET2" == "" -a "$RET3" == "" -a "$RET4" == "" ]
		then
			printf $C_GREEN"  All files passed the tests"$C_CLEAR
		else
			if [ "$RET4" != "" ]
			then
				printf $C_RED"  Command not found"$C_CLEAR
			else
				if [ "$RET2" == "" ]
				then
					TOTAL=0
				else
					TOTAL=`echo "$RET2" | wc -l | sed 's/ //g'`
				fi
				if [ "$RET3" == "" ]
				then
					TOTA2=0
				else
					TOTA2=`echo "$RET3" | wc -l | sed 's/ //g'`
				fi
				(( TOTAL = $TOTAL + $TOTA2 ))
				printf $C_RED"  $TOTAL error(s) or warning(s)"$C_CLEAR
			fi
		fi
		else printf $C_GREY"  --Not performed--"$C_CLEAR; fi
	}

	function check_author
	{	if [ "$OPT_NO_AUTEUR" == "0" ]; then
		local AUTHORF AUTHORC AUTHORE AUTHORG
		AUTHORF="$MYPATH/auteur"
		if [ ! -f "$AUTHORF" ]
		then
			printf $C_RED"  File not found"$C_CLEAR
		else
			AUTHORC=`cat -e "$AUTHORF" | awk '{if (NR == 1) print}'`
			AUTHORE=`cat -e "$AUTHORF" | sed 's/\$$//' | awk '{if (NR == 1) print}'`
			AUTHORG=`cat -e "$AUTHORF" | awk '{if (NR == 1) print}'`
			if [ "$AUTHORE" == "$AUTHORG" ]
			then
				printf $C_RED"  No [Line Feed] character at the end of line"$C_CLEAR
			else
				printf $C_GREEN"  $AUTHORC"$C_CLEAR
			fi
		fi
		else printf $C_GREY"  --Not performed--"$C_CLEAR; fi
	}

	function display_spinner
	{
		local pid=$1
		local total_delay=0
		local total_delay2=240
		local delay=0.2
		local spinstr='|/-\'
		printf $C_BLUE""
		while [ "$(ps a | awk '{print $1}' | grep $pid)" ];
		do
			if (( $total_delay2 < 1 ))
			then
				kill $pid
				wait $! 2>/dev/null
				(( total_delay2 = $total_delay / 5 ))
				printf $C_RED"  Time out ($total_delay2 sec)"$C_CLEAR > $RETURNPATH/.myret
			fi
			if [ "$OPT_NO_TIMEOUT" == "0" ]
			then
				(( total_delay += 1 ))
			fi
			local temp=${spinstr#?}
			printf "  [%c] " "$spinstr"
			local spinstr=$temp${spinstr%"$temp"}
			if (( $total_delay >= 5 ))
			then
				(( total_delay2 = ( 209 - $total_delay ) / 5 ))
				printf "[time out: %02d]" "$total_delay2"
			fi
			sleep $delay
			printf "\b\b\b\b\b\b"
			if (( $total_delay >= 5 ))
			then
				printf "\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
			fi
		done
		printf "                     \b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b"
		printf $C_CLEAR""
	}

	function check_fileexists
	{
		local i TOTAL RET0 VALPARAM
		if [ "$1" != "" ]
		then
			i=0
			VALPARAM=`eval echo \$1[\$i]`
			while [ "${!VALPARAM}" != "" ]
			do
				if [ ! -f "$MYPATH/${!VALPARAM}" ]
				then
					(( TOTAL += 1 ))
					RET0=$RET0"Not Found: ${!VALPARAM}\n"
				fi
				(( i += 1 ))
				VALPARAM=`eval echo \$1[\$i]`
			done
			printf "$RET0" > "$RETURNPATH"/.my$1
			if [ "$RET0" == "" ]
			then
				printf $C_GREEN"  All files were found"$C_CLEAR
			else
				if (( $TOTAL == 1 ))
				then
					printf $C_RED"  1 file is missing"$C_CLEAR
				else
					printf $C_RED"  $TOTAL files are missing"$C_CLEAR
				fi
			fi
		else
			printf $C_RED"  An error occured (Files list missing)"$C_CLEAR
		fi
	}

	function check_create_tmp_dir
	{
		if [ ! -d "$RETURNPATH"/tmp ]
		then
			mkdir "$RETURNPATH"/tmp
		else
			rm -rf "$RETURNPATH"/tmp/*
		fi
	}

	function check_kill_by_name
	{
		local PROCESSID PROCESSID0 PROGNAME PROCESSCOUNT
		PROGNAME="$1"
		if [ "$PROGNAME" != "" ]
		then
			PROCESSID=`ps | grep "$1" | grep -v "grep" | sed 's/^[ ]*//g' | cut -d" " -f1`
			if [ "$PROCESSID" != "" ]
			then
				PROCESSCOUNT=`echo "$PROCESSID" | wc -l`
				while (( $PROCESSCOUNT > 0 ))
				do
					(( PROCESSCOUNT -= 1 ))
					PROCESSID0=`echo "$PROCESSID" | awk '{print; exit}'`
					kill $PROCESSID0
					wait $! 2>/dev/null
				done
			fi
		fi
	}

fi