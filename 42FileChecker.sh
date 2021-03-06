#!/bin/bash

####################################################################
#  _  _  ____  _____ _ _       ____ _               _              #
# | || ||___ \|  ___(_) | ___ / ___| |__   ___  ___| | _____ _ __  #
# | || |_ __) | |_  | | |/ _ \ |   | '_ \ / _ \/ __| |/ / _ \ '__| #
# |__   _/ __/|  _| | | |  __/ |___| | | |  __/ (__|   <  __/ |    #
#    |_||_____|_|   |_|_|\___|\____|_| |_|\___|\___|_|\_\___|_|    #
#    jgigault @ student.42.fr                    06 51 15 98 82    #
####################################################################

FILECHECKER_SH=1
if [ ! -f .myrev ]; then git shortlog -s | awk 'BEGIN {rev=0} {rev+=$1} END {printf rev}' > .myrev 2>/dev/null; fi
CVERSION=$(cat .myrev 2>/dev/null)
if [ "$CVERSION" == "" ]; then CVERSION="???"; fi
RETURNPATH=$(pwd | sed 's/ /\ /g')
OPT_NO_UPDATE=0
OPT_NO_COLOR=0
OPT_NO_TIMEOUT=0
OPT_NO_NORMINETTE=0
OPT_NO_AUTEUR=0
OPT_NO_MOULITEST=0
OPT_NO_SPEEDTEST=0
OPT_NO_LEAKS=0
OPT_NO_BASICTESTS=0
OPT_NO_MAKEFILE=0
OPT_NO_FORBIDDEN=0
OPT_NO_STATICDECLARATIONS=0
OPT_NO_LIBFTFILESEXIST=0
OPT_NO_GNLMULTIPLEFD=0
OPT_NO_GNLONESTATIC=0
OPT_NO_GNLMACRO=0

i=1
while (( i <= $# ))
do
	case "${!i}" in
		"--no-update") OPT_NO_UPDATE=1 ;;
		"--no-color") OPT_NO_COLOR=1 ;;
		"--no-timeout") OPT_NO_TIMEOUT=1 ;;
		"--no-norminette") OPT_NO_NORMINETTE=1 ;;
		"--no-auteur") OPT_NO_AUTEUR=1 ;;
		"--no-moulitest") OPT_NO_MOULITEST=1 ;;
		"--no-speedtest") OPT_NO_SPEEDTEST=1 ;;
		"--no-leaks") OPT_NO_LEAKS=1 ;;
		"--no-basictests") OPT_NO_BASICTESTS=1 ;;
		"--no-makefile") OPT_NO_MAKEFILE=1 ;;
		"--no-forbidden") OPT_NO_FORBIDDEN=1 ;;
		"--no-staticdeclarations") OPT_NO_STATICDECLARATIONS=1 ;;
		"--no-libftfilesexists") OPT_NO_LIBFTFILESEXIST=1 ;;
		"--no-gnlmultiplefd") OPT_NO_GNLMULTIPLEFD=1 ;;
		"--no-gnlonestatic") OPT_NO_GNLONESTATIC=1 ;;
		"--no-gnlmacro") OPT_NO_GNLMACRO=1 ;;
	esac
	(( i += 1 ))
done

source includes/utils.sh
source includes/libft.sh
source includes/get_next_line.sh
source includes/ft_ls.sh
source includes/ft_printf.sh
source includes/transition.sh
source includes/update.sh
source includes/credits.sh
source includes/forbidden.sh
source includes/makefile.sh
source includes/leaks.sh
source includes/speedtest.sh

function main
{
	tput civis
	display_header
	printf "\n\n"
	display_menu\
		""\
		check_libft "libft"\
		check_gnl "get_next_line"\
		check_ft_ls "ft_ls"\
		check_ft_printf "ft_printf"\
		"_"\
		display_credits "CREDITS"\
		"open https://github.com/jgigault/42FileChecker/issues/new" "REPORT A BUG"\
		exit_checker "EXIT"
}

display_header_transition
if [ "$OPT_NO_UPDATE" == "0" ]
then
	update
fi
main