#!/bin/sh

cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <id>$full_prefix</id>
  <title>$site_title</title>
  <updated>$now</updated>
EOF

while IFS=$'\t' read -r FILE TITLE UPDATED; do
  cat <<EOF
  <entry>
    <id>${full_prefix}$FILE</id>
    <title>$TITLE</title>
    <updated>$UPDATED</updated>
  </entry>
EOF
done

cat <<EOF
</feed>
EOF
