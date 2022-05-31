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

containers=$(pct list | tail -n +2 | cut -f1 -d' ')

function update_container() {
  container=$1
  name=$2
  clear
  header_info
  echo -e "${BL}[Info]${GN} Updating${BL} $name ($container) ${CL} \n"
  pct exec $container -- bash -c "apt update && apt upgrade -y && apt autoremove -y"
}

for container in $containers
do

  status=`pct status $container`
  name=`pct config $container | grep ^hostname | sed 's/.* //'`

  if [ "$status" == "status: stopped" ]; then
    clear
    header_info
    echo -e "${BL}[Info]${GN} Starting${BL} $name ($container) ${CL} \n"
    pct start $container
    clear
    header_info
    echo -e "${BL}[Info]${GN} Waiting for${BL} $name ($container) ${CL}${GN}to start ${CL} \n"
    sleep 5
    update_container $container $name
    clear
    header_info
    echo -e "${BL}[Info]${GN} Shutting down${BL} $name ($container) ${CL} \n"
    pct shutdown $container &
  elif [ "$status" == "status: running" ]; then
    update_container $container $name
  fi

done; wait

clear
header_info
echo -e "${GN} Finished, all containers updated. ${CL} \n"
