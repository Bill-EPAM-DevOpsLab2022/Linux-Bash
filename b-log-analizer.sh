#!/bin/bash

if read -t 1; then
  LOGFILE=$(</dev/stdin)
else
  echo "No input received" >&2
  exit 1
fi

#echo "$LOGFILE"

#LOGFILE="./apache_logs.txt"

# Question 1: From which IP were the most requests?
echo "IP with most requests:"
echo "$LOGFILE" | awk '{print $1}' | sort | uniq -c | sort -rn | head -n 1

# Question 2: What is the most requested page?
echo "Most requested page:"
echo "$LOGFILE" | awk '{print $7}' | sort | uniq -c | sort -rn | head -n 1

# Question 3: How many requests were there from each IP?
echo "Requests per IP:"
echo "$LOGFILE" | awk '{print $1}' | sort | uniq -c | sort -rn

# Question 4: What non-existent pages were clients referred to?
echo "Non-existent pages:"
echo "$LOGFILE" | awk '{ if ($9 == 404) {print $7}}' | sort | uniq -c | sort -rn

# Question 5: What time did the site get the most requests?
echo "Busiest hour:"
echo "$LOGFILE" | awk '{print $4}' | cut -d: -f2 | sort | uniq -c | sort -rn | head -n 1

# Question 6: What search bots have accessed the site? (UA + IP)
echo "Search bots:"
echo "$LOGFILE" | awk '{if ($12 $13 $14 $15 $16 $17 ~ bot) {print $14 " " $15 " " $16 " " $17}}' | sort -u
