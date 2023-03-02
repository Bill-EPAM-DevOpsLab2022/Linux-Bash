#!/bin/bash

#Get subnet CIDR basing on the current local IP CIDR
function get_sub_curip() {
  cidr=$(ip -4 addr show $(ip -4 route list 0/0 | awk '{print $5}') | grep inet | awk '{print $2}' | cut -d '/' -f2)
  ip=$(ip -4 addr show $(ip -4 route list 0/0 | awk '{print $5}') | grep inet | awk '{print $2}' | cut -d '/' -f1)

  #echo $cidr
  #echo $ip

  # convert CIDR to netmask
  netmask=$((0xffffffff << (32 - $cidr)))
  netmask=$(printf "%d.%d.%d.%d\n" $(($netmask>>24 & 0xff)) $(($netmask>>16 & 0xff)) $(($netmask>>8 & 0xff)) $(($netmask & 0xff)))

  #echo $netmask

  # calculate subnet address
  IFS=. read -r i1 i2 i3 i4 <<< "$ip"
  IFS=. read -r m1 m2 m3 m4 <<< "$netmask"
  subnet=$(printf "%d.%d.%d.%d\n" $((i1 & m1)) $((i2 & m2)) $((i3 & m3)) $((i4 & m4)))

  echo $subnet/$cidr
}

# Function to display help text
function display_help() {
  echo "Usage: $0 [OPTION]"
  echo "Options:"
  echo "  --all         Display IP addresses and symbolic names of all hosts in current subnet"
  echo "  --target      Display list of open system TCP ports"
  echo "  -h, --help    Display this help text"
  exit 1
}

# Function to display IP addresses and symbolic names of all hosts in current subnet
function display_all() {
  nmap -sP $(get_sub_curip) | grep "Nmap scan report" | awk '{print $5}'
}

# Function to display list of open system TCP ports
function display_target() {
  netstat -tln | tail -n+3 | awk '{print $4}' | awk -F ":" '{print $NF}' | sort -n | uniq
}

# Parse command-line arguments
if [[ $# -eq 0 ]]; then
  display_help
elif [[ $# -gt 0 ]]; then
  key="$1"

  case $key in
    -h|--help)
      display_help
      ;;
    --all)
      display_all
      ;;
    --target)
      display_target
      ;;
    *)
      echo "Unknown option: $key"
      display_help
      ;;
  esac
  shift
fi
