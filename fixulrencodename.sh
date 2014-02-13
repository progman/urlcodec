#!/bin/bash
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# 0.0.1
# Alexey Potehin <gnuplanet@gmail.com>, http://www.gnuplanet.ru/doc/cv
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# check depends
function check_prog()
{
	for i in ${1};
	do
		if [ "$(which ${i})" == "" ];
		then
			echo "FATAL: you must install \"${i}\"...";
			return 1;
		fi
	done

	return 0;
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# general function
function main()
{
	check_prog "echo mktemp rm urlcodec";
	if [ "${?}" != "0" ];
	then
		return 1;
	fi


	local TMP1;
	TMP1="$(mktemp)";
	if [ "${?}" != "0" ];
	then
		echo "can't make tmp file";
		exit 1;
	fi

	local TMP2;
	TMP2="$(mktemp)";
	if [ "${?}" != "0" ];
	then
		echo "can't make tmp file";
		exit 1;
	fi


	ls -1 > "${TMP1}";
	if [ "${?}" != "0" ];
	then
		echo "ERROR: can't list dir";
		rm -rf -- "${TMP1}" &> /dev/null;
		rm -rf -- "${TMP2}" &> /dev/null;
		return 1;
	fi


	local FILE1;
	local FILE2;

	while read -r FILE1;
	do

		echo "${FILE1}" > "${TMP2}";

		FILE2="$(urlcodec < "${TMP2}")";
		if [ "${?}" != "0" ];
		then
			echo "ERROR: invalid name \"${FILE1}\"";
			rm -rf -- "${TMP1}" &> /dev/null;
			rm -rf -- "${TMP2}" &> /dev/null;
			return 1;
		fi

		if [ "${FILE1}" != "${FILE2}" ];
		then

			if [ "${1}" != "-f" ];
			then
				echo "\"${FILE1}\" -> \"${FILE2}\"";
				continue;
			fi

			mv "${FILE1}" "${FILE2}" &> /dev/null;
			if [ "${?}" != "0" ];
			then
				echo "ERROR: can't rename file \"${FILE1}\"";
				rm -rf -- "${TMP1}" &> /dev/null;
				rm -rf -- "${TMP2}" &> /dev/null;
				return 1;
			fi
		fi

	done < "${TMP1}";


	rm -rf -- "${TMP1}" &> /dev/null;
	rm -rf -- "${TMP2}" &> /dev/null;


	if [ "${1}" != "-f" ];
	then
		echo;
		echo "use ${0} -f for force rename";
	fi


	return 0;
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
main "${@}";

exit "${?}";
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
