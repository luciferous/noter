#!/bin/sh

# Render header with substitutions from environment.
cat <<EOF
<!doctype html>
<html lang="$lang">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>$site_title</title>
    <link href="${prefix}theme/style.css" rel="stylesheet">
    <link rel="alternate" type="application/atom+xml" href="${prefix}feed.atom" title="Atom Feed">
  </head>
  <body>
    <h1>$site_title</h1>
    <ul>
EOF

while IFS=$'\t' read -r FILE TITLE UPDATED; do
  cat <<EOF
      <li><a href="${prefix}$FILE">$TITLE</a></li>
EOF
done

# Print footer.
cat <<EOF
    </ul>
  </body>
</html>
EOF
