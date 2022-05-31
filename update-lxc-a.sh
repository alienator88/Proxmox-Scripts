#!/bin/bash
set -e
BL=`echo "\033[36m"`
GN=`echo "\033[1;92m"`
CL=`echo "\033[m"`

function header_info {
echo -e "${BL}
                _                   _    _           _       _         _     __   _______ 
     /\        | |                 | |  | |         | |     | |       | |    \ \ / / ____|
    /  \  _   _| |_ ___    ______  | |  | |_ __   __| | __ _| |_ ___  | |     \ V / |     
   / /\ \| | | | __/ _ \  |______| | |  | | '_ \ / _  |/ _  | __/ _ \ | |      > <| |     
  / ____ \ |_| | || (_) |          | |__| | |_) | (_| | (_| | ||  __/ | |____ / . \ |____ 
 /_/    \_\__,_|\__\___/            \____/| .__/ \__,_|\__,_|\__\___| |______/_/ \_\_____|
                                          | |                                             
                                          |_|                                                                                                       
${CL}"
}
header_info

containers=$(pct list | awk 'NR>1 { print $1, $(NF)}')

function update_container() {
  container=$1
  cname=$2
  clear
  header_info
  echo -e "${BL}[Info]${GN} Updating${BL} $cname ($container) ${CL} \n"
}

for container in $containers
do
  update_container $container
done; wait


echo -e "${GN} Finished, all containers updated. ${CL} \n"
